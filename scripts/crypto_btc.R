#!/usr/bin/env Rscript
# Regenerates the Bitcoin price chart for charts.aidanhorn.co.za.
# Data: CoinGecko public API (free, no key required).

suppressMessages({
  library(httr2)
  library(jsonlite)
  library(ggplot2)
})
source("scripts/_theme.R")

out_path <- "assets/crypto/btc.png"
result <- build_crypto_chart("bitcoin", "Bitcoin (BTC/USD)", "#f2a900")

# Shorter portrait height (6.5, not 8) - this page carries a Crypto sub-nav
# bar, leaving less vertical room before scrolling would be needed.
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest BTC price: $", formatC(result$latest$price, format = "d", big.mark = " "), "as of", format(result$latest$time, "%Y-%m-%d"), "\n")
