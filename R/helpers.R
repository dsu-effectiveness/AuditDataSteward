
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


#' Get the results of utValidateR checks
#'
#' Currenlty just loads saved dummy data from dev-data/
load_data_in <- function() {
  check_results <- list(
    student = readRDS("dev-data/student_res.rds"),
    course = readRDS("dev-data/course_res.rds"),
    student_course = readRDS("dev-data/student_course_res.rds")
  )

  data("checklist", package = "utValidateR", envir = environment())

  out <- map(check_results, ~get_stats_tables(., checklist = checklist))

  # Add the summary across all results in check_results
  out$home <- get_stats_tables(check_results, checklist, include_errors = FALSE)

  out
}



#' Extract the table name from a banner field string
#'
#' @param banner_field a string formatted like `"banner.<table>_<field>"`
get_banner_table <- function(banner_field) {
  # presently simple, may need to add checks later
  out <- gsub("^banner\\.", "", gsub("_.+", "", banner_field))
  out
}

#' Pivot result of `do_checks()` into a longer format
#'
#' Returns a tibble with columns row, rule, status, age, table
#'
#' @param check_result result of `do_checks()`
#' @param checklist checklist used by `do_checks()`
pivot_check_result <- function(check_result, checklist) {

  # Only need checklist for banner column--might want to refactor
  bannerdf <- checklist %>%
    mutate(table = get_banner_table(banner)) %>%
    select(rule, table)

  agedf <- check_result %>%
    select(ends_with("_error_age")) %>%
    mutate(row = row_number()) %>%
    pivot_longer(cols = c(-row), names_to = "rule", values_to = "age") %>%
    mutate(rule = gsub("_error_age$", "", rule))

  statusdf <- check_result %>%
    select(ends_with("_status")) %>%
    mutate(row = row_number()) %>%
    pivot_longer(cols = c(-row), names_to = "rule", values_to = "status") %>%
    mutate(rule = gsub("_status$", "", rule))

  out <- statusdf %>%
    left_join(agedf, by = c("row", "rule")) %>%
    left_join(bannerdf, by = "rule")

  out
}

#' Returns a list of tables used by the app: `five_stats`, `error_summary`, and
#' (if `include_errors == TRUE`) `errors`
#'
#' @param check_results a result of `do_checks()` or a list of such results
#' @param checklist the checklist used for check_results (the full checklist from utValidateR is fine)
#' @param include_errors if TRUE (default), include the large tibble enumerating all errors
get_stats_tables <- function(check_results, checklist, include_errors = TRUE) {

  # Accommodate passing in multiple check_results e.g. for home tab, perspective/file mismatch
  if (inherits(check_results, "data.frame"))
    check_results <- list(check_results)
  stopifnot(is.list(check_results))

  # A long tibble with one row per rule and instance checked. We'll summarize
  # before returning to minimize memory footprint but this intermediate object
  # may be large
  statusdf <- map_dfr(check_results, ~pivot_check_result(., checklist))

  # data for DT to display--if desired
  errordf <- NULL # Not sure if I like including an explicitly null element...
  if (include_errors) {
    errordf <- statusdf %>%
      filter(status == "Failure")
  }

  # static table to display
  error_summary <- statusdf %>%
    group_by(table) %>%
    summarize(n_data = n(),
              n_errors = sum(status == "Failure"),
              age = mean(age, na.rm = TRUE) #TODO: should this be across errors only? Could be biased by missingness
    ) %>%
    mutate(pct_errors = n_errors / n_data * 100)

  # 5-stat summary to display
  five_stats <- statusdf %>%
    summarize(n_errors = sum(status == "Failure"),
              avg_age = mean(age, na.rm = TRUE),
              n_data = max(row),
              pct_errors = sum(status == "Failure") / n() * 100,
              n_tables = length(unique(table)))

  out <- list(five_stats = five_stats,
              error_summary = error_summary,
              errors = errordf)
  out
}
