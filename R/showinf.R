#' Displaying images and metadata
#'
#' @param file File to display
#' @param series All images in the input file are converted by default.
#' To convert only one series, set this to a numeric
#' @param crop of the format x,y,width,height. The (x, y) coordinate
#' (0, 0) is the upper-left corner of the image;
#' x + width must be less than or equal to the image width
#' and y + height must be less than or equal to the image height.
#' @param debug Enables debugging output if more information is needed
#' @param opts Additional options to pass to \code{showinf}
#' @param verbose Should the command be printed
#' @param run  Should the command be run?  Useful for diagnostics.
#' @param autoscale Adjusts the display range to the
#' minimum and maximum pixel values.
#'
#' @return The output file name
#' @export
#'
#' @examples
#' file = "~/Downloads/2017_08_03__0006.czi"
#' if (file.exists(file)) {
#' res = showinf(file = file, run = FALSE)
#' res
#' }
showinf = function(
  file,
  pixel_data = FALSE,
  series = NULL,
  range = NULL,
  crop = NULL,
  autoscale = FALSE,
  opts = c("-no-upgrade", "-novalid"),
  debug = FALSE,
  verbose = TRUE,
  run = TRUE
) {


  stopifnot(file.exists(file))

  opts = c(opts,
           ifelse(!pixel_data, "-nopix", ""))

  L = list(
    series = series,
    range = range,
    crop = crop
  )
  nulls = sapply(L, is.null)
  L = L[!nulls]

  if (length(L) > 0) {
    names(L) =  paste0("-", names(L))
    L = mapply(function(name, value) {
      collapser = " "
      if (name == "crop") {
        collapser = ","
      }
      value = paste(value, collapse = collapser)
      paste(name, value)
    }, names(L), L, SIMPLIFY = TRUE)
    opts = c(opts, L)
  }

  if (debug) {
    opts = c(opts, "-debug")
  }
  if (autoscale) {
    opts = c(opts, "-autoscale")

  }
  opts = opts[ opts != "" ]
  opts = paste(opts, collapse = " ")

  cmd = bf_cmd("showinf")
  cmd = paste(cmd, file, opts)
  outfile = tempfile(fileext = ".txt")
  cmd = paste(cmd, ">", outfile)
  if (verbose) {
    message("Command is: ", cmd)
  }
  if (run) {

    res = system(cmd)
    if (res != 0) {
      warning("Result was not zero!")
    }
    class(outfile) = "showinf_result"
    return(outfile)
  } else {
    return(cmd)
  }

}

#' @export
#' @rdname showinf
bf_showinf = showinf


#' @export
#' @rdname showinf
bf_show_info = showinf