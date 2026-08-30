#!/usr/bin/env Rscript
# Regenerates the soybeans price chart for charts.aidanhorn.co.za.
# Data: FRED official API (PSOYBUSDM, Global price of Soybeans, USD/tonne),
# needs FRED_API_KEY. Monthly.

suppressMessages(library(ggplot2))
suppressMessages(library(httr2))
source("scripts/_theme.R")

out_path <- "assets/commodities/soybeans.png"
result <- build_fred_chart("PSOYBUSDM", "Soybeans (USD/tonne)", "USD/tonne", "#c9a961",
                            date_format = "%b %Y", tail_n = 12 * 8)
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest soybeans price: $", result$latest$price, "as of", format(result$latest$date, "%b %Y"), "\n")
