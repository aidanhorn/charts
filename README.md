# charts

Source for [charts.aidanhorn.co.za](https://charts.aidanhorn.co.za) — a small set of automated, self-updating charts across a few genuinely interesting data domains, each pulling from a real public API on its own schedule via GitHub Actions.

## Layout

One folder per section, each an `index.html` (its default page) plus sibling pages for sections with a sub-nav. See each section's own README for its specific pillars/scripts/sources:

- [crypto/](crypto/README.md) — Bitcoin, Ethereum, Solana, XRP, Litecoin
- [climate/](climate/README.md) — global air quality
- [energy/](energy/README.md) — generation mix by country
- [real-estate/](real-estate/README.md) — global house-price growth
- [commodities/](commodities/README.md) — oil, copper, natural gas, wheat, corn
- [traffic/](traffic/README.md) — deferred, unlinked from nav

Shared styling in `assets/style.css`, shared dark/high-contrast ggplot2 theme + crypto/FRED chart-builder helpers in `scripts/_theme.R`. Every page carries a Google Analytics (gtag.js) tag.

All data sources are free/public — no paid feeds, though FRED and OpenAQ need a (free, registered) API key stored as a repo secret. See `.github/workflows/update-charts.yml` for the scheduling and which secrets each step needs.

Pages with a sub-nav (Crypto, Commodities) use a shorter portrait chart height (`port_h`) than single-page pillars, since the extra sub-nav bar leaves less vertical room on mobile before scrolling would be needed.

## Why this exists

Built as a deliberately separate project, chosen to be orthogonal to Aidan's day job at Codera Analytics — nothing here overlaps with EconData or SA official statistics. FX/currency markets were considered and ruled out entirely for the same reason (Codera already runs its own FX pipeline).
