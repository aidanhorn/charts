#!/usr/bin/env Rscript
# Regenerates the copper price chart for charts.aidanhorn.co.za.
# Data: FRED (Global price of Copper, USD/tonne), free CSV, no key. Monthly.

suppressMessages(library(ggplot2))
source("scripts/_theme.R")

out_path <- "assets/commodities/copper.png"

d <- read.csv("https://fred.stlouisfed.org/graph/fredgraph.csv?id=PCOPPUSDM",
              stringsAsFactors = FALSE)
names(d) <- c("date", "price")
d$date <- as.Date(d$date)
d$price <- suppressWarnings(as.numeric(d$price))  # FRED marks missing months as "."
d <- d[!is.na(d$price), ]
d <- tail(d, 12 * 8)  # last ~8 years

latest <- d[nrow(d), ]

p <- ggplot(d, aes(x = date, y = price)) +
  geom_line(colour = "#c77b4a", linewidth = 0.8) +
  scale_y_continuous(labels = function(v) paste0("$", formatC(v, format = "d", big.mark = " "))) +
  labs(
    title = "Copper (USD/tonne)",
    subtitle = sprintf("Latest: $%s on %s", formatC(latest$price, format = "d", big.mark = " "), format(latest$date, "%Y-%m")),
    x = NULL, y = "USD/tonne",
    caption = "Source: FRED (PCOPPUSDM) | charts.aidanhorn.co.za | auto-updated"
  ) +
  theme_dark_chart()

save_variants(p, out_path, land_w = 8, land_h = 4.5, port_w = 5, port_h = 8)

cat("Updated", out_path, "- latest copper price: $", latest$price, "as of", format(latest$date, "%Y-%m"), "\n")
