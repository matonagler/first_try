################################################################################
#
#
#
#
#
#
################################################################################


# load libraries ---------------------------------------------------------------
library(tidyquant)
library(dplyr)
library(tidyr)
library(ggplot2)
library(zoo)
library(purrr)
#library(lubridate)


# params -----------------------------------------------------------------------
rolling_window_widths_d <- c(7, 20, 50, 200)


# get stock prices -------------------------------------------------------------
data <- tidyquant::tq_get(
  c("LHA.DE", "NVDA", "INTC"),
  get = "stock.prices"
)



data %>% dplyr::count(symbol)

data_summary <- data %>% dplyr::group_by(
  symbol
) %>% dplyr::summarize(
  count = dplyr::n(),
  min_date = min(date),
  max_date = max(date),
  min_close = min(close),
  max_close = max(close),
  avg_close = mean(close),
  sd_close = stats::sd(close),
  med_close = stats::median(close),
  p05 = stats::quantile(close, probs = .05),
  p25 = stats::quantile(close, probs = .25),
  p75 = stats::quantile(close, probs = .75),
  p95 = stats::quantile(close, probs = .95)
)

View(data_summary)

#calc_date <- Sys.Date()
#rm(calc_date)

#strftime(Sys.Date(), format = "%Y%m%d")




sum(is.na(data))



data %>% head()


data_wide_open <- data %>% tidyr::pivot_wider(
  id_cols = date,
  names_from = symbol,
  values_from = open,
  values_fill = NA
) %>% dplyr::arrange(date)



# rollingmeans <- seq_along(rolling_window_widths_d) %>% purrr::map_dfc(
#   ~ {
#     moving_avgs <- data_wide_open %>% dplyr::select(-date) %>% zoo::rollapply(
#       data = .,
#       width = rolling_window_widths_d[.x],
#       FUN = mean,
#       na.rm = TRUE,
#       align = "right",
#       by.column = TRUE,
#       fill = NA
#     ) %>% tibble::as_tibble()
#
#     colnames(moving_avgs) <- paste0(
#       colnames(data_wide_open %>% dplyr::select(-date)),
#       "_MOVING_AVG_OPEN_",
#       rolling_window_widths_d[.x],
#       "_D"
#     )
#
#     moving_avgs
#   }
# )

# calculate moving averages
data_wide_open <- data_wide_open %>% bind_cols(
  #rollingmeans
  seq_along(rolling_window_widths_d) %>% purrr::map_dfc(
    ~ {
      moving_avgs <- data_wide_open %>% dplyr::select(-date) %>% zoo::rollapply(
        data = .,
        width = rolling_window_widths_d[.x],
        FUN = mean,
        na.rm = TRUE,
        align = "right",
        by.column = TRUE,
        fill = NA
      ) %>% tibble::as_tibble()

      colnames(moving_avgs) <- paste0(
        colnames(data_wide_open %>% dplyr::select(-date)),
        "_MOVING_AVG_OPEN_",
        rolling_window_widths_d[.x],
        "_D"
      )

      moving_avgs
    }
  )
)





# plots ------------------------------------------------------------------------
last_year <- Sys.Date() - lubridate::years(1)
annotate
colnames(data)

data %>% filter(
  date >= last_year
) %>% ggplot(data = .) +
  geom_line(mapping = aes(x = date, y = open, color = symbol)) +
  theme_minimal()


data %>% filter(
  date >= last_year
) %>% ggplot(data = .) +
  geom_line(mapping = aes(x = date, y = open, color = symbol)) +
  #annotate(geom = "text", ) +
  theme_minimal() +
  facet_wrap(~ symbol, scales = "free_y")


data %>% filter(
  date >= last_year
) %>% ggplot(data = .) +
  geom_line(mapping = aes(x = date, y = volume, color = symbol)) +
  theme_minimal()
