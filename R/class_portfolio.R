library(R6)

portfolio <- R6::R6Class(
  classname = "portfolio",
  inherit = stock,
  public = list(

    initialize = function(stock) {

      stopifnot(class(stock)[1] == "stock")


    }

  ),
  private = list(

  )
)
