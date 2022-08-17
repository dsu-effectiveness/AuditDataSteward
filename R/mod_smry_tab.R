#' smry_tab UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param perspective Title Case name of the perspective, e.g. "Student Courses"
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom shinydashboard valueBoxOutput valueBox renderValueBox
mod_smry_tab_ui <- function(id, perspective){
  ns <- NS(id)

  tabPanel(title = perspective,
    h2(perspective),
    mod_value_boxes_ui(ns("smry_tab")),
    h3("")
  )
}

#' smry_tab Server Functions
#'
#' @noRd
mod_smry_tab_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    n_errors <- 12
    avg_age <- 27
    n_total <- 330
    pct_errors <- round(n_errors / n_total * 100, digits = 1)
    n_tables <- 8

    mod_value_boxes_server("smry_tab", n_errors, avg_age, n_total, pct_errors, n_tables)
  })
}
