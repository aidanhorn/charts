# Real estate

| Pillar | Script | Source | Cadence |
|---|---|---|---|
| Real (CPI-adjusted) house-price growth, 6 major markets | [real_estate_house_prices.R](../scripts/real_estate_house_prices.R) | [OECD](https://data-explorer.oecd.org/) Analytical House Prices Indicators (SDMX REST API, no key) | Quarterly |

Markets: Australia, China, Germany, Japan, United Kingdom, United States. `RHP` (Real house price indices) measure, `FREQ == "Q"` — the dataflow mixes quarterly and annual rows for the same series, so filtering by frequency explicitly matters (an earlier version of this script didn't, and picked up bogus annual-frequency dates).

Facets use a wider `panel.spacing.x` than the ggplot2 default, since adjacent panels' year labels (e.g. one panel's "2026" next to the next panel's "2016") were otherwise crowded together.
