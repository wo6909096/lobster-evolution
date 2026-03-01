<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: automation/CRON_JOBS.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# CRON_JOBS

以下是社区常用的最小自动化组合：1 个 heartbeat + 2 个 cron。
本仓库建议在 cron 消息里显式要求调用 `scripts/skill_flows/*.sh`，减少空转回复。

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
  --message "在 /Users/liyuanyuan/lobster-evolution 执行：bash scripts/skill_flows/scene_b_doc_sync.sh --repo /Users/liyuanyuan/lobster-evolution；然后返回执行回执（检查结果、git status -sb、失败项与修复建议）。"
```

## Job B：每周进化复盘（周一）

```bash
openclaw cron add \
  --name "evolution-weekly-review" \
  --cron "0 11 * * 1" \
  --tz "Asia/Shanghai" \
  --agent main \
  --message "先汇总最近 7 天实验并计算 success-rate/avg-steps/avg-duration-sec/tool-cost/reuse-rate/decision，再执行 scene_d_weekly_review.sh（先 --dry-run，再去掉 --dry-run）。命令模板：bash scripts/skill_flows/scene_d_weekly_review.sh --repo /Users/liyuanyuan/lobster-evolution --date $(date +%F) --domain dev --capability CAP-dev-log-triage --success-rate <value> --avg-steps <value> --avg-duration-sec <value> --tool-cost <value> --reuse-rate <value> --decision <value>。"
```

## Job C：每周清理低价值候选（周五）

```bash
openclaw cron add \
  --name "l2-prune-weekly" \
  --cron "0 18 * * 5" \
  --tz "Asia/Shanghai" \
  --agent main \
  --message "在 /Users/liyuanyuan/lobster-evolution 执行：bash scripts/skill_flows/scene_c_experiment_bootstrap.sh --repo /Users/liyuanyuan/lobster-evolution --capability CAP-dev-code-review-batch --domain dev --hypothesis \"Batch review reuse can reduce avg steps\"。如触发事故演练，补跑 scene_f_incident_close_loop.sh（dry-run）。"
```

## 运维命令

```bash
openclaw cron list --all
# 先用 list 找到 job id，再运行/禁用
openclaw cron run <job-id>
openclaw cron disable <job-id>
```
