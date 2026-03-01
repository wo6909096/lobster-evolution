<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: HEARTBEAT.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
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
