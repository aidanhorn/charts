#!/usr/bin/env Rscript
# Regenerates the gold price chart for charts.aidanhorn.co.za.
# Data: World Bank Pink Sheet monthly USD/troy oz (see update_pinksheet_precious_csvs).

suppressMessages(library(ggplot2))
suppressMessages(library(httr2))
suppressMessages(library(readxl))
source("scripts/_theme.R")

out_path <- "assets/commodities/gold.png"
result <- build_pinksheet_metal_chart("data/gold_usd.csv", "Gold (USD/troy oz)", "#d4af37")
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest gold price: $", result$latest$price, "as of", format(result$latest$date, "%b %Y"), "\n")
