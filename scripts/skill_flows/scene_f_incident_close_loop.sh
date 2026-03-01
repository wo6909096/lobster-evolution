#!/usr/bin/env bash
# input: 事故 slug、稳定版本、假设与触发条件，以及仓库路径和 apply/dry-run 选择。
# output: 生成事故草稿、执行审计 lint、写入 change log，并跑文档联动检查完成闭环。
# pos: scripts/skill_flows/scene_f_incident_close_loop.sh；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。

set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "${THIS_DIR}/common.sh"

repo="${REPO_ROOT_DEFAULT}"
date_v="$(date +%Y-%m-%d)"
slug=""
stable_ref=""
hypothesis=""
trigger=""
apply=0

usage() {
  cat <<'USAGE'
Usage: scene_f_incident_close_loop.sh --slug <slug> --stable-ref <ref> --hypothesis <text> --trigger <text> [options]

Options:
  --repo <path>         Repo root (default: current repository)
  --date YYYY-MM-DD     Incident date (default: today)
  --apply               Write files; default mode is dry-run preview
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) repo="${2:-}"; shift 2 ;;
    --date) date_v="${2:-}"; shift 2 ;;
    --slug) slug="${2:-}"; shift 2 ;;
    --stable-ref) stable_ref="${2:-}"; shift 2 ;;
    --hypothesis) hypothesis="${2:-}"; shift 2 ;;
    --trigger) trigger="${2:-}"; shift 2 ;;
    --apply) apply=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

repo="$(resolve_repo "$repo")"
for v in slug stable_ref hypothesis trigger; do
  [[ -n "${!v}" ]] || { echo "missing required arg: --${v//_/-}" >&2; usage; exit 2; }
done

slug_norm="$(slug_normalize "$slug")"
incident_file="$repo/audits/incidents/INC-${date_v}-${slug_norm}.md"
change_log_file="$repo/audits/change_logs/${date_v}.md"

incident_script="$(skill_script_path audit-log-writer new_incident_report.sh)"
change_script="$(skill_script_path audit-log-writer change_log_entry.sh)"
doc_sync_script="$(skill_script_path doc-sync-guard check_sync.sh)"
audit_lint_script="$(skill_script_path audit-log-writer audit_lint.sh)"
require_executable "$incident_script"
require_executable "$change_script"
require_executable "$doc_sync_script"
require_executable "$audit_lint_script"

lint_incident_fields() {
  local file="$1"
  local missing=0
  local required=(
    "上一稳定版本"
    "进化假设"
    "回滚触发条件"
    "事件时间"
    "影响范围"
    "风险评估"
    "指标前后对比"
    "处置动作"
    "复盘结论与下一步"
  )
  for token in "${required[@]}"; do
    if ! grep -Fq "$token" "$file"; then
      echo "[FAIL] incident field missing: $token" >&2
      missing=$((missing + 1))
    fi
  done
  if [[ "$missing" -gt 0 ]]; then
    echo "[scene-f] incident lint failed with ${missing} missing field(s)." >&2
    exit 1
  fi
  echo "[scene-f] incident field lint passed"
}

if [[ "$apply" -eq 1 ]]; then
  echo "[scene-f] step 1/4: create incident report"
  run_step bash "$incident_script" --repo "$repo" --date "$date_v" --slug "$slug" --stable-ref "$stable_ref" --hypothesis "$hypothesis" --trigger "$trigger"

  echo "[scene-f] step 2/4: lint incident report fields"
  lint_incident_fields "$incident_file"
else
  echo "[scene-f] step 1/4: preview incident report (dry-run)"
  preview_file="$(mktemp)"
  lint_file="$(mktemp)"
  trap 'rm -f "$preview_file" "$lint_file"' EXIT

  print_cmd bash "$incident_script" --repo "$repo" --date "$date_v" --slug "$slug" --stable-ref "$stable_ref" --hypothesis "$hypothesis" --trigger "$trigger" --dry-run
  bash "$incident_script" --repo "$repo" --date "$date_v" --slug "$slug" --stable-ref "$stable_ref" --hypothesis "$hypothesis" --trigger "$trigger" --dry-run | tee "$preview_file"

  awk 'seen{print} /^-----$/{seen=1;next}' "$preview_file" > "$lint_file"
  [[ -s "$lint_file" ]] || { echo "failed to capture dry-run incident content for lint" >&2; exit 1; }

  echo "[scene-f] step 2/4: lint dry-run incident fields"
  lint_incident_fields "$lint_file"
fi

echo "[scene-f] step 3/4: append change log"
change_cmd=(bash "$change_script" --repo "$repo" --date "$date_v" --title "incident close-loop (${slug_norm})" --goal "record incident drill and complete audit/doc sync loop" --scope "audits/incidents/, audits/change_logs/, repository docs" --risk "medium (incident data quality affects rollback decisions)" --metrics "incident_lint=pass; doc_sync=pass" --conclusion "incident close-loop executed")
if [[ "$apply" -eq 0 ]]; then
  change_cmd+=(--dry-run)
fi
run_step "${change_cmd[@]}"

echo "[scene-f] step 4/4: doc sync check"
run_step bash "$doc_sync_script" "$repo"
if [[ -f "$change_log_file" ]]; then
  run_step bash "$audit_lint_script" --file "$change_log_file" --mode change
fi

echo "[scene-f] done"
