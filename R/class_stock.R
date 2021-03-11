library(R6)
library(tibble)

stock <- R6::R6Class(

  classname = "stock",
  public = list(

    initialize = function(data) {

      stopifnot(
        tibble::is_tibble(data),
        ncol(data) == 8,
        "symbol" %in% colnames(data),
        length(unique(data$symbol)) == 1
      )

      private$symbol <- unique(data$symbol)
      private$data <- data

    },

    print = function(...) {

      cat("symbol: ", private$symbol, "\n", sep = "")
      cat("values: ", nrow(private$data), "\n", sep = "")
      cat("nas: ", sum(is.na(private$data)), "\n", sep = "")

    }

  ),
  private = list(

    symbol = NULL,
    data = NULL

  )

)


nvda <- stock$new(data = data %>% filter(symbol == stocks[2]))
lha.de <- stock$new(data = data %>% filter(symbol == stocks[1]))

nvda
nvda$print()

lha.de
