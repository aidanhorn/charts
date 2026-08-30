#!/usr/bin/env Rscript
# Regenerates the Solana price chart for charts.aidanhorn.co.za.
# Data: CoinGecko public API (free, no key required).

suppressMessages({
  library(httr2)
  library(jsonlite)
  library(ggplot2)
})
source("scripts/_theme.R")

out_path <- "assets/crypto/sol.png"
result <- build_crypto_chart("solana", "Solana (SOL/USD)", "#14f195")
save_variants(result$plot, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest SOL price: $", formatC(result$latest$price, format = "d", big.mark = " "), "as of", format(result$latest$time, "%Y-%m-%d"), "\n")
