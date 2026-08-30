#!/usr/bin/env Rscript
# Regenerates the global air-quality point-map for charts.aidanhorn.co.za.
# Data: OpenAQ v3 API (free, requires a registered API key - see OPENAQ_API_KEY).

suppressMessages({
  library(httr2)
  library(ggplot2)
  library(maps)
})
source("scripts/_theme.R")

out_path <- "assets/climate/air_quality.png"
api_key <- Sys.getenv("OPENAQ_API_KEY")
if (!nzchar(api_key)) stop("OPENAQ_API_KEY environment variable is not set")

PM25_PARAMETER_ID <- 2

fetch_page <- function(page, limit = 1000) {
  resp <- request(sprintf("https://api.openaq.org/v3/parameters/%d/latest", PM25_PARAMETER_ID)) |>
    req_headers("X-API-Key" = api_key) |>
    req_url_query(limit = limit, page = page) |>
    req_perform()
  httr2::resp_body_json(resp)$results
}

# Two pages (up to 2000 recent readings) - enough for a representative global
# picture without hammering the API or producing an overcrowded map.
results <- c(fetch_page(1), fetch_page(2))

d <- data.frame(
  lon = sapply(results, function(r) r$coordinates$longitude %||% NA),
  lat = sapply(results, function(r) r$coordinates$latitude %||% NA),
  pm25 = sapply(results, function(r) r$value %||% NA)
)
d <- d[!is.na(d$lon) & !is.na(d$lat) & !is.na(d$pm25) & d$pm25 >= 0 & d$pm25 < 500, ]

world <- map_data("world")

p <- ggplot() +
  geom_polygon(data = world, aes(x = long, y = lat, group = group),
               fill = CHART_PANEL, colour = CHART_GRID, linewidth = 0.1) +
  geom_point(data = d, aes(x = lon, y = lat, colour = pm25), size = 1.3, alpha = 0.85) +
  coord_fixed(1.3) +
  scale_colour_gradientn(colours = c("#4a90d9", "#e0b23c", "#d94a4a"),
                          limits = c(0, 150), oob = scales::squish,
                          labels = function(v) paste0(v, " µg/m³")) +
  labs(
    title = "Global air quality: PM2.5, latest readings",
    subtitle = sprintf("%d stations, most recent measurement per sensor", nrow(d)),
    colour = "PM2.5",
    caption = "Source: OpenAQ | charts.aidanhorn.co.za | auto-updated"
  ) +
  theme_dark_void() +
  theme(legend.position = "right")

ggsave(out_path, p, width = 10, height = 5.5, dpi = 150, bg = CHART_BG, create.dir = TRUE)

cat("Updated", out_path, "-", nrow(d), "stations\n")
