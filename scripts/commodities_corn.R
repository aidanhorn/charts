#!/usr/bin/env Rscript
# Regenerates the corn (maize) price chart for charts.aidanhorn.co.za.
# Data: FRED official API (PMAIZMTUSDM, Global price of Maize, USD/tonne),
# needs FRED_API_KEY. Monthly.

suppressMessages(library(ggplot2))
suppressMessages(library(httr2))
source("scripts/_theme.R")

out_path <- "assets/commodities/corn.png"
result <- build_fred_chart("PMAIZMTUSDM", "Corn (USD/tonne)", "USD/tonne", "#e8c547",
                            date_format = "%b %Y", window_years = 8)
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest corn price: $", result$latest$price, "as of", format(result$latest$date, "%b %Y"), "\n")
