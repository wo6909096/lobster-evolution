#!/usr/bin/env bash
# input: 周评审日期、能力指标参数、仓库路径与可选 dry-run 开关。
# output: 生成周评审、追加记分板记录，并写入审计 change log（默认 apply）。
# pos: scripts/skill_flows/scene_d_weekly_review.sh；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。

set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "${THIS_DIR}/common.sh"

repo="${REPO_ROOT_DEFAULT}"
date_v="$(date +%Y-%m-%d)"
domain=""
capability=""
success_rate=""
avg_steps=""
avg_duration_sec=""
tool_cost=""
reuse_rate=""
decision=""
dry_run=0
title="weekly review and scoreboard update"

usage() {
  cat <<'USAGE'
Usage: scene_d_weekly_review.sh --domain <d> --capability <c> --success-rate <n> --avg-steps <n> \
  --avg-duration-sec <n> --tool-cost <n> --reuse-rate <n> --decision <text> [options]

Options:
  --repo <path>            Repo root (default: current repository)
  --date YYYY-MM-DD        Scoreboard/log date (default: today)
  --title <text>           Change log title prefix
  --dry-run                Preview only; do not write files
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) repo="${2:-}"; shift 2 ;;
    --date) date_v="${2:-}"; shift 2 ;;
    --domain) domain="${2:-}"; shift 2 ;;
    --capability) capability="${2:-}"; shift 2 ;;
    --success-rate) success_rate="${2:-}"; shift 2 ;;
    --avg-steps) avg_steps="${2:-}"; shift 2 ;;
    --avg-duration-sec) avg_duration_sec="${2:-}"; shift 2 ;;
    --tool-cost) tool_cost="${2:-}"; shift 2 ;;
    --reuse-rate) reuse_rate="${2:-}"; shift 2 ;;
    --decision) decision="${2:-}"; shift 2 ;;
    --title) title="${2:-}"; shift 2 ;;
    --dry-run) dry_run=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

repo="$(resolve_repo "$repo")"
for v in domain capability success_rate avg_steps avg_duration_sec tool_cost reuse_rate decision; do
  [[ -n "${!v}" ]] || { echo "missing required arg: --${v//_/-}" >&2; usage; exit 2; }
done

weekly_script="$(skill_script_path weekly-evolution-review weekly_review_pack.sh)"
score_script="$(skill_script_path weekly-evolution-review append_scoreboard_row.sh)"
changelog_script="$(skill_script_path audit-log-writer change_log_entry.sh)"
require_executable "$weekly_script"
require_executable "$score_script"
require_executable "$changelog_script"

weekly_cmd=(bash "$weekly_script" --repo "$repo")
score_cmd=(bash "$score_script" --repo "$repo" --date "$date_v" --domain "$domain" --capability "$capability" --success-rate "$success_rate" --avg-steps "$avg_steps" --avg-duration-sec "$avg_duration_sec" --tool-cost "$tool_cost" --reuse-rate "$reuse_rate" --decision "$decision")
change_cmd=(bash "$changelog_script" --repo "$repo" --date "$date_v" --title "$title (${date_v})" --goal "produce weekly evaluation artifact and sync metrics" --scope "audits/eval_reports/, metrics/capability_scoreboard.csv, audits/change_logs/" --risk "low to medium (depends on metric accuracy)" --metrics "success_rate=${success_rate}; reuse_rate=${reuse_rate}; decision=${decision}" --conclusion "weekly review package and scoreboard row updated" --next-step "continue capability validation next week")

if [[ "$dry_run" -eq 1 ]]; then
  weekly_cmd+=(--dry-run)
  score_cmd+=(--dry-run)
  change_cmd+=(--dry-run)
else
  weekly_cmd+=(--apply)
fi

echo "[scene-d] step 1/3: weekly review pack"
run_step "${weekly_cmd[@]}"

echo "[scene-d] step 2/3: append scoreboard row"
run_step "${score_cmd[@]}"

echo "[scene-d] step 3/3: append change log"
run_step "${change_cmd[@]}"

echo "[scene-d] done"
