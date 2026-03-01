<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: automation/TASK_PROMPTS.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# TASK_PROMPTS

以下模板用于避免"口头开始、没有执行"。
推荐优先调用仓库一键脚本：`scripts/skill_flows/*.sh`。

## 场景到脚本映射

| 任务场景 | 推荐脚本 |
| --- | --- |
| 执行任务防空转 | `scripts/skill_flows/scene_a_execute_with_receipt.sh` |
| 文档/索引联动检查 | `scripts/skill_flows/scene_b_doc_sync.sh` |
| 重复需求升级为实验 | `scripts/skill_flows/scene_c_experiment_bootstrap.sh` |
| 周评审与指标更新 | `scripts/skill_flows/scene_d_weekly_review.sh` |
| cron 异常排查 | `scripts/skill_flows/scene_e_cron_diagnose.sh` |
| 事故/回滚审计闭环 | `scripts/skill_flows/scene_f_incident_close_loop.sh` |

## 模板 1：执行类任务

在当前仓库执行，不要只回复状态。
先执行再回复，最终只返回：
1. 修改文件列表
2. `git status -sb`
3. commit hash（如已提交）
4. 若失败：失败命令 + 原始错误 + 下一步修复

推荐命令（先执行再汇报）：

```bash
bash scripts/skill_flows/scene_a_execute_with_receipt.sh \
  --repo /Users/liyuanyuan/lobster-evolution \
  --reply-file /tmp/reply.md \
  --mode success \
  --domain-cmd "git status -sb"
```

## 模板 2：修复类任务

请直接修复，不要给方案草稿。
要求：
1. 先复现
2. 再修复
3. 最后回执（复现命令、修复点、验证结果、git status）

修复后联动检查：

```bash
bash scripts/skill_flows/scene_b_doc_sync.sh \
  --repo /Users/liyuanyuan/lobster-evolution
```

## 模板 3：周复盘任务

请基于本仓库执行周复盘：
1. 汇总本周 L2 实验
2. 更新 `metrics/capability_scoreboard.csv`
3. 输出结论到 `audits/eval_reports/`
4. 返回变更文件和 git status

推荐命令（先 dry-run 校验参数，再正式执行）：

```bash
bash scripts/skill_flows/scene_d_weekly_review.sh \
  --repo /Users/liyuanyuan/lobster-evolution \
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
