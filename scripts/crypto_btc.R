#!/usr/bin/env Rscript
# Regenerates the BTC price chart (log y-axis) for charts.aidanhorn.co.za.
# Data: CoinGecko public API (free, no key required).

suppressMessages({
  library(httr2)
  library(jsonlite)
  library(ggplot2)
})

out_path <- "assets/crypto/btc.png"

resp <- request("https://api.coingecko.com/api/v3/coins/bitcoin/market_chart") |>
  req_url_query(vs_currency = "usd", days = "365", interval = "daily") |>  # free tier caps daily-interval history at 365 days
  req_perform()

prices <- resp_body_json(resp)$prices
d <- data.frame(
  time = as.POSIXct(sapply(prices, `[[`, 1) / 1000, origin = "1970-01-01", tz = "UTC"),
  price = sapply(prices, `[[`, 2)
)

latest <- d[nrow(d), ]

p <- ggplot(d, aes(x = time, y = price)) +
  geom_line(colour = "#f2a900", linewidth = 0.7) +
  scale_y_log10(labels = function(v) paste0("$", formatC(v, format = "d", big.mark = ","))) +
  labs(
    title = "Bitcoin (BTC/USD)",
    subtitle = sprintf("Latest: $%s on %s", formatC(latest$price, format = "d", big.mark = ","), format(latest$time, "%Y-%m-%d")),
    x = NULL, y = "Price (log scale)",
    caption = "Source: CoinGecko | charts.aidanhorn.co.za | auto-updated"
  ) +
  theme_bw(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold"),
    plot.caption = element_text(colour = "grey50", size = 8)
  )

ggsave(out_path, p, width = 8, height = 4.5, dpi = 150, bg = "white")

cat("Updated", out_path, "- latest BTC price: $", formatC(latest$price, format = "d", big.mark = ","), "as of", format(latest$time, "%Y-%m-%d"), "\n")
