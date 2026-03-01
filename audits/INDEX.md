<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: audits/INDEX.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# audits/INDEX

架构说明（<=3行）：
- 审计层负责记录“做了什么、效果如何、何时回滚”。
- 所有非 trivial 变更必须落到 change_logs。
- 评估与事故记录分别沉淀在 eval_reports 与 incidents。

| 名称 | 地位 | 功能 |
| --- | --- | --- |
| INDEX.md | 目录索引 | audits 目录下结构与职责导航。 |
| change_logs/ | 变更审计目录 | 按日期记录执行回执与风险说明。 |
| eval_reports/ | 评估目录 | 存放能力/策略评估报告。 |
| incidents/ | 事故目录 | 存放回滚与故障复盘记录。 |
