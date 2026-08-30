#!/usr/bin/env Rscript
# Regenerates the electricity generation-mix world choropleth for
# charts.aidanhorn.co.za. Data: Our World in Data's energy dataset (free,
# public CSV, mirrors much of Ember's underlying data), updated annually.

suppressMessages({
  library(ggplot2)
  library(maps)
})
source("scripts/_theme.R")

out_path <- "assets/energy/generation_mix.png"

# OWID country names -> maps package region names, for the common mismatches
# (confirmed by diffing OWID's country list against map_data("world")$region).
NAME_FIX <- c(
  "United States" = "USA",
  "United Kingdom" = "UK",
  "Congo" = "Republic of Congo",
  "Democratic Republic of Congo" = "Democratic Republic of the Congo",
  "Cote d'Ivoire" = "Ivory Coast",
  "Czechia" = "Czech Republic",
  "East Timor" = "Timor-Leste",
  "Trinidad and Tobago" = "Trinidad",
  "Antigua and Barbuda" = "Antigua",
  "Saint Kitts and Nevis" = "Saint Kitts",
  "Saint Vincent and the Grenadines" = "Saint Vincent"
)

d <- read.csv("https://raw.githubusercontent.com/owid/energy-data/master/owid-energy-data.csv",
              stringsAsFactors = FALSE)

# Latest year with renewables_share_elec populated, per country
d <- d[!is.na(d$renewables_share_elec) & !is.na(d$iso_code) & nchar(d$iso_code) == 3, ]
latest_year <- max(d$year[d$year <= as.integer(format(Sys.Date(), "%Y"))])
d <- d[d$year == latest_year, c("country", "renewables_share_elec")]
d$country <- ifelse(d$country %in% names(NAME_FIX), NAME_FIX[d$country], d$country)

world <- map_data("world")
world_map <- merge(world, d, by.x = "region", by.y = "country", all.x = TRUE)
world_map <- world_map[order(world_map$order), ]

p <- ggplot(world_map, aes(x = long, y = lat, group = group, fill = renewables_share_elec)) +
  geom_polygon(colour = CHART_GRID, linewidth = 0.1) +
  coord_fixed(1.3) +
  scale_fill_gradient(low = "#243b26", high = "#5fd068", na.value = CHART_PANEL, labels = function(v) paste0(v, "%")) +
  labs(
    title = "Renewable share of electricity generation, by country",
    subtitle = sprintf("Latest year available: %d", latest_year),
    fill = "Renewables\nshare (%)",
    caption = "Source: Our World in Data (energy-data) | charts.aidanhorn.co.za | auto-updated"
  ) +
  theme_dark_void() +
  theme(legend.position = "right")

ggsave(out_path, p, width = 10, height = 5.5, dpi = 150, bg = CHART_BG, create.dir = TRUE)

cat("Updated", out_path, "- latest year:", latest_year, "\n")
