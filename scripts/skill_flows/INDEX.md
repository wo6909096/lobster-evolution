<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: scripts/skill_flows/INDEX.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# scripts/skill_flows/INDEX

架构说明（<=3行）：
- 本目录将 runbook 的 A-F 场景映射为可直接执行的脚本。
- 脚本优先复用 `~/.openclaw/skills/*/scripts`，避免重复实现。
- 每次流程调整必须同步更新此索引与 `skills/SKILL_RUNBOOK.md`。

| 名称 | 地位 | 功能 |
| --- | --- | --- |
| INDEX.md | 目录索引 | skill_flows 导航与维护约束。 |
| common.sh | 公共库 | 场景脚本共享的路径解析、命令打印、技能脚本定位函数。 |
| scene_a_execute_with_receipt.sh | 场景 A | 执行任务后强制进行回执 lint，避免空转汇报。 |
| scene_b_doc_sync.sh | 场景 B | 串联文档联动检查与治理一致性检查。 |
| scene_c_experiment_bootstrap.sh | 场景 C | 生成 L2 实验草稿并触发周复盘草稿。 |
| scene_d_weekly_review.sh | 场景 D | 产出周评审、追加记分板并写入 change log。 |
| scene_e_cron_diagnose.sh | 场景 E | 执行 cron/通道排障并可选进行回执质量校验。 |
| scene_f_incident_close_loop.sh | 场景 F | 事故草稿、审计校验、change log 与文档联动闭环。 |
