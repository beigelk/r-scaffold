#' Save a plot to both PDF and PNG (600 dpi) formats
#'
#' This function takes a ggplot (or base R plot) object and saves it
#' to both a `.pdf` and `.png` file with the specified dimensions.
#'
#' @param plot The plot object to be saved. e.g. a ggplot2 plot or base R plot.
#' @param filename A character string specifying the base filename (without extension).
#' @param width The width of the output image in inches.
#' @param height The height of the output image in inches.
#'
#' @return Saves files to disk. No return value.
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p = ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point()
#' plot_pdf_and_png(p, "my_plot", width = 6, height = 4)
#' }
plot_pdf_and_png <- function(
    plot,
    filename,
    width,
    height) 
{
    # Save as PDF
    pdf(
        file = paste0(filename, ".pdf"),
        width = width,
        height = height
    )
    print(plot)
    dev.off()

    # Save as 600 dpi PNG
    png(
        file = paste0(filename, ".png"),
        width = width,
        height = height,
        res = 600,
        units = "in"
    )
    print(plot)
    dev.off()
}

###############################################################################
# File:           utils.R
# Purpose:        Utility/helper functions for common tasks
#
# Description:
#   This file defines general-purpose functions used by multiple pipeline steps,
#   such as logging, safe file reading, error handling, etc.
#
# Usage:
#   Include this file in  R scripts via:
#       source(file.path(Sys.getenv("SCRIPT_DIR", "."), "utils.R"))
#
# Notes:
#   - Do not run this R file directly.
#   - Keep functions general and side-effect-free if possible.
#   - If adding new functions, document inline.
###############################################################################

#' Log a message with a timestamp and level
#'
#' Prints a formatted log message to the console including a timestamp and a log level.
#'
#' @param msg A character string containing the message to log.
#' @param level A character string specifying the log level (e.g., "INFO", "ERROR", "DEBUG"). Default is "INFO".
#'
#' @return NULL. Called for side effects (prints to console).
#'
#' @examples
#' log_message("Starting analysis")
#' log_message("File not found", level = "ERROR")
# log_message = function(msg, level = "INFO") {
#   timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
#   cat(sprintf("[%s] [%s] %s\n", timestamp, level, msg))
# }

log_message = function(msg, level = "INFO") {
  timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  
  # ANSI color codes
  colors = c(
    "START" = "\033[33m",
    "INFO" = "\033[97m",
    "PLOT" = "\033[38;5;240m",
    "WARN" = "\033[38;5;208m",
    "ERROR" = "\033[31m",
    "DEBUG" = "\033[34m",
    "MSG" = "\033[77m",
    "DONE" = "\033[32m"
  )
  
  reset = "\033[0m"  # reset color

  level = toupper(level)
  level_fmt = sprintf("%5s", level)
  
  # Pick color for the level, default to white
  color = colors[[level]]
  if (is.null(color)) color = "\033[37m"  # white
  
  # Print colored message
  cat(sprintf("%s[%s] [%s] %s%s\n", color, timestamp, level_fmt, msg, reset))
}