#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom shinyWidgets useShinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(# Leave this function for adding external resources
    golem_add_external_resources(),
    shiny::tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "litera_style.css"
      )
    ),
    # Your application UI logic
    fluidPage(
      shiny::navbarPage(
        theme = litera_theme(),
        title = title_logo(),
        windowTitle = "Data Steward Audit Report",
        tabPanel(title = "Home",
          column(
            width = 10,
            h2("Summary"),
            mod_value_boxes_ui("value_boxes_1"),
            gt_output("home_summary_table"),
            offset = 2,
          ),

        ), # End Home Panel
        mod_smry_tab_ui("student_smry", "Student"),
        mod_smry_tab_ui("courses_smry", "Course"),
        mod_smry_tab_ui("student_course_smry", "Student Course"),
        mod_smry_tab_ui("graduation_smry", "Graduation"),
        mod_smry_tab_ui("building_smry", "Building"),
        mod_smry_tab_ui("room_smry", "Room")
        ),
      mainPanel(
          tags$style(
            ".small-box.bg-red { background-color: #940809 !important; }
             .small-box.bg-yellow { background-color: #003962 !important; }
             .small-box.bg-blue { background-color: #8A725A !important; }
             .small-box.bg-green { background-color: #605E33 !important; }
             .small-box.bg-orange { background-color: #AC5C1D !important; }
            "
          ),
      ),
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
