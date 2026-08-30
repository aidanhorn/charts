#!/usr/bin/env Rscript
# Regenerates the Litecoin price chart for charts.aidanhorn.co.za.
# Data: CoinGecko public API (free, no key required).

suppressMessages({
  library(httr2)
  library(jsonlite)
  library(ggplot2)
})
source("scripts/_theme.R")

out_path <- "assets/crypto/ltc.png"
result <- build_crypto_chart("litecoin", "Litecoin (LTC/USD)", "#b0b3b8")
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest LTC price: $", formatC(result$latest$price, format = "d", big.mark = " "), "as of", format(result$latest$time, "%Y-%m-%d"), "\n")
