## theme_ggplot_cfrna.R
## Standard ggplot2 theme for manuscript figures

theme_cfrna_print <- function() {
  theme_classic(base_size = 10) %+replace%
    theme(
      axis.text       = element_text(size = 8, color = "black"),
      axis.title      = element_text(size = 10),
      plot.title       = element_text(size = 11, face = "bold", hjust = 0.5),
      strip.text       = element_text(size = 9),
      strip.background = element_blank(),
      legend.text      = element_text(size = 8),
      legend.title     = element_text(size = 9),
      panel.grid       = element_blank()
    )
}
