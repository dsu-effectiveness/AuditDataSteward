#' smry_tab UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_smry_tab_ui <- function(id){
  ns <- NS(id)
  tagList(
    make_metric_row(),
    p("TODO"),
    valueBox("valbox3", icon = "fa-comments")
  )
}

#' smry_tab Server Functions
#'
#' @noRd
mod_smry_tab_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_smry_tab_ui("smry_tab_1")

## To be copied in the server
# mod_smry_tab_server("smry_tab_1")
