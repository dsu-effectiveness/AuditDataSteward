
#' Show a modal notification when evaluating an expression
#'
#' @param message Message to be displayed
#' @param session	The session object passed to function given to shinyServer.
#' @export
withModal <- function(expr, message, session = shiny::getDefaultReactiveDomain()) {
  md <- modalDialog(title = "Loading", p(message), easyClose = FALSE,
                    fade = FALSE, footer = NULL)
  message(message)
  has_session <- !is.null(session)

  if (has_session) showModal(md, session = session)
  out <- eval(expr)
  if (has_session) removeModal(session = session)

  out
}

#' Produces a gt object for displaying the summary table (in summary and home tabs)
#'
#' @param summary_table dataframe, as returned in `error_summary` component of
#' `get_stats_tables()` output
#'
#' @importFrom gt gt fmt_percent fmt_integer cols_label sub_missing
#' @export
format_summary_table <- function(summary_table) {
  out <- summary_table %>%
    gt() %>%
    # tab_header()
    fmt_percent(columns = pct_errors, decimals = 1, scale_values = FALSE) %>%
    fmt_integer(columns = c(n_data, n_errors, age)) %>%
    sub_missing(columns = c(age)) %>%
    cols_label(
      table = "Table",
      n_data = "Total Data Points",
      n_errors = "Errors",
      pct_errors = "Percent",
      age = "Age"
    )
}


#' Returns a DT::datatable object for displaying
#'
#' @param error_table dataframe as returned in `errors` component of `get_stats_tables()`
#' @importFrom dplyr select
#' @export
format_error_table <- function(error_table, value_table, rule = NULL,
                               file = c("student", "course", "student_course", "building")) {
  file <- match.arg(file)
  rule_in <- rule
  all_rules <- unique(error_table$rule)
  if (length(rule_in) > 0) {

    join_vars <- c("row", "file")
    off_limits_vars <- setdiff(names(error_table), join_vars) # don't want to display these twice!

    valuedf_tojoin <- get_rule_info(value_table, rule = rule_in, id_vars = join_vars) %>%
      select(!any_of(off_limits_vars))

    error_table <- dplyr::filter(error_table, rule %in% rule_in) %>%
      left_join(valuedf_tojoin, by = join_vars)

  }

  out <- error_table %>%
    select(-row) %>%
    rename(Table = table, Rule = rule, `Age (days)` = age) %>%
    DT::datatable(
      data = .,
      options = list(scrollY = 300, scroller = TRUE, deferRender = TRUE),
      rownames = FALSE,
      filter = list(position = 'top', clear = TRUE, plain = FALSE),
      # filter = "none",
      extensions = "Scroller",
      fillContainer = TRUE
    )
  out
}

#' returns a dataframe with columns <id_vars>, rule, description, <value vars>
get_rule_info <- function(valuedf, rule, id_vars = c("row", "file")) {
  rule_in <- rule
  checklist <- utValidateR::get_checklist()

  checklist_row <- dplyr::filter(checklist, rule == rule_in)
  stopifnot(nrow(checklist_row) == 1L)

  rule_vars <- get_rule_variables(rule = rule_in, checklist = checklist)

  out <- valuedf %>%
    select(row, file, any_of(rule_vars)) %>%
    mutate(description = checklist_row$description,
           expr = paste(deparse(checklist_row$checker[[1]]), collapse = "\n"))
  out
}


#' Returns a DT::datatable object for displaying
#'
#' @param error_table dataframe as returned in `errors_byrule` component of `get_stats_tables()`
#' @importFrom dplyr select
#' @export
format_rule_table <- function(rule_table) {
  out <- rule_table %>%
    DT::datatable(
      data = .,
      options = list(scrollY = 300, scroller = TRUE, deferRender = TRUE),
      rownames = FALSE,
      filter = list(position = 'top', clear = TRUE, plain = FALSE),
      extensions = "Scroller",
      selection = "single"
    )
  out
}

