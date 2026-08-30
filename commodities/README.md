# Commodities

| Pillar | Script | Source | Cadence |
|---|---|---|---|
| Oil (Brent crude) | [commodities_oil.R](../scripts/commodities_oil.R) | FRED (DCOILBRENTEU) | Daily |
| Gold | [commodities_gold.R](../scripts/commodities_gold.R) | World Bank Pink Sheet | Monthly |
| Silver | [commodities_silver.R](../scripts/commodities_silver.R) | World Bank Pink Sheet | Monthly |
| Natural Gas (Henry Hub) | [commodities_natgas.R](../scripts/commodities_natgas.R) | FRED (DHHNGSP) | Daily |
| Copper | [commodities_copper.R](../scripts/commodities_copper.R) | FRED (PCOPPUSDM) | Monthly |
| Aluminum | [commodities_aluminum.R](../scripts/commodities_aluminum.R) | FRED (PALUMUSDM) | Monthly |
| Nickel | [commodities_nickel.R](../scripts/commodities_nickel.R) | FRED (PNICKUSDM) | Monthly |
| Zinc | [commodities_zinc.R](../scripts/commodities_zinc.R) | FRED (PZINCUSDM) | Monthly |
| Wheat | [commodities_wheat.R](../scripts/commodities_wheat.R) | FRED (PWHEAMTUSDM) | Monthly |
| Corn | [commodities_corn.R](../scripts/commodities_corn.R) | FRED (PMAIZMTUSDM) | Monthly |
| Soybeans | [commodities_soybeans.R](../scripts/commodities_soybeans.R) | FRED (PSOYBUSDM) | Monthly |
| Coffee (Arabica) | [commodities_coffee.R](../scripts/commodities_coffee.R) | FRED (PCOFFOTMUSDM) | Monthly |
| Sugar (No. 11) | [commodities_sugar.R](../scripts/commodities_sugar.R) | FRED (PSUGAISAUSDM) | Monthly |
| Cocoa | [commodities_cocoa.R](../scripts/commodities_cocoa.R) | FRED (PCOCOUSDM) | Monthly |
| Cotton | [commodities_cotton.R](../scripts/commodities_cotton.R) | FRED (PCOTTINDUSDM) | Monthly |

All via [FRED](https://fred.stlouisfed.org/)'s official API (`api.stlouisfed.org`, needs a free `FRED_API_KEY` repo secret — the undocumented `fredgraph.csv` scrape endpoint was dropped in favour of this), through the shared `build_fred_chart()` helper in [../scripts/_theme.R](../scripts/_theme.R). Copper/Wheat/Corn/Soybeans/Aluminum/Nickel/Zinc/Cocoa are all IMF global commodity prices (USD/tonne) under FRED's `P<CODE>USDM` naming family; Coffee (`PCOFFOTMUSDM`, Other Mild Arabica), Sugar (`PSUGAISAUSDM`, No. 11 World) and Cotton (`PCOTTINDUSDM`) are priced in US cents/lb instead — confirmed via the series metadata, not assumed — so `build_fred_chart()` takes a `value_prefix`/`value_suffix` pair to render those axes/subtitles correctly.

Pages here carry a Commodities sub-nav, so their portrait charts use a shorter height (`port_h = 6.5`) than single-page pillars.

**Gold/silver**: FRED's LBMA series are discontinued, and GoldAPI.io's per-date history burned the free monthly quota on backfill (account-level, not per-key). History now comes from the [World Bank Pink Sheet](https://www.worldbank.org/en/research/commodity-markets) monthly workbook (`CMO-Historical-Data-Monthly.xlsx`, USD/troy oz for both metals). The download URL's hash changes, so `update_pinksheet_precious_csvs()` in [../scripts/_theme.R](../scripts/_theme.R) scrapes the current link from that page and writes `data/gold_usd.csv` / `data/silver_usd.csv`. No API key. The Pink Sheet itself is monthly and typically lags the calendar month by a few days.
