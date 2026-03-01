<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: skills/SKILL_RUNBOOK.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# SKILL_RUNBOOK

按高频场景给出“技能组合 -> 执行顺序 -> 命令模板”。
仓库内一键脚本入口：`scripts/skill_flows/`。

## 场景 A：执行任务防空转（先做再汇报）

目标：避免“开始了/执行中”口号，强制可验证回执。

组合技能：
- `execution-receipt-enforcer`
- 领域技能（如 `doc-sync-guard` / `github` / `cron-ops-hardening`）

顺序：
1. 先执行领域命令
2. 再按回执模板输出结果
3. 用 lint 检查回复质量

命令模板：

```bash
# 回执内容检查（成功模式）
bash ~/.openclaw/skills/execution-receipt-enforcer/scripts/receipt_lint.sh \
  --mode success --file /tmp/reply.md
```

一键脚本：

```bash
bash scripts/skill_flows/scene_a_execute_with_receipt.sh \
  --reply-file /tmp/reply.md \
  --mode success \
  --domain-cmd "git status -sb"
```

## 场景 B：仓库改动后做文档联动同步

目标：确保 header、目录索引、根文档同步。

组合技能：
- `doc-sync-guard`
- `governance-sync-maintainer`

顺序：
1. 跑文档联动检查
2. 跑治理跨层一致性检查
3. 修复后复跑直到全绿

命令模板：

```bash
bash ~/.openclaw/skills/doc-sync-guard/scripts/check_sync.sh ~/lobster-evolution
bash ~/.openclaw/skills/governance-sync-maintainer/scripts/check_governance_sync.sh \
  --repo ~/lobster-evolution
```

一键脚本：

```bash
bash scripts/skill_flows/scene_b_doc_sync.sh --repo ~/lobster-evolution
```

## 场景 C：把重复任务升级为能力实验

目标：把“重复需求”沉淀为 L2 实验并可评估。

组合技能：
- `l2-experiment-driver`
- `weekly-evolution-review`

顺序：
1. 先生成 `EXP-*` 草稿
2. 执行试验并补充结果
3. 周复盘汇总并形成评估报告

命令模板：

```bash
# 1) 生成实验草稿（先预览）
bash ~/.openclaw/skills/l2-experiment-driver/scripts/new_experiment.sh \
  --repo ~/lobster-evolution \
  --capability CAP-dev-log-triage \
  --domain dev \
  --hypothesis "Structured triage improves throughput" \
  --dry-run

# 2) 生成周复盘草稿（先预览）
bash ~/.openclaw/skills/weekly-evolution-review/scripts/weekly_review_pack.sh \
  --repo ~/lobster-evolution --dry-run
```

一键脚本：

```bash
bash scripts/skill_flows/scene_c_experiment_bootstrap.sh \
  --repo ~/lobster-evolution \
  --capability CAP-dev-log-triage \
  --domain dev \
  --hypothesis "Structured triage improves throughput"
```

## 场景 D：周评审与指标更新

目标：每周沉淀一次可审计评估结论。

组合技能：
- `weekly-evolution-review`
- `audit-log-writer`

顺序：
1. 产出周评审报告草稿
2. 追加记分板指标行
3. 写入当日 change log

命令模板：

```bash
# 周报告落盘
bash ~/.openclaw/skills/weekly-evolution-review/scripts/weekly_review_pack.sh \
  --repo ~/lobster-evolution --apply

# 记分板追加（先 dry-run）
bash ~/.openclaw/skills/weekly-evolution-review/scripts/append_scoreboard_row.sh \
  --repo ~/lobster-evolution \
  --date 2026-03-01 \
  --domain dev \
  --capability CAP-dev-log-triage \
  --success-rate 0.84 \
  --avg-steps 7 \
  --avg-duration-sec 420 \
  --tool-cost 1.8 \
  --reuse-rate 0.62 \
  --decision Hold \
  --dry-run
```

一键脚本：

```bash
bash scripts/skill_flows/scene_d_weekly_review.sh \
  --repo ~/lobster-evolution \
  --date 2026-03-01 \
  --domain dev \
  --capability CAP-dev-log-triage \
  --success-rate 0.84 \
  --avg-steps 7 \
  --avg-duration-sec 420 \
  --tool-cost 1.8 \
  --reuse-rate 0.62 \
  --decision Hold \
  --dry-run
```

## 场景 E：cron 任务异常排查

目标：快速定位“任务跑了但没送达”。

组合技能：
- `cron-ops-hardening`
- `execution-receipt-enforcer`

顺序：
1. 看 cron 全量清单与最近运行
2. 看通道探针和通道日志
3. 给出失败分类与修复动作

命令模板：

```bash
bash ~/.openclaw/skills/cron-ops-hardening/scripts/channel_probe.sh
bash ~/.openclaw/skills/cron-ops-hardening/scripts/cron_diagnose.sh \
  --id <job-id> --limit 5
```

一键脚本：

```bash
bash scripts/skill_flows/scene_e_cron_diagnose.sh \
  --id <job-id> \
  --limit 5
```

## 场景 F：事故/回滚后审计闭环

目标：补齐事故复盘和变更留痕。

组合技能：
- `audit-log-writer`
- `doc-sync-guard`

顺序：
1. 生成 incident 草稿
2. 校验审计字段完整性
3. 补 change log 并跑文档联动检查

命令模板：

```bash
bash ~/.openclaw/skills/audit-log-writer/scripts/new_incident_report.sh \
  --repo ~/lobster-evolution \
  --slug gateway-token-mismatch \
  --stable-ref a1b2c3d \
  --hypothesis "token route change caused delivery regression" \
  --trigger "delivery failed > 10%" \
  --dry-run

bash ~/.openclaw/skills/audit-log-writer/scripts/audit_lint.sh \
  --file /tmp/incident.md --mode incident
```

一键脚本：

```bash
bash scripts/skill_flows/scene_f_incident_close_loop.sh \
  --repo ~/lobster-evolution \
  --slug gateway-token-mismatch \
  --stable-ref a1b2c3d \
  --hypothesis "token route change caused delivery regression" \
  --trigger "delivery failed > 10%"
```

## 场景 G：飞书“只回复不执行”热修复

目标：定位 reply-only 风险，并在必要时切换回退模型。

组合技能：
- `execution-receipt-enforcer`
- `cron-ops-hardening`（复用通道探针）

顺序：
1. 检查通道健康与当前模型
2. 统计最近会话中的 `toolUse` 与承诺话术命中
3. 如命中高风险，切换回退模型并重启网关

命令模板：

```bash
# 1) 仅诊断
bash scripts/skill_flows/scene_g_reply_only_hotfix.sh --window 180

# 2) 诊断后立即回退模型（按需）
bash scripts/skill_flows/scene_g_reply_only_hotfix.sh \
  --window 180 \
  --apply-model-switch \
  --fallback-model sub2api/gpt-5.2-codex \
  --restart-gateway
```
