
#' Show a modal notification when evaluating an expression
#'
#' @param message Message to be displayed
#' @param session	The session object passed to function given to shinyServer.
#' @export
withModal <- function(expr, message, session) {
  md <- modalDialog(title = "Loading", p(message), easyClose = FALSE,
                    fade = FALSE, footer = NULL)
  showModal(md, session = session)
  out <- eval(expr)
  removeModal()
  out
}

format_summary_table <- function(summary_table) {

}

