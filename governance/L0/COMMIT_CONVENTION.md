<!-- input: 来自上级任务、所属目录 INDEX、相关治理文件 -->
<!-- output: 产出本文件定义的规则/模板/记录/说明 -->
<!-- pos: governance/L0/COMMIT_CONVENTION.md；若所属文件夹变化请更新我；若文件更新必须同步更新我的开头注释和所属文件夹的MD。 -->
# COMMIT_CONVENTION

建议格式：`<type>(<scope>): <summary>`

类型示例：
- feat: 新增能力/功能
- promote: L2 -> L1 升级
- merge: 能力合并
- rollback: 回滚
- docs: 文档治理更新

示例：
- feat(dev-cap): add CAP-code-review-batch (L2)
- promote(director): CAP-scene-pacing-v2 to L1
- rollback(ops-cap): revert CAP-auto-deploy-guard