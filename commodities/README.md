# Commodities

| Pillar | Script | Source | Cadence |
|---|---|---|---|
| Oil (Brent crude) | [commodities_oil.R](../scripts/commodities_oil.R) | FRED (DCOILBRENTEU) | Daily |
| Natural Gas (Henry Hub) | [commodities_natgas.R](../scripts/commodities_natgas.R) | FRED (DHHNGSP) | Daily |
| Copper | [commodities_copper.R](../scripts/commodities_copper.R) | FRED (PCOPPUSDM) | Monthly |
| Wheat | [commodities_wheat.R](../scripts/commodities_wheat.R) | FRED (PWHEAMTUSDM) | Monthly |
| Corn | [commodities_corn.R](../scripts/commodities_corn.R) | FRED (PMAIZMTUSDM) | Monthly |
| Soybeans | [commodities_soybeans.R](../scripts/commodities_soybeans.R) | FRED (PSOYBUSDM) | Monthly |
| Aluminum | [commodities_aluminum.R](../scripts/commodities_aluminum.R) | FRED (PALUMUSDM) | Monthly |
| Cocoa | [commodities_cocoa.R](../scripts/commodities_cocoa.R) | FRED (PCOCOUSDM) | Monthly |
| Cotton | [commodities_cotton.R](../scripts/commodities_cotton.R) | FRED (PCOTTINDUSDM) | Monthly |

All via [FRED](https://fred.stlouisfed.org/)'s official API (`api.stlouisfed.org`, needs a free `FRED_API_KEY` repo secret — the undocumented `fredgraph.csv` scrape endpoint was dropped in favour of this), through the shared `build_fred_chart()` helper in [../scripts/_theme.R](../scripts/_theme.R). Copper/Wheat/Corn/Soybeans/Aluminum/Cocoa are all IMF global commodity prices (USD/tonne) under FRED's `P<CODE>USDM` naming family; Cotton's series (`PCOTTINDUSDM`) is priced in US cents/lb instead — confirmed via the series metadata, not assumed — so `build_fred_chart()` takes a `value_prefix`/`value_suffix` pair to render its axis/subtitle correctly.

Pages here carry a Commodities sub-nav, so their portrait charts use a shorter height (`port_h = 6.5`) than single-page pillars.

**Gold/silver**: FRED's own LBMA series are discontinued, and free metals-price APIs turned out to be a minefield — MetalpriceAPI's free tier caps historical backfill at 5 days, gold-api.com's "history" endpoint (despite docs suggesting daily OHLC) only ever returns one max-price-per-calendar-year, and GoldAPI.io's real per-date LBMA history (confirmed back to 1968) charges against a monthly quota far smaller than advertised — a plain 8-year monthly backfill exhausted it in one run. In progress: `commodities_gold.R`/`commodities_silver.R` exist and use a `build_goldapi_chart()` helper (in `_theme.R`) that accumulates one CSV row per date into `data/gold_usd.csv`/`data/silver_usd.csv` rather than re-fetching full history each run, currently set to a shallow quarterly/2-year backfill while the real GoldAPI.io quota gets confirmed — not yet wired into the CI workflow or given HTML pages.
