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
      h1("Data Steward Audit Report"),
      tabsetPanel(
        tabPanel("Home",
        column(width = 8,
               h3("Summary"),
               mod_value_boxes_ui("value_boxes_1"),
               gt_output("home_summary_table"),
               offset = 2
               )
      ),
      mod_smry_tab_ui("student_smry", "Student"), # returns a tabPanel
      mod_smry_tab_ui("courses_smry", "Course"),
      mod_smry_tab_ui("student_course_smry", "Student Courses"),
      mod_smry_tab_ui("graduation_smry", "Graduation"),
      mod_smry_tab_ui("building_smry", "Buildings"),
      mod_smry_tab_ui("room_smry", "Rooms")
      ),
      theme = bslib::bs_theme(bootswatch = "spacelab")
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
      app_title = "DataStewardAuditReport"
    ),
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
    useShinydashboard() # Makes valueBox() available
  )
}
