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
  student_result = dummy_result("student"),
  student_course_result = dummy_result("student_course"),
  course_result = dummy_result("course"),
  building_result = dummy_result("building"),
  room_result = dummy_result("room"),
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
      building_result = building_result,
      room_result = room_result,
      ...)
  )
}
