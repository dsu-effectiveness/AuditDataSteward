#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  output$home_summary_table <- renderTable(
    make_summary_table(user_id = "TODO", perspective = "TODO")
  )

  mod_value_boxes_server("home_smry", n_errors = 30, avg_age = 23, n_total = 500,
                         pct_errors = 6, n_tables = 14)

  mod_smry_tab_server("student_smry")
  mod_smry_tab_server("courses_smry")
  mod_smry_tab_server("student_courses_smry")
  mod_smry_tab_server("faculty_workload_smry")

}
