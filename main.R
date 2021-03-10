################################################################################
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
library(stringr)
library(lubridate)


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
) %>% dplyr::mutate(
  # calculate daily percentage changes
  dplyr::across(
    .cols = (!"date" & !tidyselect::contains("_MOVING_")),
    .fns = ~ (.x / lag(.x, k = 1)) - 1,
    .names = "{.col}_01DPC"
  )
) %>% dplyr::mutate(
  # calculate cumulative returns
  dplyr::across(
    .cols = (!"date" & !tidyselect::contains("_MOVING_") & !tidyselect::contains("DPC")),
    .fns = ~ (.x / .x[1]),
    .names = "{.col}_CUMRET"
  )
)





# pivot opens to long
data_long_open <- data_wide_open %>% tidyr::pivot_longer(
  cols = -date,
  names_to = "variable",
  values_to = "value"
) %>% dplyr::mutate(
  symbol = stringr::str_split(
    variable,
    pattern = "_"
  ) %>% purrr::map_chr(~ .x[1])
)



variables_open <- colnames(data_wide_open) %>% stringr::str_split(
  pattern = "_"
) %>% purrr::map_chr(
  ~ paste(.x[-1], collapse = "_")
)

variables_open[c(1, 2, 3, 4)] <- c("date", rep("open", 3))




data_long_open <- data_long_open %>% dplyr::inner_join(
  tidyr::tibble(
    variable = colnames(data_wide_open),
    new = variables_open
  ),
  by = "variable"
) %>% dplyr::select(
  date,
  symbol,
  variable = new,
  value
)





# plots ------------------------------------------------------------------------
last_year <- Sys.Date() - lubridate::years(1)
annotate
colnames(data)

data %>% dplyr::filter(
  date >= last_year
) %>% ggplot2::ggplot(data = .) +
  ggplot2::geom_line(mapping = ggplot2::aes(x = date, y = open, color = symbol)) +
  ggplot2::theme_minimal()


data %>% dplyr::filter(
  date >= last_year
) %>% ggplot2::ggplot(data = .) +
  ggplot2::geom_line(mapping = ggplot2::aes(x = date, y = open, color = symbol)) +
  #annotate(geom = "text", ) +
  theme_minimal() +
  facet_wrap(~ symbol, scales = "free_y")


data %>% dplyr::filter(
  date >= last_year
) %>% ggplot2::ggplot(data = .) +
  ggplot2::geom_line(mapping = ggplot2::aes(x = date, y = volume, color = symbol)) +
  ggplot2::theme_minimal()

colnames(data_wide_open)

colnames(data_wide_open)[-1]



# plot

data_long_open %>% dplyr::filter(
  symbol == "INTC"
) %>% ggplot2::ggplot() +
  ggplot2::geom_line(
    mapping = ggplot2::aes(
      x = date,
      y = value,
      color = variable
    )
  )



data_wide_open %>% head()

data_wide_open %>% ggplot2::ggplot() +
  ggplot2::geom_point(
    mapping = ggplot2::aes(
      x = LHA.DE,
      y = NVDA
    )
  )

#sum(is.na(data_wide_open$NVDA))

data_wide_open %>% ggplot2::ggplot() +
  ggplot2::geom_histogram(
    mapping = ggplot2::aes(
      x = NVDA
    ),
    binwidth = 50
  )


data_wide_open %>% colnames

data_wide_open %>% select((!"date" & !tidyselect::contains("_MOVING_")))

data_wide_open$LHA.DE %>% lag(k = 1) %>% head
data_wide_open$LHA.DE %>% head


# boxplots
data_long_open %>% ggplot2::ggplot() +
  ggplot2::geom_boxplot(
    ggplot2::aes(
      x = symbol,
      y = value,
      fill = symbol
    )
  ) +
  ggplot2::facet_wrap(
    ~ variable,
    scales = "free_y"
  )
