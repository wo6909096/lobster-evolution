# HEARTBEAT.md

目标：让 agent 主动巡检并产出可验证结果，避免空转。

每次 heartbeat 执行：

1. 仓库健康检查（`/Users/liyuanyuan/lobster-evolution`）
   - `git status -sb`
   - `git branch --show-current`
2. 进化流水线检查
   - 是否有新实验文件：`governance/L2/experiments/`
   - 是否有待补审计记录：`audits/change_logs/`
3. 指标检查
   - 打开 `metrics/capability_scoreboard.csv`
   - 如果最近一周没有更新，提醒发起周复盘

输出规则：

- 有动作：返回执行回执（文件/状态/下一步）
- 无动作：仅回复 `HEARTBEAT_OK`
