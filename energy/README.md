# Energy

| Pillar | Script | Source | Cadence |
|---|---|---|---|
| Generation mix by country (renewable share, world choropleth) | [energy_generation_mix.R](../scripts/energy_generation_mix.R) | [Our World in Data](https://github.com/owid/energy-data) energy dataset | Monthly |
| Generation mix stacked area (World, China, US, India, EU, Japan, South Africa) | [energy_generation_stacked.R](../scripts/energy_generation_stacked.R) | Same OWID energy-data CSV | Monthly |

The map is the all-country snapshot (`index.html`). Each stacked-area page is one geography: Coal, Gas, Nuclear, Hydro, Wind & solar, and Other (oil + remaining renewables/bioenergy, as the residual after those five shares). Ember's own site blocks programmatic access, so both scripts use OWID's public GitHub CSV (no key).

Country names on the choropleth get a small manual fix-up table (`NAME_FIX`) for mismatches with the `maps` package (e.g. "United States" → "USA"). Stacked pages match OWID names directly, including `European Union (27)`.
