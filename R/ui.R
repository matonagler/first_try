ui <- shiny::fluidPage(

  shiny::titlePanel("Stockpit"),

  shiny::sidebarPanel(
    "sidebar",
    shiny::conditionalPanel(
      condition = "input.tabs == 'Summary'", "test_sum"
    )
  ),

  shiny::mainPanel(

    shiny::tabsetPanel(

      type = "tabs",
      shiny::tabPanel("Summary"),
      shiny::tabPanel("Details")

    )

  )

)
