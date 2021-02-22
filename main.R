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
#library(lubridate)



# get stock prices -------------------------------------------------------------
data <- tidyquant::tq_get(
  c("LHA.DE", "NVDA", "INTC"),
  get = "stock.prices"
)


data %>% head
data %>% str


data %>% colnames


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


last_year <- Sys.Date() - lubridate::years(1)



data %>% filter(
  date >= last_year
) %>% ggplot(data = .) +
  geom_line(mapping = aes(x = date, y = close, color = symbol))
