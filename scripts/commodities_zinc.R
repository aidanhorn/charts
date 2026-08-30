#!/usr/bin/env Rscript
# Regenerates the zinc price chart for charts.aidanhorn.co.za.
# Data: FRED official API (PZINCUSDM, Global price of Zinc, USD/tonne),
# needs FRED_API_KEY. Monthly.

suppressMessages(library(ggplot2))
suppressMessages(library(httr2))
source("scripts/_theme.R")

out_path <- "assets/commodities/zinc.png"
result <- build_fred_chart("PZINCUSDM", "Zinc (USD/tonne)", "USD/tonne", "#6a9cbf",
                            date_format = "%b %Y", tail_n = 12 * 8)
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest zinc price: $", result$latest$price, "as of", format(result$latest$date, "%b %Y"), "\n")
