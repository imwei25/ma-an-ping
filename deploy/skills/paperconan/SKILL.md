---
name: paperconan
version: 0.8.2
description: Use when auditing paper source-data tables for numerical integrity signals, interpreting paperconan scan.json/report.html, preparing cautious PubPeer or research-integrity notes, or finding open supplementary data from a DOI/title. Trigger on 论文数据检查, source data audit, paper data audit, suspicious numeric tables, fabrication red flags, PubPeer prep, research integrity, DOI/title data fetch. Covers .xlsx/.csv/.tsv and tables in .pdf/.docx; not image forensics or chart digitization.
---

> **本仓库运行环境（先读）**：Python 用 `.venv/Scripts/python.exe`（Windows）/ `.venv/bin/python`（Linux/macOS）（项目根 `.venv`；没有先跑 `env-setup` 技能）。本技能依赖的 `paperconan` CLI **已随一键脚本装进 `.venv`**（`pip install "paperconan[all]"`）——直接跑 `paperconan --version` / `paperconan <数据目录>` 即可，**无需再 pip install、也不必问用户装哪种环境**（下方“Core Workflow 第 0 步”的安装/询问在本仓库跳过）。产出与临时文件写 `outputs/`（有会话专属目录时以它为准，勿写仓库根）。以下为上游技能原文（vendored，方法论未改）。

> **【本平台交互约定 · 覆盖下文任何“弹选项卡 / 结构化提问 / AskUserQuestion”的说法】**
> 需要用户在多个方向间拍板时，**禁止**调用 `AskUserQuestion`、也**不要**输出前端会渲染成选项卡的 `ask` JSON 代码块或任何弹窗式多选控件。一律改为在**正文用纯文本编号候选**：列 2–4 个具体、互斥的选项，每个一句话点明差异与代价；**把推荐项放第 1 个并写明“推荐 1，因为……”**；结尾明确告诉用户**直接回一个数字（如 1 / 2 / 3）即可推进**。用户只回数字＝选定该项、直接进入下一步、不再追问确认；回了别的（文字 / 否定 / 多选）按其本意走。仅当信息根本无法枚举（纯事实补录，如伦理批号、注册号、代表作清单）时才用开放式提问。


# paperconan

paperconan scans paper source-data tables for numerical anomaly signals. Treat every hit as **signal, not verdict**: report locations and patterns, never intent or misconduct.

Tool repository: https://github.com/zixixr/paperconan

## Core Workflow

0. Ensure the CLI is available before scanning: run `paperconan --version`. If it is missing and pip works, install once with `pip install "paperconan[all]"` (ask first if a virtualenv or non-global install is preferred). If Python/pip is unavailable, ask the user to install and run locally — never fabricate output.
1. Confirm what the user supplied:
   - Local source-data directory: run `paperconan <input-dir>`.
   - DOI or title: run `paperconan fetch "<DOI or title>"`, choose a matched tabular dataset, download it, then scan the downloaded directory.
   - Only an existing audit: read `audit/scan.json` and use `audit/report.html` as the evidence browser to triage — then give an adjudicated answer. Do not hand the raw `report.html` over as "the result" (see Report Positioning below).
2. Prefer the real CLI. Do not invent findings from eyeballing tables.
3. Parse `scan.json`, then load the reference file needed for the task.
4. Open the original table when describing a serious finding as worth follow-up. If the original data is unavailable, say the finding is unverified.
5. Answer cautiously: explain the anomaly, plausible benign explanations, and what human context is needed.

## Review Modes

Choose the lightest mode that satisfies the user request:

- **Single-paper scan**: fetch/scan if needed, open the source table for serious
  findings, check labels/legend/Methods when available, then give a concise
  answer using [references/report-templates.md](references/report-templates.md)
  only if a report is requested.
- **Single-paper formal review**: after scan and source-table verification,
  load [references/adjudication-tiers.md](references/adjudication-tiers.md) and
  [references/report-templates.md](references/report-templates.md). Use Tier
  labels only as review priority / innocent-explanation difficulty, never as
  misconduct probability.
- **Batch review**: use [references/batch-workflow.md](references/batch-workflow.md).
  Keep deterministic paperconan output separate from agent judgment. Preserve
  DROP reasons because repeated false positives can guide future filters.
- **Adversarial review**: for Tier 1/Tier 2, PubPeer drafts, public-facing
  claims, or filter changes based on alleged false positives, load
  [references/adversarial-review.md](references/adversarial-review.md) and try
  to refute the concern before confirming it.

Do not write a full eight-section report for ordinary scan summaries. Use the
full report only for Tier 1/Tier 2 KEEP, PubPeer-style drafting, formal
research-integrity notes, or when the user explicitly asks for it.

## Report Positioning

The pipeline is **scan → agent triage/judgment → adjudicated report**. Keep the
two report artifacts distinct:

- `audit/report.html` (from the bare CLI) is a **deterministic detector /
  evidence browser** — a triage worklist. It is false-positive-heavy by design
  and represents **no judgment**. It is an intermediate artifact, not the
  user-facing deliverable. Never present it as "the audit result".
- The **user-facing deliverable is always agent-adjudicated**, produced only
  after you triage `scan.json`, open the source tables for serious findings, and
  weigh benign explanations: a short adjudicated summary for ordinary cases, or
  the eight-section report (`paperconan report scan.json --verdict verdict.json
  --out …`) for Tier 1/Tier 2 KEEP and formal/public writing.

So the raw `report.html` is what *you* read to triage; the adjudicated summary or
eight-section report is what the *user* receives. A plain CLI user who only runs
`paperconan <dir>` has no agent in the loop, so they see only the raw browser —
tell them the findings still need human/agent triage before they mean anything.

## Install And Run

```bash
pip install paperconan
pip install "paperconan[all]"   # includes PDF / Word table extraction
paperconan --version
paperconan <input-dir>
```

Default output:

```text
<input-dir>/audit/scan.json
<input-dir>/audit/report.html
```

Useful variants:

```bash
paperconan <input-dir> --out /tmp/audit-X
paperconan <input-dir> --md
paperconan <input-dir> --no-html
paperconan <input-dir> --profile forensic
paperconan report /tmp/audit-X/scan.json --verdict verdict.json --out adjudication.html
```

If Python or package access is unavailable, tell the user to run the command locally. A manual review may be offered only as a non-authoritative hint and must not be presented as paperconan output.

## Fetching Data

Use fetch only when the user gives a DOI/title instead of local files:

```bash
paperconan fetch "<DOI or title>"
paperconan fetch "<DOI or title>" --json
paperconan fetch "<DOI>" --download <id> --out data/
paperconan data/
```

Prefer candidates with `doi_in_related: true`. Repository search can return unrelated deposits, so report weak matches honestly and do not imply "no data found" means "paper is clean". Do not bypass paywalls or scrape publisher sites.

## Profiles

`--profile {review,forensic,triage}` changes what you see in `scan.json`:

- `review` is the default. It keeps likely false positives visible but may demote them to `low`.
- `forensic` preserves raw detector severity. Use it before saying a concerning hit was only low severity under the raw detector.
- `triage` hides likely false positives.

When a finding has `profile_action: "demoted"` or `profile_action: "hidden"`, the active profile changed the visible severity. Use `prefilter_reason`, `prefilter_flags`, and `false_positive_context` to explain why, then decide whether the filter reason actually fits the table context.

## Reference Routing

Load references only when needed:

- [references/output-schema.md](references/output-schema.md): read before parsing `scan.json` or explaining fields such as `profile_action`, `prefilter_reason`, `value_sample`, `col_a_sample`, or `cross_sheet_findings`.
- [references/detectors.md](references/detectors.md): read when interpreting a detector kind and its common false positives.
- [references/judgment-rubric.md](references/judgment-rubric.md): read before ranking findings, judging within-column signals, or drafting PubPeer/research-integrity language.
- [references/interpretation.md](references/interpretation.md): read when composing the final user-facing answer or handling requests to accuse, expose, or escalate.
- [references/adjudication-tiers.md](references/adjudication-tiers.md): read before assigning `Tier 1/2/3`, `KEEP`, `DROP`, `NEEDS_HUMAN`, or `impact_scope`.
- [references/report-templates.md](references/report-templates.md): read before writing a formal report, PubPeer draft, research-integrity note, or batch verdict JSON.
- [references/adversarial-review.md](references/adversarial-review.md): read before confirming Tier 1/Tier 2, public-facing concerns, or proposed filter changes.
- [references/batch-workflow.md](references/batch-workflow.md): read when reviewing multiple papers or organizing candidate queues.
- [references/case-patterns.md](references/case-patterns.md): read for synthetic calibration patterns only; do not treat them as real case precedents.

## Judgment Discipline

- Never convert `severity` into a misconduct conclusion. Severity means anomaly strength after the active profile, not author intent.
- Never convert `Tier 1/2/3` into a misconduct probability. Tier means follow-up priority and difficulty of innocent explanation after context review.
- Inspect cross-sheet reuse and cross-column transforms before weaker single-column patterns.
- Prefer benign structural explanations first: shared controls, re-plots, unit conversions, formulas, indices, ratios, normalized values, model outputs, detection floors, and bounded scoring scales.
- Treat `within_col_*` findings as false-positive-heavy by default. Do not strongly report `n < 10`, categorical/index labels, derived columns, fixed-denominator ratios, rounded grids, floors/ceilings, or repeated fill values.
- Use "needs human context" when you cannot confirm row independence, raw measurement status, formula generation, Methods/legend meaning, or original-table provenance.
- For PubPeer-style writing, provide concrete file/sheet/column evidence and questions for the authors; do not say "fake", "fraud", "fabricated", "实锤", or name authors as wrongdoers.
- Do not use real papers as public calibration examples unless the user has
  explicitly asked to prepare a specific public note and the evidence has been
  checked against source data and paper context.

## Output Shape

A normal scan summary should include:

1. What was scanned and whether any files failed to parse.
2. The highest-priority findings after manual/field-level triage, grouped by file.
3. Concrete evidence snippets: detector kind, location, `rule`, `n`, and a small value sample when useful.
4. Plausible benign explanations and what would resolve them.
5. A pointer to `report.html` for highlighted table context.

For batch or agent-to-agent workflows, an optional verdict JSON may use:
`verdict`, `suspicion_tier`, `impact_scope`, `tier_why`, `drop_reason`,
`innocent_explanation`, `needs_author_data`, `report_md`, `review_status`, and
`finding_refs` (selectors naming which scan finding(s) the verdict adjudicated,
so the rendered report scopes its evidence panel to them). When a paper has
more than one distinct finding, use a paper-level object with a `findings`
array (each entry adjudicated on its own tier/status with its own
`finding_ref`); the report then renders one self-contained block per finding.
See [references/adjudication-tiers.md](references/adjudication-tiers.md) and
[references/report-templates.md](references/report-templates.md).

When a verdict JSON already exists, `paperconan report <scan.json> --verdict
<verdict.json> --out <html>` renders a separate adjudicated report. Do not
confuse this with the default deterministic `audit/report.html`; the
adjudicated report is only as reliable as the human/AI verdict and source
context behind it.

If the user asks "is this fraud?", answer that paperconan cannot determine that. The next step is to verify the original data and, if concerns remain, ask for clarification through PubPeer, the journal, or a research integrity office.
