#!/usr/bin/env Rscript
# Regenerates the XRP price chart for charts.aidanhorn.co.za.
# Data: CoinGecko public API (free, no key required). CoinGecko's internal
# coin id for XRP is "ripple".

suppressMessages({
  library(httr2)
  library(jsonlite)
  library(ggplot2)
})
source("scripts/_theme.R")

out_path <- "assets/crypto/xrp.png"
# price_digits=4: XRP trades well under $5, so whole-dollar formatting would
# round it to something meaningless like "$1".
result <- build_crypto_chart("ripple", "XRP (XRP/USD)", "#4a90d9", price_digits = 4)
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest XRP price: $", formatC(result$latest$price, format = "f", digits = 4), "as of", format(result$latest$time, "%Y-%m-%d"), "\n")
