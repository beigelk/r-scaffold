#' Function name.
#'
#' One-line summary of the function's purpose.
#' 
#' Extended description of the function and its purpose.
#'
#' @param x numeric. A single numeric value or vector of numeric values.
#' @param y integer. A single integer value or vector of integers.
#' @param z logical. A TRUE/FALSE flag to toggle behavior.
#' @param name character. A single string value (e.g., a filename or label).
#' @param names character vector. A vector of names.
#' @param df data.frame. A data frame containing input variables.
#' @param list_input list. A generic list of elements.
#' @param fun function. A function to be applied to each element.
#' @param formula formula. A formula object, like y ~ x.
#' @param plot ggplot or base R plot. A plot object to be displayed or saved.
#' @param model lm or glm object. A fitted model object from lm() or glm().
#' @param file character. A path to a file.
#' @param dir character. Path to a directory.
#' @param path character. General file or directory path.
#' @param matrix matrix. A numeric matrix.
#' @param vector numeric or character. A general vector input.
#' @param factor factor. A categorical variable.
#' @param levels character vector. A vector of category levels.
#' @param id integer or character. A unique identifier.
#' @param cols character vector. Names of columns to select or modify.
#' @param weights numeric vector. Weights to apply to observations.
#' @param params list. A named list of parameters.
#' @param options list. Additional options for customization.
#' @param config list or character. A configuration object or path to config file.
#' @param verbose logical. Whether to print messages.
#' @param debug logical. Whether to run in debug mode.
#' @param seed integer. A random seed for reproducibility.
#' @param ... Additional arguments passed to downstream functions.
#'
#' @return character. The result of the computation, or NULL if failed.
#'
#' @examples
#' \dontrun{
#' result = function_name(file = "input.txt", verbose = TRUE)
#' }
your_function = function(
    arg1,
    arg2,
    verbose = FALSE,
    ...
) {
  # function code
}
