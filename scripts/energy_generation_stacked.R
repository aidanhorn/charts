#!/usr/bin/env Rscript
# Regenerates per-geography electricity generation-mix stacked area charts.
# Data: Our World in Data energy dataset (same CSV as the choropleth).

suppressMessages(library(ggplot2))
source("scripts/_theme.R")

d <- read.csv("https://raw.githubusercontent.com/owid/energy-data/master/owid-energy-data.csv",
              stringsAsFactors = FALSE)

PLACES <- list(
  list(owid = "World", slug = "world", label = "World"),
  list(owid = "China", slug = "china", label = "China"),
  list(owid = "United States", slug = "usa", label = "United States"),
  list(owid = "India", slug = "india", label = "India"),
  list(owid = "European Union (27)", slug = "eu", label = "European Union"),
  list(owid = "Japan", slug = "japan", label = "Japan"),
  list(owid = "South Africa", slug = "south-africa", label = "South Africa")
)

SOURCES <- c("Coal", "Gas", "Nuclear", "Hydro", "Wind & solar", "Other")
FILL <- c(
  "Coal" = "#6b5e52",
  "Gas" = "#3d9aad",
  "Nuclear" = "#c9a227",
  "Hydro" = "#3d6ea8",
  "Wind & solar" = "#4caf70",
  "Other" = "#9a8f84"
)

na0 <- function(x) {
  x[is.na(x)] <- 0
  x
}

build_mix_plot <- function(place) {
  x <- d[d$country == place$owid, ]
  # Ember mix shares begin ~1985; earlier rows exist but the fuel columns are
  # NA. Treating NA as 0 made "Other" fill 100% back to 1900.
  x <- x[!is.na(x$coal_share_elec) | !is.na(x$hydro_share_elec) | !is.na(x$gas_share_elec), ]
  x$coal <- na0(x$coal_share_elec)
  x$gas <- na0(x$gas_share_elec)
  x$nuclear <- na0(x$nuclear_share_elec)
  x$hydro <- na0(x$hydro_share_elec)
  x$wind_solar <- na0(x$wind_share_elec) + na0(x$solar_share_elec)
  x$other <- pmax(0, 100 - x$coal - x$gas - x$nuclear - x$hydro - x$wind_solar)
  x <- x[order(x$year), ]
  latest_year <- max(x$year)
  xmin <- min(x$year)
  xmax <- latest_year

  long <- rbind(
    data.frame(year = x$year, share = x$coal, source = "Coal"),
    data.frame(year = x$year, share = x$gas, source = "Gas"),
    data.frame(year = x$year, share = x$nuclear, source = "Nuclear"),
    data.frame(year = x$year, share = x$hydro, source = "Hydro"),
    data.frame(year = x$year, share = x$wind_solar, source = "Wind & solar"),
    data.frame(year = x$year, share = x$other, source = "Other")
  )
  long$source <- factor(long$source, levels = SOURCES)

  ggplot(long, aes(x = year, y = share, fill = source)) +
    geom_area(position = "stack", colour = NA) +
    scale_x_continuous(breaks = pretty(c(xmin, xmax), n = 7), limits = c(xmin, xmax), expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0), breaks = seq(0, 100, 25),
                       labels = function(v) paste0(v, "%")) +
    # Don't use scale limits of 0–100: stacked shares can round a hair over
    # 100 and ggplot then drops those rows, leaving vertical gaps.
    coord_cartesian(ylim = c(0, 100), expand = FALSE) +
    scale_fill_manual(values = FILL, breaks = SOURCES) +
    labs(
      title = paste("Electricity generation mix —", place$label),
      subtitle = sprintf("Share of generation | latest year: %d", latest_year),
      x = NULL, y = NULL, fill = NULL,
      caption = "Source: Our World in Data (energy-data) | charts.aidanhorn.co.za | auto-updated"
    ) +
    theme_dark_chart() +
    theme(
      legend.position = "bottom",
      legend.justification = "left",
      plot.title = element_text(margin = margin(b = 10, l = 4)),
      plot.subtitle = element_text(margin = margin(b = 14, l = 4))
    ) +
    guides(fill = guide_legend(nrow = 1, reverse = FALSE))
}

for (place in PLACES) {
  out_path <- sprintf("assets/energy/mix_%s.png", place$slug)
  p <- build_mix_plot(place)
  p_port <- p +
    theme(
      plot.caption = element_text(size = CHART_CAPTION_SIZE_PORTRAIT),
      legend.text = element_text(size = 9)
    ) +
    labs(caption = sub(" \\| ", "\n", p$labels$caption)) +
    guides(fill = guide_legend(nrow = 2, reverse = FALSE))
  ggsave(out_path, p, width = 8, height = 4.5, dpi = 150, bg = CHART_BG, create.dir = TRUE)
  ggsave(sub("(\\.[a-zA-Z]+)$", "-portrait\\1", out_path), p_port,
         width = 5, height = 6.5, dpi = 150, bg = CHART_BG)
  cat("Updated", out_path, "\n")
}
