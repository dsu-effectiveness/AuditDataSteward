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
#' @importFrom DT DTOutput
#' @importFrom gt gt_output
mod_smry_tab_ui <- function(id, perspective){
  ns <- NS(id)

  tabPanel(
    title = perspective,
    column(width = 8,
      h2(perspective),
      mod_value_boxes_ui(ns("smry_tab")),
      h3(paste0(perspective, " Error Summary")),
      gt_output(ns("summary_table")),

      h3(paste0(perspective, " Errors")),
      DTOutput(ns("error_table")),
      offset = 2,
      br()
    )

  )
}

#' smry_tab Server Functions
#'
#' @param stats_tables result of `get_stats_tables()`
#' @importFrom DT renderDT
#' @importFrom gt render_gt
#' @noRd
mod_smry_tab_server <- function(id, stats_tables) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    mod_value_boxes_server("smry_tab", stats_tables$five_stats)
    output$summary_table <- render_gt(
      format_summary_table(stats_tables$error_summary)
    )
    output$error_table <- renderDT(
      format_error_table(stats_tables$errors),
      server = TRUE
    )
  })
}
