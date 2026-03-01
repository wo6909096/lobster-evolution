#!/usr/bin/env bash
# input: 场景脚本传入的 repo/日期/指标参数，以及本机 ~/.openclaw/skills/*/scripts。
# output: 提供公共函数：路径解析、技能脚本定位、命令打印与步骤执行。
# pos: scripts/skill_flows/common.sh；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT_DEFAULT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

print_cmd() {
  printf "+"
  for arg in "$@"; do
    printf " %q" "$arg"
  done
  printf "\n"
}

run_step() {
  print_cmd "$@"
  "$@"
}

resolve_repo() {
  local input="$1"
  local abs
  if [[ "$input" = /* ]]; then
    abs="$input"
  else
    abs="$(cd "$input" && pwd)"
  fi
  if [[ ! -d "$abs" ]]; then
    echo "repo not found: $input" >&2
    exit 2
  fi
  echo "$abs"
}

skill_script_path() {
  local skill="$1"
  local script_name="$2"
  echo "$HOME/.openclaw/skills/${skill}/scripts/${script_name}"
}

require_executable() {
  local file="$1"
  if [[ ! -x "$file" ]]; then
    echo "required executable not found: $file" >&2
    exit 2
  fi
}

slug_normalize() {
  local raw="$1"
  echo "$raw" | sed -E 's/[^A-Za-z0-9-]+/-/g; s/^-+//; s/-+$//'
}
