#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom golem get_golem_options
#' @noRd
app_server <- function(input, output, session) {

  result_list <- list(
    student = get_golem_options("student_result"),
    course = get_golem_options("course_result"),
    student_course = get_golem_options("student_course_result"),
    graduation = get_golem_options("graduation_result"),
    building = get_golem_options("building_result"),
    room = get_golem_options("room_result")
  )

  app_data <- get_app_data(result_list)

  # Home Tab
  mod_value_boxes_server("value_boxes_1", app_data$home$five_stats)
  output$home_summary_table <- render_gt(
    format_summary_table(app_data$home$error_summary)
  )

  # Summary Tab
  mod_smry_tab_server("student_smry", app_data$student, file = "student")
  mod_smry_tab_server("courses_smry", app_data$course, file = "course")
  mod_smry_tab_server("student_course_smry", app_data$student_course, file = "student_course")
  mod_smry_tab_server("graduation_smry", app_data$graduation, file = "graduation")
  mod_smry_tab_server("building_smry", app_data$building, file = "building")
  mod_smry_tab_server("room_smry", app_data$room, file = "room")
}
