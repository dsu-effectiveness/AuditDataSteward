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
      valueBoxOutput(ns("n_errors_valbox"), width = 2),
      valueBoxOutput(ns("avg_age_valbox"), width = 2),
      valueBoxOutput(ns("n_total_valbox"), width = 2),
      valueBoxOutput(ns("pct_errors_valbox"), width = 2),
      valueBoxOutput(ns("n_tables_valbox"), width = 2)
    )
  )
}

#' value_boxes Server Functions
#'
#' @param five_stats tibble, an element of `get_stats_tables()` result
#' @noRd
mod_value_boxes_server <- function(id, five_stats){

  # Colors for value boxes TODO!
  n_errors_color <- "red"
  avg_age_color <- "aqua"
  n_total_color <- "blue"
  pct_errors_color <- "olive"
  n_tables_color <- "fuchsia"


  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$n_errors_valbox <- renderValueBox(
      valueBox(five_stats$n_errors,
               subtitle = "N. Errors",
               icon = icon("triangle-exclamation"),
               color = n_errors_color,
               width = 2))
    output$avg_age_valbox <- renderValueBox(
      valueBox(value = paste(round(five_stats$avg_age), "Days"),
               subtitle = "Average Age",
               icon = icon("calendar-day"),
               color = avg_age_color,
               width = 2))
    output$n_total_valbox <- renderValueBox(
      valueBox(value = five_stats$n_data,
               subtitle = "Total Rules",
               icon = icon("hashtag"),
               color = n_total_color,
               width = 2))
    output$pct_errors_valbox <- renderValueBox(
      valueBox(value = paste0(round(five_stats$pct_errors, digits = 1), "%"),
               subtitle = "Pct. Errors",
               icon = icon("percent"),
               color = pct_errors_color,
               width = 2))
    output$n_tables_valbox <- renderValueBox(
      valueBox(value = five_stats$n_tables,
               subtitle = "N. Tables",
               icon = icon("table-list"),
               color = n_tables_color,
               width = 2))
  })
}
