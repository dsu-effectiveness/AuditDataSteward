
#' Takes a user id, returns value boxes
#'
make_metric_row <- function() {
  fluidRow(
    valueBox("valbox1", icon = "fa-comments"),
    valueBox("valbox2"),
    valueBox("valbox3"),
    valueBox("valbox4"),
    valueBox("valbox5")
  )
}



#' Creates summary table for each tab.
#'
#'  This function should take a user id and a perspective as input and should
#'  return a table. These tables should be will be small, so I recommend we use
#'  the gt package. A description of the data points in the table is given in
#'  the home tab section. Each data point should be associated with a
#'  perspective. We may need to manipulate the output of the utValidateR package
#'  to get it.
#'
make_summary_table <- function(user_id, perspective) {
  # Currently just a dummy table
  shinipsum::random_table(nrow = 10, ncol = 5)
}


#' This function will make the error table for each tab. This function should
#' take a user id and a perspective as input and should return a table. These
#' tables will contain all the data errors from utValidateR associated with the
#' perspective and the user. These should be obtainable from the utValidateR
#' functions.
make_error_table <- function() {
  # TODO
  shinipsum::random_DT(nrow = 1000, ncol = 5,
                       filter = "top",
                       rownames = FALSE,
                       options = list(autoWidth = TRUE))
}


