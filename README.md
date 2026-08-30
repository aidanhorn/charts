# charts

Source for [charts.aidanhorn.co.za](https://charts.aidanhorn.co.za) — a small set of automated, self-updating charts across a few genuinely interesting data domains, each pulling from a real public API on its own schedule via GitHub Actions.

Site is one folder per section, each an `index.html` (its default page) plus sibling pages for sections with a sub-nav (Crypto, Commodities): `index.html` (landing page), `crypto/` (index=Bitcoin, `eth.html`/`sol.html`/`xrp.html`/`ltc.html`), `climate/`, `energy/`, `real-estate/`, `commodities/` (index=Oil, `copper.html`/`natgas.html`/`wheat.html`/`corn.html`). `traffic/` still exists but is unlinked from all navigation (deferred, see below). Shared styling in `assets/style.css`, shared dark/high-contrast ggplot2 theme + crypto/FRED chart builders in `scripts/_theme.R`. Every page carries a Google Analytics (gtag.js) tag.

## Pillars

| Pillar | Script | Source | Cadence | Status |
|---|---|---|---|---|
| Crypto — Bitcoin | [crypto_btc.R](scripts/crypto_btc.R) | [CoinGecko](https://www.coingecko.com/en/api) (free tier) | Daily | Live |
| Crypto — Ethereum | [crypto_eth.R](scripts/crypto_eth.R) | CoinGecko (free tier) | Daily | Live |
| Crypto — Solana | [crypto_sol.R](scripts/crypto_sol.R) | CoinGecko (free tier) | Daily | Live |
| Crypto — XRP | [crypto_xrp.R](scripts/crypto_xrp.R) | CoinGecko (free tier) | Daily | Live |
| Crypto — Litecoin | [crypto_ltc.R](scripts/crypto_ltc.R) | CoinGecko (free tier) | Daily | Live |
| Climate (global PM2.5 air quality, grid heatmap) | [climate_air_quality.R](scripts/climate_air_quality.R) | [OpenAQ](https://openaq.org/) v3 API (needs a free `OPENAQ_API_KEY` repo secret) | Daily | Live |
| Commodities — Oil (Brent crude) | [commodities_oil.R](scripts/commodities_oil.R) | [FRED](https://fred.stlouisfed.org/) official API (needs a free `FRED_API_KEY` repo secret) | Daily | Live |
| Commodities — Natural Gas (Henry Hub) | [commodities_natgas.R](scripts/commodities_natgas.R) | FRED (DHHNGSP, needs `FRED_API_KEY`) | Daily | Live |
| Commodities — Copper | [commodities_copper.R](scripts/commodities_copper.R) | FRED (PCOPPUSDM, needs `FRED_API_KEY`) | Monthly | Live |
| Commodities — Wheat | [commodities_wheat.R](scripts/commodities_wheat.R) | FRED (PWHEAMTUSDM, needs `FRED_API_KEY`) | Monthly | Live |
| Commodities — Corn | [commodities_corn.R](scripts/commodities_corn.R) | FRED (PMAIZMTUSDM, needs `FRED_API_KEY`) | Monthly | Live |
| Energy (generation mix by country) | [energy_generation_mix.R](scripts/energy_generation_mix.R) | [Our World in Data](https://github.com/owid/energy-data) energy dataset (Ember's own site blocks programmatic access) | Monthly | Live |
| Real estate (real house-price growth, major markets) | [real_estate_house_prices.R](scripts/real_estate_house_prices.R) | [OECD](https://data-explorer.oecd.org/) Analytical House Prices Indicators (SDMX REST API, no key) | Quarterly | Live |
| Traffic (global congestion) | _not built_ | [TomTom Traffic Index](https://www.tomtom.com/traffic-index/) | Annual | Deferred, unlinked from nav — ranking data is client-rendered with no accessible free endpoint found yet; lowest priority pillar |

All data sources are free/public — no paid feeds, though FRED and OpenAQ need a (free, registered) API key stored as a repo secret. See `.github/workflows/update-charts.yml` for the scheduling (crypto/climate/oil/natural gas run daily; energy/real-estate/copper/wheat/corn run monthly; `workflow_dispatch` runs everything for manual testing).

Note on gold/silver: FRED's own LBMA gold/silver series are discontinued; Stooq now requires a JS proof-of-work challenge that a script can't solve headless; the World Bank's Pink Sheet data uses unstable, dated document URLs unsuitable for reliable automation. Not pursued further for now.

Pages with a sub-nav (Crypto, Commodities) use a shorter portrait chart height (`port_h`) than single-page pillars, since the extra sub-nav bar leaves less vertical room on mobile before scrolling would be needed.

## Why this exists

Built as a deliberately separate project, chosen to be orthogonal to Aidan's day job at Codera Analytics — nothing here overlaps with EconData or SA official statistics. FX/currency markets were considered and ruled out entirely for the same reason (Codera already runs its own FX pipeline).
