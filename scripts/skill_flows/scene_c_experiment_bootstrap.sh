#!/usr/bin/env bash
# input: capability/domain/hypothesis 与实验窗口参数、仓库路径。
# output: 生成 L2 实验草稿并串联 weekly review 草稿（默认 dry-run，可 --apply 落盘）。
# pos: scripts/skill_flows/scene_c_experiment_bootstrap.sh；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。

set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "${THIS_DIR}/common.sh"

repo="${REPO_ROOT_DEFAULT}"
capability=""
domain=""
hypothesis=""
window=""
sample_size="20"
owner="main"
slug=""
apply=0

usage() {
  cat <<'USAGE'
Usage: scene_c_experiment_bootstrap.sh --capability <name> --domain <domain> --hypothesis <text> [options]

Options:
  --repo <path>         Repo root (default: current repository)
  --window <text>       Experiment window text
  --sample-size <n>     Sample size for experiment draft (default: 20)
  --owner <name>        Owner/agent (default: main)
  --slug <slug>         Optional experiment slug override
  --apply               Write files instead of dry-run preview
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) repo="${2:-}"; shift 2 ;;
    --capability) capability="${2:-}"; shift 2 ;;
    --domain) domain="${2:-}"; shift 2 ;;
    --hypothesis) hypothesis="${2:-}"; shift 2 ;;
    --window) window="${2:-}"; shift 2 ;;
    --sample-size) sample_size="${2:-}"; shift 2 ;;
    --owner) owner="${2:-}"; shift 2 ;;
    --slug) slug="${2:-}"; shift 2 ;;
    --apply) apply=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

repo="$(resolve_repo "$repo")"
[[ -n "$capability" ]] || { echo "missing required arg: --capability" >&2; usage; exit 2; }
[[ -n "$domain" ]] || { echo "missing required arg: --domain" >&2; usage; exit 2; }
[[ -n "$hypothesis" ]] || { echo "missing required arg: --hypothesis" >&2; usage; exit 2; }

new_exp_script="$(skill_script_path l2-experiment-driver new_experiment.sh)"
weekly_script="$(skill_script_path weekly-evolution-review weekly_review_pack.sh)"
require_executable "$new_exp_script"
require_executable "$weekly_script"

new_exp_cmd=(bash "$new_exp_script" --repo "$repo" --capability "$capability" --domain "$domain" --hypothesis "$hypothesis" --sample-size "$sample_size" --owner "$owner")
[[ -n "$window" ]] && new_exp_cmd+=(--window "$window")
[[ -n "$slug" ]] && new_exp_cmd+=(--slug "$slug")
[[ "$apply" -eq 0 ]] && new_exp_cmd+=(--dry-run)

weekly_cmd=(bash "$weekly_script" --repo "$repo")
if [[ "$apply" -eq 1 ]]; then
  weekly_cmd+=(--apply)
else
  weekly_cmd+=(--dry-run)
fi

echo "[scene-c] step 1/2: new experiment draft"
run_step "${new_exp_cmd[@]}"

echo "[scene-c] step 2/2: weekly review draft"
run_step "${weekly_cmd[@]}"

echo "[scene-c] done"
