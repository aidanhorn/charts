#!/usr/bin/env Rscript
# Regenerates the cotton price chart for charts.aidanhorn.co.za.
# Data: FRED official API (PCOTTINDUSDM, Global price of Cotton), needs
# FRED_API_KEY. Monthly. Units are US cents per pound (not USD/tonne like
# the other agricultural commodities here) - confirmed via the series
# metadata, not assumed.

suppressMessages(library(ggplot2))
suppressMessages(library(httr2))
source("scripts/_theme.R")

out_path <- "assets/commodities/cotton.png"
result <- build_fred_chart("PCOTTINDUSDM", "Cotton (US cents/lb)", "US cents/lb", "#a8d5e5",
                            date_format = "%b %Y", tail_n = 12 * 8, price_digits = 1,
                            value_prefix = "", value_suffix = "¢")
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest cotton price:", result$latest$price, "cents/lb as of", format(result$latest$date, "%b %Y"), "\n")
