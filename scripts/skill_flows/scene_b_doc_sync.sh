#!/usr/bin/env bash
# input: 仓库路径与本机 doc-sync/governance-sync 技能脚本。
# output: 依次执行文档联动检查与治理一致性检查，输出可验证检查结果。
# pos: scripts/skill_flows/scene_b_doc_sync.sh；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。

set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "${THIS_DIR}/common.sh"

repo="${REPO_ROOT_DEFAULT}"

usage() {
  cat <<'USAGE'
Usage: scene_b_doc_sync.sh [--repo <path>]
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) repo="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

repo="$(resolve_repo "$repo")"

doc_sync_script="$(skill_script_path doc-sync-guard check_sync.sh)"
gov_sync_script="$(skill_script_path governance-sync-maintainer check_governance_sync.sh)"
require_executable "$doc_sync_script"
require_executable "$gov_sync_script"

echo "[scene-b] step 1/2: doc sync check"
run_step bash "$doc_sync_script" "$repo"

echo "[scene-b] step 2/2: governance sync check"
run_step bash "$gov_sync_script" --repo "$repo"

echo "[scene-b] done"
