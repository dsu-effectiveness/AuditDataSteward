#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  student_result = read_result(data_type = "edify", file = "student"),
  course_result = read_result(data_type = "edify", file = "course"),
  student_course_result = read_result(data_type = "edify", file = "student_course"),
  graduation_result = read_result(data_type = "edify", file = "graduation"),
  building_result = read_result(data_type = "edify", file = "building"),
  room_result = read_result(data_type = "edify", file = "room"),
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(
      student_result = student_result,
      course_result = course_result,
      student_course_result = student_course_result,
      graduation_result = graduation_result,
      building_result = building_result,
      room_result = room_result,
      ...)
  )
}
