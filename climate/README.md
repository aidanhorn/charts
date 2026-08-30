# Climate

| Pillar | Script | Source | Cadence |
|---|---|---|---|
| Global PM2.5 air quality (grid heatmap) | [climate_air_quality.R](../scripts/climate_air_quality.R) | [OpenAQ](https://openaq.org/) v3 API (needs a free `OPENAQ_API_KEY` repo secret) | Daily |

Deliberately international, not SA-specific (EconData already has its own `WEATHER`/`RAINFALL` dataflows) and not night-lights-based (that's Aidan's own Codera research area, and he's a co-author on a 2026 paper about it).

Station readings are averaged into a 2.5°×2.5° grid rather than plotted as raw points — with ~1,900 stations, individual points overlapped too much to read.

Backlog (researched, not built): NASA GISTEMP (temperature anomaly), NOAA OISST (sea surface temp), NSIDC (sea ice), NASA FIRMS (wildfire detection — confirmed fine despite sharing VIIRS satellite infrastructure with night-lights, since it measures fire heat, not light emissions), USGS (earthquakes).
