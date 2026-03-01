# TASK_PROMPTS

以下模板用于避免"口头开始、没有执行"。

## 模板 1：执行类任务

在当前仓库执行，不要只回复状态。
先执行再回复，最终只返回：
1. 修改文件列表
2. `git status -sb`
3. commit hash（如已提交）
4. 若失败：失败命令 + 原始错误 + 下一步修复

## 模板 2：修复类任务

请直接修复，不要给方案草稿。
要求：
1. 先复现
2. 再修复
3. 最后回执（复现命令、修复点、验证结果、git status）

## 模板 3：周复盘任务

请基于本仓库执行周复盘：
1. 汇总本周 L2 实验
2. 更新 `metrics/capability_scoreboard.csv`
3. 输出结论到 `audits/eval_reports/`
4. 返回变更文件和 git status
