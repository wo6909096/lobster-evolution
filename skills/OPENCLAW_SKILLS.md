<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: skills/OPENCLAW_SKILLS.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# OPENCLAW_SKILLS

本清单记录当前用于 `lobster-evolution` 的治理技能。  
技能目录（本机）：`~/.openclaw/skills/`

组合执行手册：[`SKILL_RUNBOOK.md`](./SKILL_RUNBOOK.md)
仓库一键脚本：[`../scripts/skill_flows/INDEX.md`](../scripts/skill_flows/INDEX.md)

## 已安装技能

| 技能名 | 主要作用 | 典型触发词 |
| --- | --- | --- |
| `doc-sync-guard` | 校验/修复 header + `INDEX.md` + README 联动 | 文档联动、索引同步、header 同步 |
| `execution-receipt-enforcer` | 防止“开始了但没执行”，强制可验证回执 | 执行、开始、修复、不要只回复 |
| `l2-experiment-driver` | 生成 L2 能力实验草稿与指标框架 | 抽象能力、做实验、是否升级 |
| `weekly-evolution-review` | 周复盘草稿与指标更新工具 | 周复盘、每周评审、更新记分板 |
| `cron-ops-hardening` | 定时任务与投递链路排障 | cron 不触发、执行成功但没送达 |
| `audit-log-writer` | 变更日志/事故复盘记录与校验 | 审计记录、回滚复盘、变更留痕 |
| `governance-sync-maintainer` | 检查 L0/L1/L2 与根文档一致性漂移 | 治理一致性审查、规则改动联动 |

## 常用命令

```bash
openclaw skills list --json
openclaw skills info doc-sync-guard --json
openclaw skills info execution-receipt-enforcer --json
openclaw skills info l2-experiment-driver --json
openclaw skills info weekly-evolution-review --json
openclaw skills info cron-ops-hardening --json
openclaw skills info audit-log-writer --json
openclaw skills info governance-sync-maintainer --json
```

## 维护要求

1. 新增/删除技能后，必须同步更新本文件和 `skills/INDEX.md`。
2. 若技能影响仓库流程语义，需同步更新根 `README.md` 与根 `INDEX.md`。
3. 非 trivial 的技能更新需记录到 `audits/change_logs/YYYY-MM-DD.md`。
