#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom shinyWidgets useShinydashboard
#' @noRd
app_ui <- function(request) {

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      h1("AuditDataSteward"),
      tabsetPanel(
        tabPanel(
          "Home",
          h3("Summary"),
          mod_value_boxes_ui("home_smry"),
          gt_output("home_summary_table")
        ),
        mod_smry_tab_ui("student_smry", "Student"), # returns a tabPanel
        mod_smry_tab_ui("courses_smry", "Courses"),
        mod_smry_tab_ui("student_courses_smry", "Student Courses"),
        mod_smry_tab_ui("faculty_workload_smry", "Faculty Workload")
      ),
      theme = bslib::bs_theme(bootswatch = "spacelab") # TODO: update theme
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "AuditDataSteward"
    ),
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
    useShinydashboard() # Makes valueBox() available
  )
}
