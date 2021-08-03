
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
  }

  if (nchar(hex_code) == 7) {
    chars <- strsplit(hex_code, "")[[1]]
    hex_out <- toupper(paste(chars[c(1, 2, 4, 6)], collapse = ""))
  }

  return(hex_out)

}

#' Print a Hex Shortcode as an RGB graph
#'
#' Takes a three-character hex colour shortcode and prints to the console a bar
#' chart of the red (R), green (G) and blue (B) values using unicode blocks.
#' This provides a quick visual assessment of the relative amounts of each
#' colour expressed by the hex shortcode.
#'
#' @param hex_short Character. A valid hex-colour shortcode starting with a
#'     hash mark (#) and followed by three alphanumeric characters, which must
#'     take the values 0 to 9 or A to F (case insensitive).
#' @param text Character. An optional string to place above the plot. If NULL
#'     (default), then the shortcode will be automatically selected.
#' @param light Logical. Add an optional bar showing where the mean of the RGB
#'     values falls (i.e. am indicator of lightness)?
#' @param sat Logical. Add an optional bar showing where the range of the RGB
#'     values falls (i.e. am indicator of saturation)?
#'
#' @details The amount of red (R), green (G) and blue (B) is calculated on the
#'     basis that hex shortcodes contain one character for each colour. Since
#'     they're hexadecimal, they can take one of 16 possible values: 0 to 9 and
#'     then alphabetic characters from A to F (i.e. 10 to 15). That means that
#'     a shortcode of '#18F' has relative RGB values of 1, 8 and 16.
#'
#' @return Nothing. Prints to the console with cat() a bar chart.
#' @export
#'
#' @examples dh_graph("#D83")
dh_graph <- function(hex_short, text = NULL, light = FALSE, sat = FALSE) {

  if (!grepl("^#([[:xdigit:]]{3})$", hex_short)) {
    stop("'hex_code' must be a valid 3-character hex code starting '#'.")
  }

  hex_short <- toupper(hex_short)

  hex2dec_lookup <- .get_hex2dec()
  rgb_hex        <- .get_rgb_hex(hex_short)
  rgb_dec        <- .get_rgb_dec(hex2dec_lookup, rgb_hex)

  blocks    <- .get_blocks()
  blocksets <- .get_rgb_blocksets(blocks, rgb_dec, light = light, sat = sat)

  cat(
    ifelse(is.null(text), hex_short, text), "\n",
    crayon::red(  c("R ", blocksets$R, "\n")),
    crayon::green(c("G ", blocksets$G, "\n")),
    crayon::blue( c("B ", blocksets$B, "\n")),
    if (light) c("L ", blocksets$L, "\n"),
    if (sat) c("S ", blocksets$S, "\n"),
    "\n",
    sep = ""
  )

}

#' Print RGB Bar Graphs to Demonstrate Hue Profiles
#'
#' Print the primary, secondary and tertiary colours in the HSL system as bar
#' charts of the RGB values that they're composed of. Intended for use as a
#' reference to assess which RGB profile most closely represents a user's hex
#' shortcode.
#'
#' @return Nothing. Prints bar charts of RGB values to the console, made with
#'     unicode blocks.
#' @export
#'
#' @examples dh_hue()
dh_hue <- function() {

  hue_hex <- c(
    "#F00" = "Red",
    "#F80" = "Orange",
    "#FF0" = "Yellow",
    "#8F0" = "Chartreuse",
    "#0F0" = "Green",
    "#0F8" = "Aquamarine",
    "#0FF" = "Cyan",
    "#08F" = "Azure",
    "#00F" = "Blue",
    "#80F" = "Violet",
    "#F0F" = "Magenta",
    "#F08" = "Rose"
  )

  purrr::walk2(names(hue_hex), hue_hex, dh_graph)

}

#' Print RGB Bar Graphs to Demonstrate Light Profiles
#'
#' Print the primary, secondary and tertiary colours in the HSL system as bar
#' charts of the RGB values that they're composed of. Intended for use as a
#' reference to assess which RGB profile most closely represents a user's hex
#' shortcode.
#'
#' @details The values are light (i.e. high mean value of RGB), middle and dark
#'     (i.e. small range in RGB values).
#'
#' @return Nothing. Prints bar charts of RGB values to the console, made with
#'     unicode blocks.
#' @export
#'
#' @examples dh_hue()
dh_light <- function(light = TRUE) {

  light_hex <- c(
    "#FED" = "Light",
    "#987" = "Middle",
    "#321" = "Dark"
  )
    purrr::walk2(names(light_hex), light_hex, dh_graph, light = light)

}

#' Print RGB Bar Graphs to Demonstrate Saturation Profiles
#'
#' Print bar charts of RGB values that represent simplified groupings of
#' saturation levels in the HSL system. Intended for use as a reference to
#' assess which RGB profile most closely represents a user's hex shortcode.
#'
#' @details The values are saturated (i.e. the largest range in RGB values)
#'     washed, muted and grey (i.e. no difference between RGB values).
#'
#' @return Nothing. Prints bar charts of RGB values to the console, made with
#'     unicode blocks.
#' @export
#'
#' @examples dh_hue()
dh_sat <- function(sat = TRUE) {

  sat_hex <- c(
    "#F80" = "Saturated",
    "#D82" = "Washed",
    "#A85" = "Muted",
    "#888" = "Grey"
  )

  purrr::walk2(names(sat_hex), sat_hex, ~dh_graph(.x, .y, sat = sat))

}
