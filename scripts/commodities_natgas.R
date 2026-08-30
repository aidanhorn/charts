#!/usr/bin/env Rscript
# Regenerates the natural gas spot-price chart for charts.aidanhorn.co.za.
# Data: FRED official API (DHHNGSP, Henry Hub Natural Gas Spot Price,
# USD/MMBtu), needs FRED_API_KEY. Daily.

suppressMessages(library(ggplot2))
suppressMessages(library(httr2))
source("scripts/_theme.R")

out_path <- "assets/commodities/natgas.png"
result <- build_fred_chart("DHHNGSP", "Natural Gas (Henry Hub, USD/MMBtu)", "USD/MMBtu", "#5fd0d0",
                            date_format = "%Y-%m-%d", tail_n = 365 * 3, price_digits = 2)
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest natural gas price: $", result$latest$price, "as of", format(result$latest$date, "%Y-%m-%d"), "\n")
