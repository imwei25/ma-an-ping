# 科研写作技能套件（skills/）

本目录是一组**独立的科研 / 医学写作技能**（17 个），**没有顶层主控 / 路由**——每个技能靠自己 `<名>/SKILL.md` 里的 `description` 自行触发，agent 命中哪个用哪个。仓库根的 `AGENTS.md` / `CLAUDE.md` 只是项目说明与几条通用硬规矩，不是调度器。

## 技能清单
- **顶刊论文**：`nature-writing`、`nature-polishing`、`nature-statistics`、`nature-reviewer`、`nature-figure`
- **论文撰写 / 拆解**：`paper-writer`（IMRaD 全流程）、`paper-spine`（范文拆解、结构迁移）
- **深度研究 / 综述**：`academic-research-suite`（多源检索+核查）、`survey-builder`（叙述性综述；占位）
- **私有知识库**：`paper-qa`（本地 PDF RAG；占位·需配 API key）
- **基金标书**：`fund-background-writer`、`fund-literature-review-writer`、`fund-research-content-writer`、`fund-technical-route-writer`
- **文稿核查**：`reference-check`（查假引用）、`humanize-academic`（去 AI 味）
- **基础设施**：`env-setup`（建 `.venv`、装依赖）
- 另有 `_shared/`：Nature 系技能共用片段资源，**不是独立技能**。

## 更新技能：跑一键脚本，别手动拷

拉取最新代码后（`git pull`），**在仓库根运行一键安装/更新脚本**：

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File install.ps1      # 或 scripts\setup.ps1
```
```bash
# Linux / macOS
bash install.sh                                           # 或 scripts/setup.sh
```

脚本做的事：建/复用项目根 `.venv` → 装/更新依赖（`scripts/requirements-skills.txt`）→ 跑 `scripts/validate_skills.py` 校验（无 BOM、frontmatter 合法、两套镜像技能集合一致、正文无漂移）。**不再写任何路由文件**。Claude Code 用户可加 `-LinkClaude` / `--link-claude` 把技能复制到 `~/.claude/skills/`。

## 双镜像
- `.opencode/skills/`：本地（OpenCode，解释器走 `.venv\Scripts\python.exe`）
- `deploy/skills/`：服务器 / 容器（`python3`）；**线上更新要重建 Docker 镜像**才生效。

改技能须两套镜像同步改——`validate_skills.py` 会抓出「正文漂移」和「镜像不一致」。

## 第三方来源
本套件多数技能从上游开源仓库引入（vendored），来源与许可见仓库根 `THIRD_PARTY_SKILLS.md`。
