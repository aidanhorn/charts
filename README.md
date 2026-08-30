# charts

Source for [charts.aidanhorn.co.za](https://charts.aidanhorn.co.za) — a small set of automated, self-updating charts across a few genuinely interesting data domains, each pulling from a real public API on its own schedule via GitHub Actions.

Site is a set of full-screen pages (one per pillar) with a top nav bar for navigation — see `index.html` (landing page) and `crypto.html`/`climate.html`/`energy.html`/`real-estate.html`/`commodities.html`/`traffic.html`. Shared styling in `assets/style.css`, shared dark/high-contrast ggplot2 theme in `scripts/_theme.R`.

## Pillars

| Pillar | Script | Source | Cadence | Status |
|---|---|---|---|---|
| Crypto (BTC/USD, log scale) | [crypto_btc.R](scripts/crypto_btc.R) | [CoinGecko](https://www.coingecko.com/en/api) (free tier) | Daily | Live |
| Climate (global PM2.5 air quality) | [climate_air_quality.R](scripts/climate_air_quality.R) | [OpenAQ](https://openaq.org/) v3 API (needs a free `OPENAQ_API_KEY` repo secret) | Daily | Live |
| Commodities (Brent crude oil) | [commodities_oil.R](scripts/commodities_oil.R) | [FRED](https://fred.stlouisfed.org/) (free CSV, no key) | Daily | Live |
| Energy (generation mix by country) | [energy_generation_mix.R](scripts/energy_generation_mix.R) | [Our World in Data](https://github.com/owid/energy-data) energy dataset (Ember's own site blocks programmatic access) | Monthly | Live |
| Real estate (real house-price growth, major markets) | [real_estate_house_prices.R](scripts/real_estate_house_prices.R) | [OECD](https://data-explorer.oecd.org/) Analytical House Prices Indicators (SDMX REST API, no key) | Quarterly | Live |
| Traffic (global congestion) | _not built_ | [TomTom Traffic Index](https://www.tomtom.com/traffic-index/) | Annual | Deferred — ranking data is client-rendered with no accessible free endpoint found yet; lowest priority pillar |

All data sources are free/public — no paid feeds. See `.github/workflows/update-charts.yml` for the scheduling (crypto/climate/commodities run daily; energy/real-estate run monthly; `workflow_dispatch` runs everything for manual testing).

## Why this exists

Built as a deliberately separate project, chosen to be orthogonal to Aidan's day job at Codera Analytics — nothing here overlaps with EconData or SA official statistics. FX/currency markets were considered and ruled out entirely for the same reason (Codera already runs its own FX pipeline).
