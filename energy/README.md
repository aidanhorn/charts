# Energy

| Pillar | Script | Source | Cadence |
|---|---|---|---|
| Generation mix by country (renewable share, world choropleth) | [energy_generation_mix.R](../scripts/energy_generation_mix.R) | [Our World in Data](https://github.com/owid/energy-data) energy dataset | Monthly |

Ember's own site (ember-energy.org) blocks programmatic access (bot protection on the download page), so this uses Our World in Data's mirror of much of the same underlying Ember data instead — a plain public CSV on GitHub, no key needed.

Country names get a small manual fix-up table (`NAME_FIX` in the script) for the common mismatches between OWID's naming and the `maps` package's region names (e.g. "United States" → "USA").
