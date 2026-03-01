# EXP-20260301-dev-director-seed

## Dev 候选（示例）
1. CAP-dev-code-review-batch
- 输入：PR/commit 列表
- 输出：结构化 review 结论
- 不变量：风险优先
- 参数：规则集、严格度
- 失败点：上下文不足

2. CAP-dev-bug-triage-template
- 输入：报错/日志
- 输出：优先级+修复建议
- 不变量：可复现优先
- 参数：服务域、严重级别
- 失败点：日志缺失

3. CAP-dev-test-gap-detect
- 输入：变更文件/测试覆盖
- 输出：缺口清单
- 不变量：关键路径覆盖
- 参数：阈值
- 失败点：覆盖数据不完整

## Director 候选（示例）
4. CAP-dir-scene-pacing-check
- 输入：分镜/时长
- 输出：节奏诊断
- 不变量：叙事连贯
- 参数：风格、时长目标
- 失败点：素材粒度不足

5. CAP-dir-shot-language-consistency
- 输入：镜头清单
- 输出：一致性评分+修正建议
- 不变量：风格约束一致
- 参数：镜头语言规范
- 失败点：规范缺失

6. CAP-dir-episode-arc-validator
- 输入：分集大纲
- 输出：冲突/反转/回收检查
- 不变量：主线完整
- 参数：目标受众、平台长度
- 失败点：大纲信息不足

## 评估指标
- 成功率
- 平均步骤数
- 平均耗时
- 工具调用成本
- 复用率