# Shared dark theme for all chart-hub pillars. Source this from each script:
#   source("scripts/_theme.R")

CHART_BG <- "#0d1117"
CHART_PANEL <- "#161b22"
CHART_GRID <- "#30363d"
CHART_TEXT <- "#ffffff"
CHART_TEXT_DIM <- "#d5dbe2"

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

theme_dark_void <- function(base_size = 12) {
  theme_void(base_size = base_size) %+replace%
    theme(
      plot.background = element_rect(fill = CHART_BG, colour = NA),
      plot.title = element_text(colour = CHART_TEXT, face = "bold", hjust = 0, margin = margin(b = 10)),
      plot.subtitle = element_text(colour = CHART_TEXT_DIM, hjust = 0, margin = margin(b = 14)),
      plot.caption = element_text(colour = CHART_TEXT_DIM, size = 8, margin = margin(t = 14)),
      legend.background = element_rect(fill = CHART_BG, colour = NA),
      legend.text = element_text(colour = CHART_TEXT_DIM),
      legend.title = element_text(colour = CHART_TEXT, margin = margin(b = 10))
    )
}
