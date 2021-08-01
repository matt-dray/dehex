#' Convert a Full Hex Code to Shorthand Code
#'
#' Takes a hex code like '#C0FFEE' and simplifies to '#CFE' (i.e. the first
#' character from each character pair).
#'
#' @param hex_code Character. A valid hex colour code starting with a hash mark
#'     (#). Characters must take the values 0 to 9 or A to F (case insensitive).
#'
#' @return Character. A shortened hex colour code: a hash mark followed by three
#'     characters (0 to 9, A to F).
#' @export
#'
#' @examples dh_shorten("#C0FFEE")
dh_shorten <- function(hex_code) {

  if (!grepl("^#([[:xdigit:]]{6}|[[:xdigit:]]{3})$", hex_code)) {

    stop(
      "'hex_code' must be a valid 3- or 6-character hex code starting with '#'."
    )

  }

  if (nchar(hex_code) == 4) {

    hex_out <- toupper(hex_code)

  } else if (nchar(hex_code) == 7) {

    chars <- strsplit(hex_code, "")[[1]]
    hex_out <- toupper(paste(chars[c(1, 2, 4, 6)], collapse = ""))

  }

  return(hex_out)

}

#' Print to the Console a Hex Shortcode as an RGB graph
#'
#' Takes a three-character hex colour shortcode and prints to the console a bar
#' chart of the red (R), green (G) and blue (B) values using unicode blocks.
#' This provides a quick visual assessment of the relative amounts of each
#' colour expressed by the hex shortcode.
#'
#' @param hex_short Character. A valid hex-colour shortcode starting with a
#'     hash mark (#) and followed by three alphanumeric characters, which must
#'     take the values 0 to 9 or A to F (case insensitive).
#'
#' @details The amount of red (R), green (G) and blue (B) is calculated on the
#'     basis that hex shortcodes contain one character for each colour. Since
#'     they're hexadecimal, they can take one of 16 possible values: 0 to 9 and
#'     then alphabetic characters from A to F (i.e. 10 to 15). That means that
#'     a shortcode of '#18F' has relative RGB values of 1, 8 and 16.
#'
#' @return "NULL". Prints to the console with cat() a bar chart.
#' @export
#'
#' @examples dh_graph("#D83")
dh_graph <- function(hex_short) {

  if (!grepl("^#([[:xdigit:]]{3})$", hex_short)) {

    stop(
      "'hex_code' must be a valid 3-character hex code starting with '#'."
    )

  }

  hex_short <- toupper(hex_short)

  chars <- strsplit(hex_short, "")[[1]]
  hex_vals <- stats::setNames(c(0:15), c(0:9, LETTERS[1:6]))

  r_val <- hex_vals[chars[2]]
  g_val <- hex_vals[chars[3]]
  b_val <- hex_vals[chars[4]]

  block  <- "\U2588"
  empty <- "\U2591"

  r_set <- c(rep(block, r_val), rep(empty, 15 - r_val))
  g_set <- c(rep(block, g_val), rep(empty, 15 - g_val))
  b_set <- c(rep(block, b_val), rep(empty, 15 - b_val))

  cat(
    hex_short, "\n",
    crayon::red(c("R ", r_set)),
    crayon::green(c("\nG ", g_set)),
    crayon::blue(c("\nB ", b_set)),
    sep = ""
  )

}
