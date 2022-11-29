
#' Returns a list of lists of tables used by the app. Top level is per UI tab,
#' each element as returned by `get_stats_tables()`
#'
#' @param check_results Results of `utValidateR::do_checks()`, e.g. as returned by `load_data_in()`
#' @importFrom purrr map imap
get_app_data <- function(check_results) {

  checklist <- get_utValidateR_checklist()

  out <- imap(check_results,
              ~withModal(get_stats_tables(.x,
                                          checklist = checklist,
                                          id_cols = get_pivot_id_cols(.y)),
                         paste0("Preparing data: ", .y)))

  # Add the summary across all results in check_results
  out$home <- withModal(get_stats_tables(check_results, checklist, include_errors = FALSE),
                        "Preparing home-tab summary")

  out
}

#' Returns the vector of id columns for the relevant file's error table
#'
#' This will need to be updated in future.
get_pivot_id_cols <- function(file = c("student", "course", "student_course", "graduation", "building", "room")) {
  file <- match.arg(file)

  out <- if (file == "student") c("term_id", "student_id", "first_name", "last_name")
  else if (file == "course") c("term_id", "course_reference_number", "subject_code", "course_number", "section_number")
  else if (file == "student_course") c("term_id", "course_reference_number", "subject_code", "course_number", "sis_student_id")
  else if (file == "graduation") c("term_id", "student_id", "first_name", "last_name")
  else if (file == "building") c("building_abbrv")
  else if (file == "room") c("buildings_id", "room_number")
  else stop("file has no associated id_cols")

  out
}

#' Reads the results of from either dummy data or production data
#' @importFrom here here
read_result <- function(data_type = c("dummy", "edify"), file = c("student", "course", "student_course", "graduation", "building", "room")) {

  file <- match.arg(file)

  if(data_type == "dummy") {
  path <- here::here("inst", "dev-data", paste0(file, "_res.rds"))
  }
  else {
  path <- here::here("sensitive", paste0(file, "_res.rds"))
  }
  out <- readRDS(path)
  out
}



#' Pull in the results of utValidateR checks
#'
#' Currently just loads saved dummy data from dev-data/
load_data_in <- function(session = shiny::getDefaultReactiveDomain()) {

  studentdf <- withModal(read_result(data_type = "edify", file = "student"),
                         "Loading Student Data", session)
  coursedf <- withModal(read_result(data_type = "edify", file = "course"),
                        "Loading Course Data", session)
  student_coursedf <- withModal(read_result(data_type = "edify", file = "student_course"),
                                "Loading Student-Course Data", session)
  graduationdf <- withModal(read_result(data_type = "edify", file = "graduation"),
                            "Loading Graduation Data", session)
  buildingdf <- withModal(read_result(data_type = "edify", file = "building"),
                          "Loading Building Data", session)
  roomdf <- withModal(read_result(data_type = "edify", file = "room"),
                      "Loading Room Data", session)

  check_results <- list(
    student = studentdf,
    course = coursedf,
    student_course = student_coursedf,
    graduation = graduationdf,
    building = buildingdf,
    room = roomdf
  )
}

#' Retrieves the checklist data object from the utValidateR package
#'
#' Assumes that the currently installed version of utValidateR was used to
#' generate the check_results object
#' @importFrom utils data
get_utValidateR_checklist <- function() {
  data("checklist", package = "utValidateR", envir = environment())
  checklist
}


#' Compute dataframes used in shiny app displays
#'
#' Returns a list of tables used by the app: `five_stats`, `error_summary`, and
#' (if `include_errors == TRUE`) `errors`
#'
#' @param check_results a result of `do_checks()` or a list of such results
#' @param checklist the checklist used for check_results (the full checklist from utValidateR is fine)
#' @param id_cols columns to keep for displaying in error datatable, from `get_pivot_id_cols()`
#' @param include_errors if TRUE (default), include the large tibble enumerating all errors.
#'  This is used for all tabs except home tab.
#'
#' @importFrom purrr map_dfr
#' @importFrom dplyr group_by summarize n ungroup filter arrange
get_stats_tables <- function(check_results,
                             checklist,
                             id_cols = character(0),
                             include_errors = TRUE) {
  # Accommodate passing in multiple check_results e.g. for home tab, perspective/file mismatch
  if (inherits(check_results, "data.frame"))
    check_results <- list(check_results)
  stopifnot(is.list(check_results))

  # A long tibble with one row per rule and instance checked. We'll summarize
  # before returning to minimize memory footprint but this intermediate object
  # may be large
  statusdf <- check_results %>%
    map_dfr(~pivot_check_result(., checklist, id_cols = id_cols), .id = "file")

  # static table to display
  error_summary <- statusdf %>%
    group_by(table) %>%
    summarize(n_data = n(),
              n_errors = sum(status == "Failure"),
              age = mean(age, na.rm = TRUE) #TODO: should this be across errors only? Could be biased by missingness
    ) %>%
    mutate(pct_errors = n_errors / n_data * 100) %>%
    arrange(desc(n_errors))

  # by-rule summary for drill-down
  errors_byrule <- statusdf %>%
    group_by(table, rule, description) %>%
    summarize(n_data = n(),
              n_errors = sum(status == "Failure"),
              age = round(mean(age, na.rm = TRUE), digits = 2) #TODO: should this be across errors only? Could be biased by missingness
    ) %>%
    ungroup() %>%
    mutate(pct_errors = round(n_errors / n_data * 100, digits = 2)) %>%
    arrange(desc(n_errors))

  # 5-stat summary to display
  five_stats <- statusdf %>%
    summarize(n_errors = sum(status == "Failure"),
              avg_age = round(mean(age, na.rm = TRUE), digits = 2),
              n_data = max(row),
              pct_errors = round(sum(status == "Failure") / n() * 100, digits = 2),
              n_tables = length(unique(table)))

  out <- list(five_stats = five_stats,
              error_summary = error_summary,
              errors_byrule = errors_byrule)

  # data for DT to display--if desired
  if (include_errors) {
    out$errors <- statusdf[statusdf$status == "Failure", ]

    #dataframe with data values (not _stats, etc), for displaying in error table
    out$values <- check_results %>%
      map_dfr(~get_data_values(.), .id = "file") %>%
      dplyr::filter(paste0(.data$file, .data$row) %in% paste0(out$errors$file, out$errors$row))
  }

  out
}

#' Returns a dataframe containing only columns of check_result_df that are data values (not status, etc)
get_data_values <- function(check_result_df) {
  out <- check_result_df %>%
    select(!ends_with(c("_status", "_error_age", "_activity_date"))) %>%
    mutate(row = 1:nrow(.))
  out
}

#' Returns vector of variables referenced in the specified rule
get_rule_variables <- function(rule, checklist = utValidateR::get_checklist()) {
  rule_in = rule
  checklist_row <- checklist %>%
    filter(rule == rule_in)
  stopifnot(nrow(checklist_row) == 1)
  rule_expr <- checklist_row$checker[[1]]
  rule_vars <- all.vars(rule_expr)
  rule_vars
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
#' <-
#' @param check_result result of `do_checks()`
#' @param checklist checklist used by `do_checks()`
#' @param id_cols columns to keep for pivot_longer()
#' @importFrom dplyr select mutate left_join row_number ends_with
#' @importFrom tidyr pivot_longer
pivot_check_result <- function(check_result, checklist, id_cols) {

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
    select(c(any_of(id_cols), ends_with("_status"))) %>%
    mutate(row = row_number()) %>%
    pivot_longer(cols = !c(row, any_of(id_cols)), names_to = "rule", values_to = "status") %>%
    mutate(rule = gsub("_status$", "", rule))

  ruledf <- utValidateR::checklist %>%
    select(description, rule)

  out <- statusdf %>%
    left_join(agedf, by = c("row", "rule")) %>%
    left_join(bannerdf, by = "rule") %>%
    left_join(ruledf, by = "rule")

  out
}
