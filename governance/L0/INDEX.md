<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: governance/L0/INDEX.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# governance/L0/INDEX

架构说明（<=3行）：
- L0 是不可突破底座，优先级最高。
- 任一 L0 规则冲突时，以安全与回滚优先。
- L1/L2 变更不得绕过 L0。

| 名称 | 地位 | 功能 |
| --- | --- | --- |
| INDEX.md | 目录索引 | L0 文件导航。 |
| SAFETY_BOUNDARY.md | 安全边界 | 外部操作、权限、敏感信息最小暴露规则。 |
| QUALITY_GATE.md | 质量门槛 | 升级前可复现/可验证/可解释/可回滚要求。 |
| AUDIT_SCHEMA.md | 审计结构 | 审计记录最小字段。 |
| ROLLBACK_POLICY.md | 回滚策略 | 回滚触发条件与操作原则。 |
| COMMIT_CONVENTION.md | 提交规范 | 统一 commit 命名规则。 |
| EXECUTION_RECEIPT_POLICY.md | 执行回执规则 | 防“口头开始”空转的刚性规则。 |
| DOC_SYNC_POLICY.md | 文档联动规则 | 规范文件头注释、目录索引与主文档同步更新。 |
