# CRON_JOBS

以下是社区常用的最小自动化组合：1 个 heartbeat + 2 个 cron。

## 前置

- 默认工作区应指向本仓库：
  - `openclaw config set agents.defaults.workspace /Users/liyuanyuan/lobster-evolution`
  - `openclaw gateway restart`

## Job A：每日仓库健康检查（工作日）

```bash
openclaw cron add \
  --name "repo-health-daily" \
  --cron "30 10 * * 1-5" \
  --tz "Asia/Shanghai" \
  --agent main \
  --message "执行仓库健康检查：git status -sb + 分支 + 未提交摘要。按执行回执规范返回。"
```

## Job B：每周进化复盘（周一）

```bash
openclaw cron add \
  --name "evolution-weekly-review" \
  --cron "0 11 * * 1" \
  --tz "Asia/Shanghai" \
  --agent main \
  --message "执行周复盘：更新 metrics/capability_scoreboard.csv，并在 audits/eval_reports/ 输出复盘结论。"
```

## Job C：每周清理低价值候选（周五）

```bash
openclaw cron add \
  --name "l2-prune-weekly" \
  --cron "0 18 * * 5" \
  --tz "Asia/Shanghai" \
  --agent main \
  --message "检查 governance/L2/experiments/ 中低价值候选，给出升级/回滚/淘汰建议并落盘。"
```

## 运维命令

```bash
openclaw cron list --all
# 先用 list 找到 job id，再运行/禁用
openclaw cron run <job-id>
openclaw cron disable <job-id>
```
