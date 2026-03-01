<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: automation/INDEX.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# automation/INDEX

架构说明（<=3行）：
- 本目录定义“如何触发执行”和“如何自动化运行”。
- 任务提示词用于约束实时执行回执，并映射到 `scripts/skill_flows/`。
- cron 模板用于计划任务的可复制部署，默认要求调用一键场景脚本。

| 名称 | 地位 | 功能 |
| --- | --- | --- |
| INDEX.md | 目录索引 | automation 导航与职责说明。 |
| TASK_PROMPTS.md | 执行模板 | 防空转任务提示词（执行/修复/周复盘）。 |
| CRON_JOBS.md | 调度模板 | heartbeat + cron 的最小自动化方案。 |
