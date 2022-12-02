#' Create title logo
#'
#' Returns UT logo with correct dimensions for app title.
title_logo = function() {
  shiny::div(
    style = "text-align: justify; width:150;",
    shiny::tags$img(
      style = "display: block;
               margin-left:5px;
               margin-top:0px;
               margin-bottom:0px",
      src = "www/ie_logo.png",
      width = "240",
      height = "80",
      alt = "UT Data"
    ),
    shiny::h3("Data Steward Audit Report",
              style = "position: absolute;
                right: 1%;
                top: 10%;
                margin-top: 25px;")
  )
}

#' Create custom litera theme
litera_theme = function() {
  bslib::bs_theme(
    bootswatch = "litera",
    bg = "#FFFFFF", fg = "#000",
    primary = "#B5302A",
    base_font = bslib::font_google("Source Serif Pro"),
    heading_font = bslib::font_google("Josefin Sans", wght = 100)
  )
}
