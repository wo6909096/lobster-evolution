<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: README.zh-CN.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# lobster-evolution

面向 OpenClaw Agent 的「执行优先 + 可审计 + 可进化」治理框架。

English version: [README.md](./README.md)

## 文档联动同步契约

本仓库采用“自指 + 多级索引”结构。  
任何功能、架构、写法更新后，必须同步更新：

1. 文件自身 3 行头注释（`input` / `output` / `pos`）
2. 文件所属目录的 `INDEX.md`
3. 必要的父级索引（含根目录 [`INDEX.md`](./INDEX.md)）
4. 当语义影响全局时，同步更新主文档（至少 [`README.md`](./README.md)）

规则来源：

- [`governance/L0/DOC_SYNC_POLICY.md`](./governance/L0/DOC_SYNC_POLICY.md)

## 这个仓库解决什么问题

很多 Agent 的常见问题是：

- 会回复“开始了/执行中”
- 但没有真实执行动作
- 没有可验证回执、没有进化指标、也没有回滚闭环

`lobster-evolution` 的目标是把这件事工程化：

1. 强制执行回执（不是口号）
2. 能力进化分层（L0/L1/L2）
3. 用指标做升级/降级/淘汰决策
4. 让日常执行和定时任务都可复现、可追踪

## 核心分层

### L0：不可突破的底座约束

包括：

- 安全边界
- 质量门槛
- 审计结构
- 回滚策略
- 提交规范
- 执行回执策略（反空转）
- 文档联动同步策略

参考：

- [`governance/L0/SAFETY_BOUNDARY.md`](./governance/L0/SAFETY_BOUNDARY.md)
- [`governance/L0/QUALITY_GATE.md`](./governance/L0/QUALITY_GATE.md)
- [`governance/L0/AUDIT_SCHEMA.md`](./governance/L0/AUDIT_SCHEMA.md)
- [`governance/L0/ROLLBACK_POLICY.md`](./governance/L0/ROLLBACK_POLICY.md)
- [`governance/L0/COMMIT_CONVENTION.md`](./governance/L0/COMMIT_CONVENTION.md)
- [`governance/L0/EXECUTION_RECEIPT_POLICY.md`](./governance/L0/EXECUTION_RECEIPT_POLICY.md)
- [`governance/L0/DOC_SYNC_POLICY.md`](./governance/L0/DOC_SYNC_POLICY.md)

### L1：稳定策略层

包括：

- 进化原则
- 能力树
- 价值函数
- 默认策略
- 主动进化循环

参考：

- [`governance/L1/EVOLUTION_PRINCIPLES.md`](./governance/L1/EVOLUTION_PRINCIPLES.md)
- [`governance/L1/CAPABILITY_TREE.md`](./governance/L1/CAPABILITY_TREE.md)
- [`governance/L1/VALUE_FUNCTION.md`](./governance/L1/VALUE_FUNCTION.md)
- [`governance/L1/DEFAULT_STRATEGIES.md`](./governance/L1/DEFAULT_STRATEGIES.md)
- [`governance/L1/PROACTIVE_LOOP.md`](./governance/L1/PROACTIVE_LOOP.md)

### L2：实验层（候选能力）

所有新方法必须先进入 L2：

- 有假设
- 有指标
- 有风险保护
- 有决策结论（Promote/Hold/Merge/Drop/Rollback）

参考：

- [`governance/L2/experiments/`](./governance/L2/experiments/)
- [`capabilities/playbooks/EXPERIMENT_TEMPLATE.md`](./capabilities/playbooks/EXPERIMENT_TEMPLATE.md)
- [`capabilities/shapes/CAPABILITY_SHAPE_TEMPLATE.md`](./capabilities/shapes/CAPABILITY_SHAPE_TEMPLATE.md)

## 仓库结构

```text
governance/
  L0/  # 底座约束与执行规则
  L1/  # 稳定策略与决策模型
  L2/  # 实验与候选能力
capabilities/
  playbooks/ # 实验流程模板
  shapes/    # 能力形状模板
audits/
  change_logs/ # 变更回执
  eval_reports/ # 评估报告
  incidents/    # 回滚/事故记录
metrics/
  capability_scoreboard.csv
  weekly_review.md
automation/
  TASK_PROMPTS.md
  CRON_JOBS.md
```

## 快速开始（OpenClaw 接入）

1. 克隆仓库
2. 把 OpenClaw 默认工作区指向本仓库
3. 重启网关
4. 校验配置

```bash
git clone https://github.com/wo6909096/lobster-evolution.git
cd lobster-evolution

openclaw config set agents.defaults.workspace /Users/liyuanyuan/lobster-evolution
openclaw gateway restart
openclaw config get agents.defaults.workspace --json
```

## 执行回执机制（防“开始了但没做”）

执行类任务（“执行、开始、落地、修复、提交”等）必须：

1. 先执行命令/工具，再发进度
2. 返回可验证回执
3. 失败时返回失败回执（命令 + 原始错误 + 下一步）
4. 禁止只发状态口号

推荐任务模板：

- [`automation/TASK_PROMPTS.md`](./automation/TASK_PROMPTS.md)

## 主动进化闭环

日常循环：

1. 发现重复任务
2. 抽象能力形状
3. 进入 L2 实验
4. 按指标评估
5. 决策升级/保留/淘汰

周循环：

1. 汇总实验结论
2. 更新能力记分板
3. 产出评审报告
4. 修剪低价值能力

参考：

- [`governance/L1/PROACTIVE_LOOP.md`](./governance/L1/PROACTIVE_LOOP.md)
- [`metrics/capability_scoreboard.csv`](./metrics/capability_scoreboard.csv)
- [`metrics/weekly_review.md`](./metrics/weekly_review.md)

## 自动化建议（heartbeat + cron）

最小组合：

- heartbeat：上下文巡检
- cron A：工作日仓库健康检查
- cron B：每周进化复盘
- 可选 cron C：每周 L2 清理

常用命令：

```bash
openclaw cron list --all
openclaw cron run <job-id>
openclaw cron disable <job-id>
```

完整示例：

- [`automation/CRON_JOBS.md`](./automation/CRON_JOBS.md)
- [`HEARTBEAT.md`](./HEARTBEAT.md)

## 审计与回滚

非 trivial 变更应留下审计记录：

- 变更日志：`audits/change_logs/YYYY-MM-DD.md`
- 评估报告：`audits/eval_reports/`
- 回滚记录：`audits/incidents/`

模板：

- [`audits/change_logs/README.md`](./audits/change_logs/README.md)
- [`audits/eval_reports/EVALUATION_TEMPLATE.md`](./audits/eval_reports/EVALUATION_TEMPLATE.md)
- [`audits/incidents/ROLLBACK_REPORT_TEMPLATE.md`](./audits/incidents/ROLLBACK_REPORT_TEMPLATE.md)

## 协作与提交规范

建议流程：

1. 先保证可复现与可验证
2. 按提交规范命名 commit
3. 非 trivial 变更补审计日志
4. L2 未达标不得升 L1

提交规范见：

- [`governance/L0/COMMIT_CONVENTION.md`](./governance/L0/COMMIT_CONVENTION.md)

## 路线图

- Phase 1：治理基建与首批候选能力
- Phase 2：持续实验与周度升级评审
- Phase 3：能力树合并修剪，降低成本与步骤

参考：

- [`ROADMAP.md`](./ROADMAP.md)

## 常见排查

### 1) 定时任务执行成功但消息没送达

执行与投递是两条链路，可能出现“执行 ok，投递失败”。

排查：

```bash
openclaw cron runs --id <job-id> --limit 5
openclaw channels status --probe --json
openclaw channels logs --channel feishu --lines 200
```

### 2) Agent 总说“开始了”但没有落地改动

检查是否真的触发工具调用：

```bash
rg -n 'toolCall|toolResult|stopReason":"toolUse"' ~/.openclaw/agents/main/sessions/*.jsonl
```

如果没有 `toolUse`，通常代表并未实际执行。
