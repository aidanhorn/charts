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
