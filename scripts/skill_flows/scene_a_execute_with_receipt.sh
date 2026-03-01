#!/usr/bin/env bash
# input: 可选领域命令、回执文件路径、回执模式(success/failure)与仓库路径。
# output: 先执行领域命令（可选），再用 execution-receipt-enforcer 校验回执质量。
# pos: scripts/skill_flows/scene_a_execute_with_receipt.sh；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。

set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "${THIS_DIR}/common.sh"

repo="${REPO_ROOT_DEFAULT}"
mode="success"
reply_file=""
domain_cmd=""

usage() {
  cat <<'USAGE'
Usage: scene_a_execute_with_receipt.sh --reply-file <path> [options]

Options:
  --repo <path>             Repo root (default: current repository)
  --reply-file <path>       Reply markdown/text file for lint check
  --mode <success|failure>  Receipt lint mode (default: success)
  --domain-cmd <command>    Optional domain command executed before receipt lint
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) repo="${2:-}"; shift 2 ;;
    --reply-file) reply_file="${2:-}"; shift 2 ;;
    --mode) mode="${2:-}"; shift 2 ;;
    --domain-cmd) domain_cmd="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

repo="$(resolve_repo "$repo")"
[[ -n "$reply_file" ]] || { echo "missing required arg: --reply-file" >&2; usage; exit 2; }
[[ -f "$reply_file" ]] || { echo "reply file not found: $reply_file" >&2; exit 2; }

receipt_lint="$(skill_script_path execution-receipt-enforcer receipt_lint.sh)"
require_executable "$receipt_lint"

if [[ -n "$domain_cmd" ]]; then
  echo "[scene-a] step 1/2: execute domain command"
  print_cmd bash -lc "$domain_cmd"
  (
    cd "$repo"
    bash -lc "$domain_cmd"
  )
else
  echo "[scene-a] step 1/2: skip domain command (no --domain-cmd)"
fi

echo "[scene-a] step 2/2: lint execution receipt"
run_step bash "$receipt_lint" --mode "$mode" --file "$reply_file"

echo "[scene-a] done"
