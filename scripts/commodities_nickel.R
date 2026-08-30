#!/usr/bin/env Rscript
# Regenerates the nickel price chart for charts.aidanhorn.co.za.
# Data: FRED official API (PNICKUSDM, Global price of Nickel, USD/tonne),
# needs FRED_API_KEY. Monthly.

suppressMessages(library(ggplot2))
suppressMessages(library(httr2))
source("scripts/_theme.R")

out_path <- "assets/commodities/nickel.png"
result <- build_fred_chart("PNICKUSDM", "Nickel (USD/tonne)", "USD/tonne", "#6fbf73",
                            date_format = "%b %Y", window_years = 8)
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest nickel price: $", result$latest$price, "as of", format(result$latest$date, "%b %Y"), "\n")
