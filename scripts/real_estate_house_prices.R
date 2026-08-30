#!/usr/bin/env Rscript
# Regenerates the global real house-price growth chart for charts.aidanhorn.co.za.
# Data: OECD Analytical House Prices Indicators (SDMX REST API, free, no key).

suppressMessages(library(ggplot2))
source("scripts/_theme.R")

out_path <- "assets/real_estate/house_prices.png"

COUNTRIES <- c(USA = "United States", GBR = "United Kingdom", DEU = "Germany",
               JPN = "Japan", AUS = "Australia", CHN = "China")

url <- "https://sdmx.oecd.org/public/rest/data/OECD.ECO.MPD,DSD_AN_HOUSE_PRICES@DF_HOUSE_PRICES,/all?format=csvfilewithlabels&startPeriod=2015-Q1"
raw <- read.csv(url, stringsAsFactors = FALSE, check.names = FALSE)

d <- raw[raw$MEASURE == "RHP" & raw$FREQ == "Q" & raw$REF_AREA %in% names(COUNTRIES), ]
d <- d[, c("REF_AREA", "TIME_PERIOD", "OBS_VALUE")]
names(d) <- c("iso", "period", "index")
d$country <- COUNTRIES[d$iso]

# Parse "YYYY-Qn" into a plottable date, then compute year-on-year % growth per country
q_to_date <- function(p) {
  yr <- as.integer(substr(p, 1, 4))
  q <- as.integer(substr(p, 7, 7))
  as.Date(sprintf("%d-%02d-01", yr, (q - 1) * 3 + 1))
}
d$date <- q_to_date(d$period)
d <- d[order(d$country, d$date), ]

d$yoy_growth <- ave(d$index, d$country, FUN = function(x) x / c(rep(NA, 4), head(x, -4)) * 100 - 100)
d <- d[!is.na(d$yoy_growth), ]

latest_date <- max(d$date, na.rm = TRUE)
latest_quarter <- sprintf("%d Q%d", as.integer(format(latest_date, "%Y")), (as.integer(format(latest_date, "%m")) - 1) %/% 3 + 1)

p <- ggplot(d, aes(x = date, y = yoy_growth)) +
  geom_hline(yintercept = 0, colour = CHART_GRID, linewidth = 0.3) +
  geom_line(colour = "#58a6ff", linewidth = 0.7) +
  facet_wrap(~country, ncol = 3) +
  scale_y_continuous(labels = function(v) paste0(v, "%")) +
  labs(
    title = "Real (CPI-adjusted) house price growth, year-on-year",
    subtitle = sprintf("Latest quarter: %s", latest_quarter),
    x = NULL, y = NULL,
    caption = "Source: OECD Analytical House Prices Indicators | charts.aidanhorn.co.za | auto-updated"
  ) +
  theme_dark_chart() +
  theme(strip.background = element_rect(fill = CHART_PANEL, colour = CHART_GRID),
        strip.text = element_text(colour = CHART_TEXT))

ggsave(out_path, p, width = 10, height = 6, dpi = 150, bg = CHART_BG, create.dir = TRUE)

cat("Updated", out_path, "- countries:", paste(unique(d$country), collapse = ", "), "\n")
