#!/usr/bin/env Rscript
# Regenerates the Brent crude oil spot-price chart for charts.aidanhorn.co.za.
# Data: FRED (Federal Reserve Economic Data) free CSV download, no key required.

suppressMessages(library(ggplot2))
source("scripts/_theme.R")

out_path <- "assets/commodities/oil_brent.png"

d <- read.csv("https://fred.stlouisfed.org/graph/fredgraph.csv?id=DCOILBRENTEU",
              stringsAsFactors = FALSE)
names(d) <- c("date", "price")
d$date <- as.Date(d$date)
d$price <- suppressWarnings(as.numeric(d$price))  # FRED marks missing days as "."
d <- d[!is.na(d$price), ]
d <- tail(d, 365 * 3)  # last ~3 years, keeps the chart readable

latest <- d[nrow(d), ]

p <- ggplot(d, aes(x = date, y = price)) +
  geom_line(colour = "#e0b23c", linewidth = 0.6) +
  labs(
    title = "Brent Crude Oil (USD/barrel)",
    subtitle = sprintf("Latest: $%.2f on %s", latest$price, format(latest$date, "%Y-%m-%d")),
    x = NULL, y = "USD/barrel",
    caption = "Source: FRED (DCOILBRENTEU) | charts.aidanhorn.co.za | auto-updated"
  ) +
  theme_dark_chart()

# Shorter than other portrait charts (port_h=8 elsewhere) - this page has an
# extra sub-nav bar above it (Oil/Copper), so less vertical space is
# available before scrolling would be needed.
save_variants(p, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 6.5)

cat("Updated", out_path, "- latest Brent price: $", latest$price, "as of", format(latest$date, "%Y-%m-%d"), "\n")
