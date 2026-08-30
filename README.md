# charts

Source for [charts.aidanhorn.co.za](https://charts.aidanhorn.co.za) — a small set of automated, self-updating charts across a few genuinely interesting data domains, each pulling from a real public API on its own schedule via GitHub Actions.

## Pillars

| Pillar | Script | Source | Cadence |
|---|---|---|---|
| Crypto (BTC/USD, log scale) | `scripts/crypto_btc.R` | [CoinGecko](https://www.coingecko.com/en/api) (free tier) | Daily |
| Climate (air quality) | _not yet built_ | [OpenAQ](https://openaq.org/) | Near-real-time |
| Energy (generation mix) | _not yet built_ | [Ember](https://ember-energy.org/) | Annual/monthly |
| Real estate (house prices) | _not yet built_ | [OECD](https://data-explorer.oecd.org/) | Quarterly |
| Commodities (oil) | _not yet built_ | TBD | Daily |
| Traffic (congestion) | _not yet built_ | [TomTom Traffic Index](https://www.tomtom.com/traffic-index/) | Annual |

All data sources are free/public — no paid feeds. See `.github/workflows/update-charts.yml` for the scheduling.

## Why this exists

Built as a deliberately separate project, chosen to be orthogonal to Aidan's day job at Codera Analytics — nothing here overlaps with EconData or SA official statistics.
