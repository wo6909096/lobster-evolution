<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: README.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# lobster-evolution

Execution-first governance and evolution framework for OpenClaw agents.

For Chinese documentation, see [README.zh-CN.md](./README.zh-CN.md).

## Documentation synchronization contract

This repository uses a self-referential, multi-level index system.
After any feature, architecture, or writing update, you must synchronously update:

1. The file's own 3-line header (`input` / `output` / `pos`)
2. The `INDEX.md` in the file's folder
3. Relevant parent indexes (including root [`INDEX.md`](./INDEX.md) when needed)
4. Root docs when project-level semantics change (at least [`README.md`](./README.md))

Rule source:

- [`governance/L0/DOC_SYNC_POLICY.md`](./governance/L0/DOC_SYNC_POLICY.md)

## Why this repo exists

This repository solves a common failure mode in autonomous assistants:

- The agent acknowledges tasks ("started", "working on it")
- But no concrete execution happens
- There is no audit trail, no measurable evolution, and no reliable rollback path

`lobster-evolution` defines a practical, layered system that forces:

1. Verifiable execution receipts
2. Structured capability evolution
3. Metrics-based promote/hold/rollback decisions
4. Reproducible operations across daily and scheduled runs

## Core design

### L0: Safety and execution guarantees

Base constraints that must always hold:

- Safety boundaries
- Quality gates
- Audit schema
- Rollback policy
- Commit conventions
- Execution receipt contract (anti-empty-progress policy)
- Documentation synchronization policy

Reference:

- [`governance/L0/SAFETY_BOUNDARY.md`](./governance/L0/SAFETY_BOUNDARY.md)
- [`governance/L0/QUALITY_GATE.md`](./governance/L0/QUALITY_GATE.md)
- [`governance/L0/AUDIT_SCHEMA.md`](./governance/L0/AUDIT_SCHEMA.md)
- [`governance/L0/ROLLBACK_POLICY.md`](./governance/L0/ROLLBACK_POLICY.md)
- [`governance/L0/COMMIT_CONVENTION.md`](./governance/L0/COMMIT_CONVENTION.md)
- [`governance/L0/EXECUTION_RECEIPT_POLICY.md`](./governance/L0/EXECUTION_RECEIPT_POLICY.md)
- [`governance/L0/DOC_SYNC_POLICY.md`](./governance/L0/DOC_SYNC_POLICY.md)

### L1: Stable strategy and decision model

Shared strategy layer that guides everyday behavior:

- Evolution principles
- Capability tree
- Value function
- Default strategies
- Proactive loop

Reference:

- [`governance/L1/EVOLUTION_PRINCIPLES.md`](./governance/L1/EVOLUTION_PRINCIPLES.md)
- [`governance/L1/CAPABILITY_TREE.md`](./governance/L1/CAPABILITY_TREE.md)
- [`governance/L1/VALUE_FUNCTION.md`](./governance/L1/VALUE_FUNCTION.md)
- [`governance/L1/DEFAULT_STRATEGIES.md`](./governance/L1/DEFAULT_STRATEGIES.md)
- [`governance/L1/PROACTIVE_LOOP.md`](./governance/L1/PROACTIVE_LOOP.md)

### L2: Experiments and candidate capabilities

All new methods start here before promotion:

- Hypothesis-driven experiments
- Explicit metrics and risk controls
- Promote/Hold/Merge/Drop/Rollback outcomes

Reference:

- [`governance/L2/experiments/`](./governance/L2/experiments/)
- [`capabilities/playbooks/EXPERIMENT_TEMPLATE.md`](./capabilities/playbooks/EXPERIMENT_TEMPLATE.md)
- [`capabilities/shapes/CAPABILITY_SHAPE_TEMPLATE.md`](./capabilities/shapes/CAPABILITY_SHAPE_TEMPLATE.md)

## Repository layout

```text
governance/
  L0/  # non-negotiable constraints and execution policy
  L1/  # stable strategy and decision rules
  L2/  # experiments and candidate capabilities
capabilities/
  playbooks/ # experiment templates and playbooks
  shapes/    # capability shape templates
audits/
  change_logs/ # day-level execution/change receipts
  eval_reports/ # evaluation outcomes
  incidents/    # rollback/incident records
metrics/
  capability_scoreboard.csv
  weekly_review.md
automation/
  TASK_PROMPTS.md
  CRON_JOBS.md
skills/
  OPENCLAW_SKILLS.md
scripts/
  skill_flows/ # one-click wrappers for runbook scenarios
```

## Quick start (OpenClaw)

1. Clone the repository.
2. Point OpenClaw default workspace to this repo.
3. Restart the gateway.
4. Verify workspace setting.

```bash
git clone https://github.com/wo6909096/lobster-evolution.git
cd lobster-evolution

openclaw config set agents.defaults.workspace /Users/liyuanyuan/lobster-evolution
openclaw gateway restart
openclaw config get agents.defaults.workspace --json
```

If the gateway is supervised by LaunchAgent/system service, prefer `openclaw gateway restart` over running ad-hoc gateway processes.

## Execution contract (anti-empty-progress)

For execution requests ("do it", "start now", "land this"), the agent must:

1. Run concrete commands/tools before status updates
2. Return an execution receipt
3. Return failure receipt with exact command and error if blocked
4. Avoid placeholder-only updates

Suggested task prompt templates:

- [`automation/TASK_PROMPTS.md`](./automation/TASK_PROMPTS.md)

## Skill stack

This repository ships with an operational skill stack for OpenClaw governance workflows.

- Skill catalog: [`skills/OPENCLAW_SKILLS.md`](./skills/OPENCLAW_SKILLS.md)
- Skill index: [`skills/INDEX.md`](./skills/INDEX.md)
- Skill runbook: [`skills/SKILL_RUNBOOK.md`](./skills/SKILL_RUNBOOK.md)
- One-click flow scripts: [`scripts/skill_flows/INDEX.md`](./scripts/skill_flows/INDEX.md)

These skills are installed under local OpenClaw managed path `~/.openclaw/skills/` and cover:
- doc sync
- execution receipt enforcement
- L2 experiment drafting
- weekly review packaging
- cron diagnostics
- audit log writing
- governance cross-layer sync checks

## Proactive evolution loop

Daily:

1. Detect repeated tasks
2. Abstract a capability shape
3. Test in L2
4. Evaluate with metrics
5. Promote/hold/drop based on thresholds

Weekly:

1. Summarize experiment outcomes
2. Update scoreboard
3. Produce evaluation report
4. Prune/merge low-value capabilities

References:

- [`governance/L1/PROACTIVE_LOOP.md`](./governance/L1/PROACTIVE_LOOP.md)
- [`metrics/capability_scoreboard.csv`](./metrics/capability_scoreboard.csv)
- [`metrics/weekly_review.md`](./metrics/weekly_review.md)

## Scheduled automation

Use one heartbeat plus minimal cron jobs:

- Daily repo health check (workdays)
- Weekly evolution review
- Optional weekly L2 pruning

Commands:

```bash
openclaw cron list --all
openclaw cron run <job-id>
openclaw cron disable <job-id>
```

Full examples:

- [`automation/CRON_JOBS.md`](./automation/CRON_JOBS.md)
- [`HEARTBEAT.md`](./HEARTBEAT.md)

## Auditing and rollback

Every non-trivial change should leave a paper trail:

- Change log entry: `audits/change_logs/YYYY-MM-DD.md`
- Evaluation report: `audits/eval_reports/`
- Incident report on rollback: `audits/incidents/`

Templates:

- [`audits/change_logs/README.md`](./audits/change_logs/README.md)
- [`audits/eval_reports/EVALUATION_TEMPLATE.md`](./audits/eval_reports/EVALUATION_TEMPLATE.md)
- [`audits/incidents/ROLLBACK_REPORT_TEMPLATE.md`](./audits/incidents/ROLLBACK_REPORT_TEMPLATE.md)

## Contribution flow

1. Keep changes reproducible and measurable
2. Follow commit convention: `<type>(<scope>): <summary>`
3. Add/append audit record for non-trivial changes
4. Keep L2 candidates out of L1 until validated

Commit convention:

- [`governance/L0/COMMIT_CONVENTION.md`](./governance/L0/COMMIT_CONVENTION.md)

## Current roadmap

- Phase 1: governance bootstrap and initial candidates
- Phase 2: continuous L2 experiments and weekly promotions
- Phase 3: capability tree pruning/merging and lower execution cost

Reference:

- [`ROADMAP.md`](./ROADMAP.md)

## Troubleshooting

### "Cron/job ran but delivery failed"

Execution and delivery are separate. A run can be `ok` but `not-delivered`.

Check:

```bash
openclaw cron runs --id <job-id> --limit 5
openclaw channels status --probe --json
openclaw channels logs --channel feishu --lines 200
```

### "Agent says started but no real changes"

Validate that tool execution happened:

```bash
rg -n 'toolCall|toolResult|stopReason":"toolUse"' ~/.openclaw/agents/main/sessions/*.jsonl
```

No `toolUse` usually means no concrete execution.
