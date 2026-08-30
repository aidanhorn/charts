#!/usr/bin/env Rscript
# Regenerates the Ethereum price chart for charts.aidanhorn.co.za.
# Data: CoinGecko public API (free, no key required).

suppressMessages({
  library(httr2)
  library(jsonlite)
  library(ggplot2)
})
source("scripts/_theme.R")

out_path <- "assets/crypto/eth.png"
result <- build_crypto_chart("ethereum", "Ethereum (ETH/USD)", "#627eea")
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest ETH price: $", formatC(result$latest$price, format = "d", big.mark = " "), "as of", format(result$latest$time, "%Y-%m-%d"), "\n")
