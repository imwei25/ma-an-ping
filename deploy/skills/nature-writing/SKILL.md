---
name: nature-writing
description: Draft, restructure, or plan Nature-style manuscript sections from author-provided claims, results, figures, notes, or Chinese drafts. Use when the user wants to write or rebuild an abstract, introduction, related-work, method, experiments, discussion, conclusion, title, or full manuscript argument rather than only polish finished prose. Also trigger on general academic-writing requests even without the word "Nature", such as writing a paper from scratch, drafting a manuscript/section, structuring a paper, and Chinese phrasings like 学术写作、科研写作、论文写作、写论文、写paper、SCI写作、帮我写论文、搭论文框架、起草论文、写引言/摘要/讨论.
version: 1.0.0
author: Community contribution, refactored into static/dynamic layers
---

> **【本平台交互约定 · 覆盖下文任何“弹选项卡 / 结构化提问 / AskUserQuestion”的说法】**
> 需要用户在多个方向间拍板时，**禁止**调用 `AskUserQuestion`、也**不要**输出前端会渲染成选项卡的 `ask` JSON 代码块或任何弹窗式多选控件。一律改为在**正文用纯文本编号候选**：列 2–4 个具体、互斥的选项，每个一句话点明差异与代价；**把推荐项放第 1 个并写明“推荐 1，因为……”**；结尾明确告诉用户**直接回一个数字（如 1 / 2 / 3）即可推进**。用户只回数字＝选定该项、直接进入下一步、不再追问确认；回了别的（文字 / 否定 / 多选）按其本意走。仅当信息根本无法枚举（纯事实补录，如伦理批号、注册号、代表作清单）时才用开放式提问。


> **本仓库运行环境（先读）**：Python 用 `.venv/Scripts/python.exe`（Windows）/ `.venv/bin/python`（Linux/macOS）（项目根 `.venv`；没有先跑 `env-setup` 技能）；本技能脚本与资源在 `skills/nature-writing/` 下，运行时先 `cd` 到该目录或用全路径；产出写 `outputs/`（有会话专属目录时以它为准、勿写仓库根固定名）。以下为上游技能原文（vendored，方法论未改）。


# Nature-Style Scientific Writing — Router

This skill is split into two layers:

- A **static layer** under `static/` that holds versioned, reusable content fragments (core stance + workflow, paper-type playbooks, per-section drafting guidance, language-specific rules, per-journal style).
- A **dynamic layer** (this file plus `manifest.yaml`) that detects the request's axes and loads only the fragments needed for the current job.

Do not try to apply the drafting logic from memory or from this router. Always load fragments from disk as described below.

## Routing protocol

Follow these five steps every time the skill is invoked.

### 1. Load the manifest and the core layer

Read [manifest.yaml](manifest.yaml). It declares the axes (`paper_type`, `section`, `language`, `journal`), the allowed values, and the file paths each value maps to.

Also read every file listed under `always_load`. These hold the default stance, writing workflow, and output format that apply to every drafting job.

### 2. Detect the axis values for this request

For each axis in the manifest, decide the value using the manifest's `detect:` hint and the user's input:

- `paper_type` — research / methods / hypothesis / algorithmic / review. Default: research.
- `section` — abstract / intro / related-work / method / experiments / discussion / conclusion / title. May be multiple. Ask the user if it is ambiguous and matters for the draft.
- `language` — en or zh-to-en. Detect from the user's notes themselves.
- `journal` — nature / nat-comms / generic. Default: generic. If the user names a Nature subjournal, treat it as `nature`.

State the detected axis values in one short line to the user before drafting, so they can correct you cheaply.

### 3. Load the matching fragments

For each axis value, Read the file mapped in the manifest. Skip the `section` axis only when the user has explicitly asked for a free-floating argument paragraph with no section context.

Do **not** read every fragment in `static/`. Load only what step 2 selected.

### 4. Draft using the loaded material

Apply the loaded fragments in this priority order:

1. Core stance + intake (`core/stance.md`) — surface missing claim / evidence / boundary before drafting.
2. Paper-type playbook — argument chain, drafting order.
3. Section-specific drafting rules and structure.
4. Journal-specific framing and constraints.
5. Language-specific sentence and paragraph rules (apply last).

Run the 8-step workflow in `core/workflow.md` end-to-end. Do not skip steps 1-3 (planning) just because the user asked for prose immediately — write the one-sentence argument first.

If essential evidence or boundary is missing, write a placeholder and list it under `Assumptions or missing inputs:` instead of inventing content.

### 5. Reach for references only when needed

The files under `references/` are deep references and the example library, not defaults. Open them on demand per the `references.on_demand` table in the manifest. Typical triggers:

- The user asks for a concrete example or template → `references/examples/index.md`.
- A section's draft has structural problems that the section fragment alone does not explain → the matching `references/<section>.md`.
- The user needs a broad-audience `Nature` abstract opening or asks about a `summary paragraph` → `references/nature-summary-paragraph.md`.
- The user asks "does this paragraph flow?" → `references/paragraph-flow.md`.
- The user asks for a self-review or rejection-risk audit → `references/paper-review.md`.

## Why this split

- The static layer is versioned and reviewable. Adding a new journal style, paper type, or section is one new file plus one manifest line.
- The dynamic layer keeps each invocation cheap: only the fragments relevant to this draft enter context, instead of the full multi-thousand-line reference set.
- The router itself is short on purpose. Update fragments, not this file, when adding scope.
- This structure mirrors `nature-polishing` so shared content can later be lifted into a `_shared/` layer used by both skills.
