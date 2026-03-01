<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: capabilities/INDEX.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# capabilities/INDEX

架构说明（<=3行）：
- 本目录存放能力抽象所需模板。
- shapes 定义能力结构，playbooks 定义实验流程。
- 新能力必须先有 shape，再进入实验 playbook。

| 名称 | 地位 | 功能 |
| --- | --- | --- |
| INDEX.md | 目录索引 | capabilities 导航与工作流说明。 |
| playbooks/ | 流程模板目录 | 实验执行模板与决策字段。 |
| shapes/ | 结构模板目录 | 能力输入/输出/边界/指标定义模板。 |
