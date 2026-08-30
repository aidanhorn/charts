#!/usr/bin/env Rscript
# Regenerates the copper price chart for charts.aidanhorn.co.za.
# Data: FRED official API (PCOPPUSDM, Global price of Copper, USD/tonne),
# needs FRED_API_KEY. Monthly.

suppressMessages(library(ggplot2))
suppressMessages(library(httr2))
source("scripts/_theme.R")

out_path <- "assets/commodities/copper.png"
result <- build_fred_chart("PCOPPUSDM", "Copper (USD/tonne)", "USD/tonne", "#c77b4a",
                            date_format = "%b %Y", tail_n = 12 * 8)
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest copper price: $", result$latest$price, "as of", format(result$latest$date, "%b %Y"), "\n")
