#' value_boxes UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_value_boxes_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      valueBoxOutput(ns("n_errors_valbox")),
      valueBoxOutput(ns("avg_age_valbox")),
      valueBoxOutput(ns("n_total_valbox")),
      valueBoxOutput(ns("pct_errors_valbox")),
      valueBoxOutput(ns("n_tables_valbox"))
    )
  )
}

#' value_boxes Server Functions
#'
#' @noRd
mod_value_boxes_server <- function(id, n_errors, avg_age, n_total, pct_errors, n_tables){

  # Colors for value boxes TODO!
  n_errors_color <- "red"
  avg_age_color <- "aqua"
  n_total_color <- "blue"
  pct_errors_color <- "olive"
  n_tables_color <- "fuchsia"


  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$n_errors_valbox <- renderValueBox(
      valueBox(n_errors,
               subtitle = "N. Errors",
               icon = icon("triangle-exclamation"),
               color = n_errors_color,
               width = 2.4))
    output$avg_age_valbox <- renderValueBox(
      valueBox(value = avg_age,
               subtitle = "Average Age",
               icon = icon("calendar-day"),
               color = avg_age_color,
               width = 2.4))
    output$n_total_valbox <- renderValueBox(
      valueBox(value = n_total,
               subtitle = "Total Rules",
               icon = icon("hashtag"),
               color = n_total_color,
               width = 2.4))
    output$pct_errors_valbox <- renderValueBox(
      valueBox(value = pct_errors,
               subtitle = "Pct. Errors",
               icon = icon("percent"),
               color = pct_errors_color,
               width = 2.4))
    output$n_tables_valbox <- renderValueBox(
      valueBox(value = n_tables,
               subtitle = "N. Tables",
               icon = icon("table-list"),
               color = n_tables_color,
               width = 2.4))
  })
}
