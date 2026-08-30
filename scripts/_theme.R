# Shared dark theme for all chart-hub pillars. Source this from each script:
#   source("scripts/_theme.R")

CHART_BG <- "#0d1117"
CHART_PANEL <- "#161b22"
CHART_GRID <- "#30363d"
CHART_TEXT <- "#ffffff"
CHART_TEXT_DIM <- "#d5dbe2"
CHART_CAPTION_SIZE_PORTRAIT <- 11  # larger than the 8pt landscape default - legible on mobile

theme_dark_chart <- function(base_size = 12) {
  theme_bw(base_size = base_size) %+replace%
    theme(
      plot.margin = margin(t = 16, r = 16, b = 12, l = 12),
      plot.background = element_rect(fill = CHART_BG, colour = NA),
      panel.background = element_rect(fill = CHART_PANEL, colour = NA),
      panel.grid.major = element_line(colour = CHART_GRID, linewidth = 0.3),
      panel.grid.minor = element_blank(),
      panel.border = element_rect(colour = CHART_GRID, fill = NA),
      axis.text = element_text(colour = CHART_TEXT_DIM),
      axis.title = element_text(colour = CHART_TEXT),
      plot.title = element_text(colour = CHART_TEXT, face = "bold", hjust = 0, margin = margin(b = 10)),
      plot.subtitle = element_text(colour = CHART_TEXT_DIM, hjust = 0, margin = margin(b = 14)),
      plot.caption = element_text(colour = CHART_TEXT_DIM, size = 8, margin = margin(t = 14)),
      legend.background = element_rect(fill = CHART_BG, colour = NA),
      legend.key = element_rect(fill = CHART_PANEL, colour = NA),
      legend.text = element_text(colour = CHART_TEXT_DIM),
      legend.title = element_text(colour = CHART_TEXT, margin = margin(b = 10))
    )
}

# Saves a landscape render (the default, desktop) plus a taller/narrower
# "-portrait" sibling (for mobile, picked up via a <picture> media query in
# each page). Use this when the same plot object works at either aspect
# ratio (e.g. coord_fixed() maps just get more surrounding whitespace); for
# layouts that need real structural changes at portrait width (e.g. fewer
# facet columns), build two plot objects and call ggsave() directly instead.
save_variants <- function(plot, path, land_w, land_h, port_w, port_h) {
  ggsave(path, plot, width = land_w, height = land_h, dpi = 150, bg = CHART_BG, create.dir = TRUE)
  portrait_path <- sub("(\\.[a-zA-Z]+)$", "-portrait\\1", path)
  plot_portrait <- plot + theme(plot.caption = element_text(size = CHART_CAPTION_SIZE_PORTRAIT))
  # The larger portrait caption size can overflow a narrow canvas on one line
  # (ggplot2 doesn't auto-wrap it) - break after the first " | " so
  # "Source: X" sits on its own line above "site | auto-updated".
  current_caption <- plot$labels$caption
  if (!is.null(current_caption) && grepl(" \\| ", current_caption)) {
    plot_portrait <- plot_portrait + labs(caption = sub(" \\| ", "\n", current_caption))
  }
  ggsave(portrait_path, plot_portrait, width = port_w, height = port_h, dpi = 150, bg = CHART_BG, create.dir = TRUE)
}

# Fetches daily USD price history for a CoinGecko coin id (free tier caps
# daily-interval history at 365 days) and returns a log-scale price chart,
# styled consistently across all crypto pillars. Requires httr2 to already
# be loaded by the calling script.
build_crypto_chart <- function(coin_id, title_text, colour, price_digits = 0) {
  resp <- httr2::request(sprintf("https://api.coingecko.com/api/v3/coins/%s/market_chart", coin_id)) |>
    httr2::req_url_query(vs_currency = "usd", days = "365", interval = "daily") |>
    httr2::req_perform()

  prices <- httr2::resp_body_json(resp)$prices
  d <- data.frame(
    time = as.POSIXct(sapply(prices, `[[`, 1) / 1000, origin = "1970-01-01", tz = "UTC"),
    price = sapply(prices, `[[`, 2)
  )
  latest <- d[nrow(d), ]

  # price_digits > 0 for sub-$5 coins (e.g. XRP) - whole-dollar formatting
  # would otherwise round the price to something meaningless like "$1".
  fmt_price <- function(v) formatC(v, format = "f", digits = price_digits, big.mark = " ")

  plot <- ggplot(d, aes(x = time, y = price)) +
    geom_line(colour = colour, linewidth = 0.7) +
    scale_y_log10(labels = function(v) paste0("$", fmt_price(v))) +
    labs(
      title = title_text,
      subtitle = sprintf("Latest: $%s on %s", fmt_price(latest$price), format(latest$time, "%Y-%m-%d")),
      x = NULL, y = "Price (log scale)",
      caption = "Source: CoinGecko | charts.aidanhorn.co.za | auto-updated"
    ) +
    theme_dark_chart()

  list(plot = plot, latest = latest)
}

# Fetches a FRED series via the official observations API (needs FRED_API_KEY
# - a repo secret in CI, read from ~/.Renviron locally) and returns a styled
# price chart. Requires httr2 to already be loaded by the calling script.
build_fred_chart <- function(series_id, title_text, y_label, colour,
                              date_format = "%Y-%m-%d", tail_n = NULL, price_digits = 0,
                              value_prefix = "$", value_suffix = "") {
  api_key <- Sys.getenv("FRED_API_KEY")
  if (!nzchar(api_key)) stop("FRED_API_KEY environment variable is not set")

  resp <- httr2::request("https://api.stlouisfed.org/fred/series/observations") |>
    httr2::req_url_query(series_id = series_id, api_key = api_key, file_type = "json") |>
    httr2::req_perform()

  obs <- httr2::resp_body_json(resp)$observations
  d <- data.frame(
    date = as.Date(sapply(obs, `[[`, "date")),
    price = suppressWarnings(as.numeric(sapply(obs, `[[`, "value")))  # FRED marks missing periods as "."
  )
  d <- d[!is.na(d$price), ]
  if (!is.null(tail_n)) d <- tail(d, tail_n)
  latest <- d[nrow(d), ]

  fmt_price <- function(v) formatC(v, format = "f", digits = price_digits, big.mark = " ")

  plot <- ggplot(d, aes(x = date, y = price)) +
    geom_line(colour = colour, linewidth = 0.7) +
    scale_y_continuous(labels = function(v) paste0(value_prefix, fmt_price(v), value_suffix)) +
    labs(
      title = title_text,
      subtitle = sprintf("Latest: %s%s%s on %s", value_prefix, fmt_price(latest$price), value_suffix, format(latest$date, date_format)),
      x = NULL, y = y_label,
      caption = sprintf("Source: FRED (%s) | charts.aidanhorn.co.za | auto-updated", series_id)
    ) +
    theme_dark_chart()

  list(plot = plot, latest = latest)
}

# Gold/silver: FRED's LBMA series are discontinued, and per-date metals APIs
# chew quota on backfill. The World Bank Pink Sheet publishes both metals
# as monthly USD/troy oz in one Excel workbook. The workbook URL's hash
# changes, so we scrape the current "Monthly prices" link from the
# Commodity Markets page, then write data/gold_usd.csv and
# data/silver_usd.csv. Requires httr2 + readxl.
pinksheet_monthly_xlsx_url <- function() {
  html <- httr2::request("https://www.worldbank.org/en/research/commodity-markets") |>
    httr2::req_user_agent("charts.aidanhorn.co.za") |>
    httr2::req_perform() |>
    httr2::resp_body_string()
  url <- regmatches(html, regexpr("https://[^\"' <>]+CMO-Historical-Data-Monthly\\.xlsx", html))
  if (!length(url) || !nzchar(url[1])) {
    stop("Could not find CMO-Historical-Data-Monthly.xlsx on the World Bank Commodity Markets page")
  }
  url[1]
}

update_pinksheet_precious_csvs <- function(gold_path = "data/gold_usd.csv",
                                           silver_path = "data/silver_usd.csv") {
  if (!requireNamespace("readxl", quietly = TRUE)) {
    stop("Package 'readxl' is required to parse the Pink Sheet workbook")
  }
  url <- pinksheet_monthly_xlsx_url()
  cat("Pink Sheet monthly workbook:", url, "\n")
  tmp <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp), add = TRUE)
  httr2::request(url) |>
    httr2::req_user_agent("charts.aidanhorn.co.za") |>
    httr2::req_perform(path = tmp)

  raw <- suppressMessages(
    readxl::read_excel(tmp, sheet = "Monthly Prices", col_names = FALSE, .name_repair = "minimal")
  )
  as_chr <- function(x) trimws(as.character(unlist(x, use.names = FALSE)))
  hdr <- NA_integer_
  for (i in seq_len(min(12L, nrow(raw)))) {
    v <- as_chr(raw[i, ])
    if ("Gold" %in% v && "Silver" %in% v) {
      hdr <- i
      break
    }
  }
  if (is.na(hdr)) stop("Pink Sheet header row with Gold and Silver not found")
  header <- as_chr(raw[hdr, ])
  gold_col <- match("Gold", header)
  silver_col <- match("Silver", header)
  dates <- as_chr(raw[[1]])
  start <- which(grepl("^[0-9]{4}M[0-9]{2}$", dates))[1]
  if (is.na(start)) stop("Pink Sheet date column (YYYYMmm) not found")

  parse_cmo_date <- function(x) as.Date(paste0(substr(x, 1, 4), "-", substr(x, 6, 7), "-01"))
  keep <- start:nrow(raw)
  d_gold <- data.frame(
    date = parse_cmo_date(dates[keep]),
    price = suppressWarnings(as.numeric(as_chr(raw[keep, gold_col])))
  )
  d_silver <- data.frame(
    date = parse_cmo_date(dates[keep]),
    price = suppressWarnings(as.numeric(as_chr(raw[keep, silver_col])))
  )
  d_gold <- d_gold[!is.na(d_gold$date) & !is.na(d_gold$price), ]
  d_silver <- d_silver[!is.na(d_silver$date) & !is.na(d_silver$price), ]
  dir.create("data", recursive = TRUE, showWarnings = FALSE)
  write.csv(d_gold, gold_path, row.names = FALSE)
  write.csv(d_silver, silver_path, row.names = FALSE)
  invisible(list(gold = d_gold, silver = d_silver, url = url))
}

build_pinksheet_metal_chart <- function(csv_path, title_text, colour, tail_n = 12 * 8) {
  update_pinksheet_precious_csvs()
  d <- read.csv(csv_path, stringsAsFactors = FALSE)
  d$date <- as.Date(d$date)
  if (!is.null(tail_n)) d <- tail(d, tail_n)
  latest <- d[nrow(d), ]
  fmt_price <- function(v) formatC(v, format = "f", digits = 0, big.mark = " ")

  plot <- ggplot(d, aes(x = date, y = price)) +
    geom_line(colour = colour, linewidth = 0.7) +
    scale_y_continuous(labels = function(v) paste0("$", fmt_price(v))) +
    labs(
      title = title_text,
      subtitle = sprintf("Latest: $%s on %s", fmt_price(latest$price), format(latest$date, "%b %Y")),
      x = NULL, y = "USD/troy oz",
      caption = "Source: World Bank Pink Sheet | charts.aidanhorn.co.za | auto-updated"
    ) +
    theme_dark_chart()

  list(plot = plot, latest = latest)
}

theme_dark_void <- function(base_size = 12) {
  theme_void(base_size = base_size) %+replace%
    theme(
      plot.margin = margin(t = 26, r = 16, b = 26, l = 16),
      plot.background = element_rect(fill = CHART_BG, colour = NA),
      plot.title = element_text(colour = CHART_TEXT, face = "bold", hjust = 0, margin = margin(b = 10)),
      plot.subtitle = element_text(colour = CHART_TEXT_DIM, hjust = 0, margin = margin(b = 14)),
      plot.caption = element_text(colour = CHART_TEXT_DIM, size = 8, margin = margin(t = 4)),
      legend.background = element_rect(fill = CHART_BG, colour = NA),
      legend.text = element_text(colour = CHART_TEXT_DIM),
      legend.title = element_text(colour = CHART_TEXT, margin = margin(b = 10))
    )
}
