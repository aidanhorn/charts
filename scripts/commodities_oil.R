#!/usr/bin/env Rscript
# Regenerates the Brent crude oil spot-price chart for charts.aidanhorn.co.za.
# Data: FRED official API (DCOILBRENTEU), needs FRED_API_KEY.

suppressMessages(library(ggplot2))
suppressMessages(library(httr2))
source("scripts/_theme.R")

out_path <- "assets/commodities/oil_brent.png"
result <- build_fred_chart("DCOILBRENTEU", "Brent Crude Oil (USD/barrel)", "USD/barrel", "#e0b23c",
                            date_format = "%Y-%m-%d", tail_n = 365 * 3)

# Shorter portrait height (6.5, not 8) - this page carries a Commodities
# sub-nav bar, leaving less vertical room before scrolling would be needed.
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest Brent price: $", result$latest$price, "as of", format(result$latest$date, "%Y-%m-%d"), "\n")
