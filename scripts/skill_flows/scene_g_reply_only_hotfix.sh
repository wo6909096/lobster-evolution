#!/usr/bin/env bash
# input: 可选会话日志路径、检查窗口、回退模型 ID、是否应用模型切换。
# output: 诊断“只回复不执行”风险，输出 toolUse 统计，并可选切换模型+重启网关。
# pos: scripts/skill_flows/scene_g_reply_only_hotfix.sh；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。

set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "${THIS_DIR}/common.sh"

session_file=""
window="120"
fallback_model="sub2api/gpt-5.2-codex"
apply_model_switch="false"
restart_gateway="false"

usage() {
  cat <<'USAGE'
Usage: scene_g_reply_only_hotfix.sh [options]

Options:
  --session-file <path>      Optional session jsonl. Default: latest main session
  --window <n>               Analyze last N lines (default: 120)
  --fallback-model <model>   Fallback model when applying switch
  --apply-model-switch       Apply `openclaw models set <fallback-model>`
  --restart-gateway          Restart gateway after model switch
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session-file) session_file="${2:-}"; shift 2 ;;
    --window) window="${2:-}"; shift 2 ;;
    --fallback-model) fallback_model="${2:-}"; shift 2 ;;
    --apply-model-switch) apply_model_switch="true"; shift ;;
    --restart-gateway) restart_gateway="true"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

if ! [[ "$window" =~ ^[0-9]+$ ]] || [[ "$window" -le 0 ]]; then
  echo "--window must be a positive integer" >&2
  exit 2
fi

if [[ -z "$session_file" ]]; then
  session_dir="$HOME/.openclaw/agents/main/sessions"
  session_file="$(python3 - "$session_dir" <<'PY'
import glob
import os
import sys

session_dir = sys.argv[1]
candidates = [
    p for p in glob.glob(os.path.join(session_dir, "*.jsonl"))
    if os.path.basename(p) != "sessions.jsonl"
]
if not candidates:
    sys.exit(1)
candidates.sort(key=lambda p: os.path.getmtime(p), reverse=True)
print(candidates[0])
PY
  )" || {
    echo "failed to resolve latest session file from $session_dir" >&2
    exit 2
  }
fi

[[ -f "$session_file" ]] || {
  echo "session file not found: $session_file" >&2
  exit 2
}

echo "[scene-g] step 1/5: inspect channel health"
run_step openclaw channels status --probe --json

echo "[scene-g] step 2/5: inspect current model"
run_step openclaw config get agents.defaults.model --json

echo "[scene-g] step 3/5: analyze recent session behavior"
python3 - "$session_file" "$window" <<'PY'
import json
import re
import sys

path = sys.argv[1]
window = int(sys.argv[2])

promise_re = re.compile(
    r"开始了|执行中|马上给你结果|下一条再汇报|一分钟后|稍后回复|我现在就去|我现在立刻",
    re.IGNORECASE,
)

with open(path, "r", encoding="utf-8") as f:
    lines = f.readlines()

sample = lines[-window:]
assistant_msgs = 0
tooluse_events = 0
promise_hits = []

for raw in sample:
    raw = raw.strip()
    if not raw:
        continue
    try:
        rec = json.loads(raw)
    except json.JSONDecodeError:
        continue

    msg = rec.get("message", {})
    role = msg.get("role")

    if role == "assistant":
        assistant_msgs += 1
        if msg.get("stopReason") == "toolUse":
            tooluse_events += 1

        for part in msg.get("content", []):
            if part.get("type") == "toolCall":
                tooluse_events += 1
            if part.get("type") == "text":
                text = part.get("text", "")
                if promise_re.search(text):
                    snippet = text.replace("\n", " ").strip()
                    promise_hits.append(snippet[:160])

    if role == "toolResult":
        tooluse_events += 1

risk = "low"
if assistant_msgs >= 3 and tooluse_events == 0 and promise_hits:
    risk = "high"
elif assistant_msgs >= 3 and tooluse_events == 0:
    risk = "medium"

print(f"session_file: {path}")
print(f"sample_lines: {len(sample)}")
print(f"assistant_messages: {assistant_msgs}")
print(f"tooluse_events: {tooluse_events}")
print(f"promise_phrase_hits: {len(promise_hits)}")
print(f"reply_only_risk: {risk}")
if promise_hits:
    print("promise_examples:")
    for item in promise_hits[:5]:
        print(f"- {item}")
PY

if [[ "$apply_model_switch" == "true" ]]; then
  echo "[scene-g] step 4/5: apply fallback model switch"
  run_step openclaw models set "$fallback_model"
  run_step openclaw config get agents.defaults.model --json

  if [[ "$restart_gateway" == "true" ]]; then
    echo "[scene-g] step 5/5: restart gateway"
    if openclaw gateway restart; then
      echo "[scene-g] gateway restart ok"
    else
      echo "[scene-g] gateway restart failed; fallback to status probe"
      run_step openclaw gateway status
    fi
  else
    echo "[scene-g] step 5/5: skip gateway restart"
  fi
else
  echo "[scene-g] step 4/5: skip model switch"
  echo "[scene-g] step 5/5: skip gateway restart"
fi

cat <<'TIP'
[scene-g] next message template (copy to Feishu):
执行模式：先执行后回复。在 /Users/liyuanyuan/lobster-evolution 运行 `git status -sb` 与 `git log --oneline -5`。
回复必须包含：命令输出摘要 + 可验证证据；若失败仅返回失败回执（失败命令、原始错误、下一步）。
禁止“开始了/执行中/一分钟后回复”。
TIP

echo "[scene-g] done"
