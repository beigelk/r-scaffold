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