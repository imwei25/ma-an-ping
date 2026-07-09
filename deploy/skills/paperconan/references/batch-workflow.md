# paperconan batch workflow

Use this reference when reviewing many papers, many source-data folders, or a
candidate queue produced by paperconan. This is a public, local-first workflow.
It does not require PaperConan-specific databases, Blob storage, cloud workers,
or private helper scripts.

Core principle: paperconan performs deterministic scanning and filtering; humans
or agents perform contextual judgment, tiering, and adversarial review.

## Directory Layout

Recommended local layout:

```text
runs/
  paper-001/
    source/              # downloaded or user-provided source data
    audit/
      scan.json
      report.html
    dossier/
      findings.json      # distilled candidate findings, optional
      context.md         # paper title, DOI if public, figure legend notes, Methods notes
      verdict.json       # builder verdict
      report.md          # full report when KEEP/Tier requires it
      review.json        # adversarial review
  paper-002/
    ...
  batch_summary.csv
```

Do not commit real source data, PDFs, screenshots, or reports about named papers
unless you have checked copyright, privacy, and defamation risks. Public
examples should use synthetic data.

## Batch Steps

1. **Fetch or stage data**
   - For DOI/title input, run `paperconan fetch "<DOI or title>" --auto --out runs/<paper-id>/source/`.
   - If auto-fetch cannot confirm a match, record that the data were not found;
     do not infer that the paper is clean.

2. **Scan**
   - Run `paperconan runs/<paper-id>/source/ --out runs/<paper-id>/audit/`.
   - Use `--profile triage` for first-pass volume reduction.
   - Use `--profile forensic` when a hidden/demoted finding needs raw detector
     severity.

3. **Dossier**
   - Preserve original tables, `scan.json`, and `report.html`.
   - Distill candidate findings with file, sheet, rows, columns, `kind`, `rule`,
     `n`, samples, prefilter fields, and paper context.
   - Note which materials were opened: source table, figure legend, Methods,
     main text, supplementary notes.

4. **Builder verdict**
   - Apply `judgment-rubric.md` and `adjudication-tiers.md`.
   - Emit `verdict.json`.
   - Write `report.md` only for Tier 1/Tier 2 KEEP or when explicitly requested.

5. **Adversarial review**
   - Apply `adversarial-review.md`.
   - Red team tries to reject or downgrade the KEEP.
   - Store `review.json` separately from `verdict.json`.

6. **Summary**
   - Write a batch table with paper id, scan status, top detector, verdict,
     tier, impact, review status, and one-line reason.
   - Keep DROP reasons; repeated DROP reasons are evidence for improving
     deterministic filters.

## Suggested Batch Summary Columns

```text
paper_id
input_source
paper_title_or_doi
scan_status
top_finding_kind
verdict
suspicion_tier
impact_scope
review_status
tier_why
drop_reason
needs_author_data
audit_path
report_path
```

For public sharing, omit private paths and replace paper identifiers with
anonymous IDs unless the user intentionally prepares a specific public note.

## When To Stop

Stop or mark `NEEDS_HUMAN` when:

- source data cannot be opened;
- key figure legends or Methods are unavailable;
- row independence cannot be established;
- the strongest signal is from a false-positive-heavy detector class;
- the case would require field-specific experimental knowledge.

## Filter Improvement Loop

After a batch:

1. Group DROP decisions by `drop_reason`.
2. Promote only general patterns to deterministic filters.
3. Before changing a filter, replay it on previous KEEP/Tier cases and confirm
   it does not hide real concerns.
4. Keep rules general. Do not hard-code paper titles, DOI fragments, author
   names, institution names, or one-off numeric thresholds.

Public filter improvements belong in source code and tests. Project-specific
downloads, reports, and private audit notes do not.
