ui <- shiny::fluidPage(

  shiny::titlePanel("Stockpit"),

  shiny::sidebarPanel(
    "sidebar",
    shiny::conditionalPanel(
      condition = "input.tab == 'Summary'", "test_sum",
      radioButtons(
        inputId = "button",
        label = "Knöpfchen",
        choices = c("jo", "no")
      )
    ),
    shiny::conditionalPanel(
      condition = "input.tab == 'Details'", "bäm"
    )
  ),

  shiny::mainPanel(

    shiny::tabsetPanel(
      id = "tab",
      type = "tabs",
      shiny::tabPanel(title = "Summary"),
      shiny::tabPanel(title = "Details")

    )

  )

)
