# paperconan case patterns

This file contains synthetic, abstract calibration patterns. It deliberately
does not include real DOI, paper titles, author names, institutions, journal
case studies, or real source-data excerpts.

Use these patterns to calibrate reasoning, not as fixed legal rules. A real
paper still requires source-table, legend, Methods, and context checks.

## Pattern A: Independent Columns Are Identical

Synthetic table:

```text
sample    treatment_A    treatment_B
s1        1.2034         1.2034
s2        1.1877         1.1877
s3        1.2641         1.2641
s4        1.2219         1.2219
```

Likely detector:

- `identical_column`

Initial interpretation:

- If `treatment_A` and `treatment_B` are independent raw measurements from
  different samples or treatment groups, this can be a Tier candidate.
- If `treatment_B` is a disclosed re-plot, duplicate export, shared baseline,
  or formula reference, DROP.
- If labels do not establish independence, NEEDS_HUMAN.

## Pattern B: Strict Offset Between Raw-Looking Columns

Synthetic table:

```text
time    group_A    group_B
1       2.104      2.304
2       2.188      2.388
3       2.241      2.441
4       2.290      2.490
```

Likely detector:

- `constant_offset`

Initial interpretation:

- If both columns are presented as independent raw measurements, a row-wise
  constant offset is harder to explain than a copied column.
- Check unit conversion, baseline correction, normalization, calibration,
  background subtraction, and axis/time columns before assigning a tier.

## Pattern C: Unit Conversion Or Formula-Derived Column

Synthetic table:

```text
sample    mass_g    mass_mg
s1        0.10      100
s2        0.15      150
s3        0.22      220
```

Likely detector:

- `constant_ratio`

Expected verdict:

- DROP with `drop_reason: "unit_conversion"` if labels disclose the relation.

## Pattern D: Fixed Denominator Percentages

Synthetic table:

```text
group    responders_percent
A        33.333333
B        66.666667
C        16.666667
D        83.333333
```

Likely detector:

- `within_col_decimal_repetition`

Expected verdict:

- Usually DROP if values are explained by `k/N` arithmetic, such as counts out
  of a small fixed denominator.
- NEEDS_HUMAN if the denominator is not disclosed but the column is clearly a
  percentage.

## Pattern E: Missing Independence Context

Synthetic table:

```text
row    value
1      0.208975
2      0.208975
3      0.208975
4      0.313442
```

Likely detector:

- `within_col_value_duplication`

Initial interpretation:

- This is not enough for a strong concern by itself.
- It may be a repeated technical read, fill value, rounded display, detection
  floor, small denominator, or repeated export.
- Use NEEDS_HUMAN unless the table and paper establish raw independent
  measurements and exclude ordinary explanations.

## Pattern F: Copy-Then-Tweak Across Tables

Synthetic source-data summary:

```text
Table 1 values:  4.201, 5.118, 6.004, 7.332
Table 2 values:  4.201, 5.118, 6.104, 7.332
```

Likely detector:

- `cross_sheet_position_identical` with a value-tweaked delta, or related
  cross-sheet overlap/tail-reuse detectors.

Initial interpretation:

- Higher priority than ordinary perfect duplication because most values are
  reused while one or more values differ.
- Check whether one table is a corrected version, a disclosed re-analysis, or a
  combined-vs-subset table.
- If labels claim independent figures/conditions and no benign explanation
  fits, this can become Tier 1 or Tier 2 depending on impact.

## Pattern G: Shared Control

Synthetic setup:

```text
figure_1_control:  0.91, 1.04, 0.98
figure_2_control:  0.91, 1.04, 0.98
```

Initial interpretation:

- Shared controls can be legitimate when disclosed or when the experiment
  design makes reuse clear.
- Do not tier solely because a control appears in two panels.
- Keep only if the paper presents the repeated data as different independent
  controls or if the reuse is undisclosed and materially changes the claim.

## Pattern H: Summary Statistic Impossibility

Synthetic setup:

```text
n = 5
integer count outcome
reported mean = 2.13
```

Likely detector:

- `grim_inconsistent`

Initial interpretation:

- This can be strong only if the measured outcome is truly integer-granular and
  `n` is correctly identified.
- DROP or NEEDS_HUMAN if the outcome is continuous, normalized, adjusted, or if
  `n` is ambiguous.
