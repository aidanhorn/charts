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
  pm25 = sapply(results, function(r) r$value %||% NA),
  datetime = sapply(results, function(r) r$datetime$utc %||% NA)
)
d <- d[!is.na(d$lon) & !is.na(d$lat) & !is.na(d$pm25) & d$pm25 >= 0 & d$pm25 < 500, ]
latest_reading <- max(as.POSIXct(d$datetime, format = "%Y-%m-%dT%H:%M:%S", tz = "UTC"), na.rm = TRUE)
# This pipeline itself only runs once a day (see update-charts.yml), which is
# the binding constraint on displayable precision - not the underlying
# sensors' own (hourly) reporting granularity. Floor to the day.
latest_reading <- as.Date(latest_reading)

# Bin into a coarse lat/lon grid and average PM2.5 per cell, rather than
# plotting 1900+ individual overlapping points.
GRID_DEG <- 2.5
d$lon_bin <- floor(d$lon / GRID_DEG) * GRID_DEG + GRID_DEG / 2
d$lat_bin <- floor(d$lat / GRID_DEG) * GRID_DEG + GRID_DEG / 2
grid <- aggregate(pm25 ~ lon_bin + lat_bin, data = d, FUN = mean)

world <- map_data("world")

p <- ggplot() +
  geom_polygon(data = world, aes(x = long, y = lat, group = group),
               fill = CHART_PANEL, colour = CHART_GRID, linewidth = 0.1) +
  geom_tile(data = grid, aes(x = lon_bin, y = lat_bin, fill = pm25),
            width = GRID_DEG, height = GRID_DEG, alpha = 0.9) +
  coord_fixed(1.3) +
  scale_fill_gradientn(colours = c("#4a90d9", "#e0b23c", "#d94a4a"),
                        limits = c(0, 150), oob = scales::squish,
                        labels = function(v) paste0(v, " µg/m³")) +
  labs(
    title = "Global air quality: PM2.5, latest readings",
    subtitle = sprintf("%d stations, averaged into a %.1f°×%.1f° grid | most recent reading: %s",
                        nrow(d), GRID_DEG, GRID_DEG, format(latest_reading, "%Y-%m-%d")),
    fill = "PM2.5",
    caption = "Source: OpenAQ | charts.aidanhorn.co.za | auto-updated"
  ) +
  theme_dark_void() +
  theme(legend.position = "right")

ggsave(out_path, p, width = 10, height = 5.5, dpi = 150, bg = CHART_BG, create.dir = TRUE)

# Portrait: same treatment as the energy chart - bottom legend, title above
# the bar, bar widened so labels don't overlap, canvas sized close to what
# the content needs rather than leaving coord_fixed() centre it in a lot of
# empty space. Subtitle is also explicitly wrapped onto two shorter lines -
# ggplot2 doesn't auto-wrap plot subtitles, so the single-line landscape
# version would otherwise run off the edge of a narrower canvas.
p_portrait <- p +
  labs(subtitle = sprintf("%d stations, %.1f°×%.1f° grid\nMost recent reading: %s",
                           nrow(d), GRID_DEG, GRID_DEG, format(latest_reading, "%Y-%m-%d"))) +
  theme(legend.position = "bottom",
        plot.margin = margin(t = 20, r = 2, b = 16, l = 2),
        # Panel (map) stays flush with the plot.margin above, but title/
        # subtitle get their own left padding via the text element's own
        # margin, independent of the panel's width.
        plot.title = element_text(margin = margin(b = 10, l = 16)),
        plot.subtitle = element_text(lineheight = 1.4, margin = margin(b = 14, l = 16)),
        plot.caption = element_text(size = CHART_CAPTION_SIZE_PORTRAIT, margin = margin(t = 18))) +
  guides(fill = guide_colorbar(title.position = "top", barwidth = unit(3.2, "in"), barheight = unit(0.3, "in")))
ggsave(sub("(\\.[a-zA-Z]+)$", "-portrait\\1", out_path), p_portrait,
       width = 6, height = 7.6, dpi = 150, bg = CHART_BG, create.dir = TRUE)

cat("Updated", out_path, "-", nrow(d), "stations\n")
