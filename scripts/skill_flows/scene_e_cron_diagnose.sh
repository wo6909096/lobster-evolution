#!/usr/bin/env bash
# input: cron 任务 ID、回看条数、可选回执文件和仓库路径。
# output: 执行通道探针与 cron 诊断，并可选追加执行回执 lint。
# pos: scripts/skill_flows/scene_e_cron_diagnose.sh；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。

set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "${THIS_DIR}/common.sh"

job_id=""
limit="5"
reply_file=""
mode="success"

usage() {
  cat <<'USAGE'
Usage: scene_e_cron_diagnose.sh --id <job-id> [options]

Options:
  --limit <n>                Recent run count (default: 5)
  --reply-file <path>        Optional receipt file for lint
  --mode <success|failure>   Receipt lint mode (default: success)
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --id) job_id="${2:-}"; shift 2 ;;
    --limit) limit="${2:-}"; shift 2 ;;
    --reply-file) reply_file="${2:-}"; shift 2 ;;
    --mode) mode="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

[[ -n "$job_id" ]] || { echo "missing required arg: --id" >&2; usage; exit 2; }

probe_script="$(skill_script_path cron-ops-hardening channel_probe.sh)"
diagnose_script="$(skill_script_path cron-ops-hardening cron_diagnose.sh)"
receipt_lint="$(skill_script_path execution-receipt-enforcer receipt_lint.sh)"
require_executable "$probe_script"
require_executable "$diagnose_script"

if [[ -n "$reply_file" ]]; then
  [[ -f "$reply_file" ]] || { echo "reply file not found: $reply_file" >&2; exit 2; }
  require_executable "$receipt_lint"
fi

echo "[scene-e] step 1/3: channel probe"
run_step bash "$probe_script"

echo "[scene-e] step 2/3: cron diagnose"
run_step bash "$diagnose_script" --id "$job_id" --limit "$limit"

if [[ -n "$reply_file" ]]; then
  echo "[scene-e] step 3/3: optional receipt lint"
  run_step bash "$receipt_lint" --mode "$mode" --file "$reply_file"
else
  echo "[scene-e] step 3/3: skip receipt lint (no --reply-file)"
fi

echo "[scene-e] done"
