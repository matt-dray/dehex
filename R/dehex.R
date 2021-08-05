
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

#' Generate a Random Hex Colour Code
#'
#' The purpose of \{dehex\} is to train how to 'read' the colour from a hex code.
#' This function generates a random hex code for you so you can test your skills.
#'
#' @param shorten Logical. Shorten six-character hex colour code to three
#'     characters? The three-character hex code is what is used to interpret
#'     the colour in the \{dehex\} 'training' context.
#'
#' @return Character string of length one. A three- or six-character hex code
#'     preceded by a hash mark, '#'.
#' @export
#'
#' @examples dh_random(TRUE)
dh_random <- function(shorten = FALSE) {

  if (!is.logical(shorten)) {
    stop("'shorten' must be either TRUE or FALSE.")
  }

  hex <- paste0(
    "#",
    paste(sample(c(1:9, LETTERS[1:6]), 6, replace = TRUE), collapse = "")
  )

  if (shorten) hex <- dh_shorten(hex)

  return(hex)

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
#' @param adorn_h Logical. Add an optional value showing the relative rrank of
#'     the RGB values (i.e. am indicator of hue)? A visual aid.
#' @param adorn_s Logical. Add an optional bar showing where the range of the RGB
#'     values falls (i.e. am indicator of saturation)? A visual aid.
#' @param adorn_l Logical. Add an optional bar showing where the mean of the RGB
#'     values falls (i.e. am indicator of lightness)? A visual aid.
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
dh_graph <- function(hex_short,
                     text = NULL,
                     adorn_h = TRUE,
                     adorn_s = TRUE,
                     adorn_l = TRUE) {

  if (!grepl("^#([[:xdigit:]]{3})$", hex_short)) {
    stop("'hex_code' must be a valid 3-character hex code starting '#'.")
  }

  hex_short <- toupper(hex_short)

  hex2dec_lookup <- .get_hex2dec()
  rgb_hex <- .get_rgb_hex(hex_short)
  rgb_dec <- .get_rgb_dec(hex2dec_lookup, rgb_hex)

  blocks <- .get_blocks()
  blocksets <- .get_rgb_blocksets(
    blocks, rgb_dec,
    adorn_h = adorn_h, adorn_s = adorn_s, adorn_l = adorn_l
  )

  cat(
    ifelse(is.null(text), hex_short, text), "\n",
    crayon::red(  c("R ", blocksets$R, "\n")),
    crayon::green(c("G ", blocksets$G, "\n")),
    crayon::blue( c("B ", blocksets$B, "\n")),
    if (adorn_s) c("S ", blocksets$S, "\n"),
    if (adorn_l) c("L ", blocksets$L, "\n"),
    "\n",
    sep = ""
  )

}


#' Print RGB Bar Graphs as Guides for Hue, Saturation and Light
#'
#' Print bar charts of RGB values that represent simplified groupings of
#' hue, saturation or lightness levels in the HSL system. Intended for use as a
#' reference to assess which RGB profiles most closely represents a user's hex
#' shortcode.
#'
#' @param type Character. Which of hue ('H'), saturation ('S') or
#'     light ('L') that you want to print the guide for.
#'
#' @details The hue guide prints guides for the primary (red, green, blue),
#'     secondary (yellow, cyan, magenta) and tertiary (orange, chartreuse,
#'     aquamarine, azure, violet, rose) hues. For saturation, the guide contains
#'     'washed' (i.e. the largest range in RGB values), muted, and grey (i.e.
#'     no difference between RGB  values). In the lightness guide they're
#'     'light' (i.e.high mean value of RGB), 'middle', and 'dark' (i.e. small
#'     range in RGB values).
#'
#' @return Nothing. Prints bar charts of RGB values to the console, made with
#'     unicode blocks.
#' @export
#'
#' @examples dh_guide("L")
dh_guide <- function(type = c("H", "S", "L")) {

  if (!is.character(type) | !type %in% c("H", "S", "L")) {
    stop("'hsl' must take a single character: 'H', 'S' or 'L'.")
  }

  if (type == "H") .print_guide("H")
  if (type == "S") .print_guide("S")
  if (type == "L") .print_guide("L")

}

# WIP
dh_solve <- function(hex_code) {

  if (!grepl("^#([[:xdigit:]]{6}|[[:xdigit:]]{3})$", hex_code)) {
    stop(
      "'hex_code' must be a valid 3- or 6-character hex code starting with '#'."
    )
  }

  if (grepl("^#[[:xdigit:]]{6}$", hex_code)) {
    hex_code <- dh_shorten(hex_code)
  }

  hex_short <- toupper(hex_code)

  hex2dec_lookup <- .get_hex2dec()
  rgb_hex <- .get_rgb_hex(hex_code)
  rgb_dec <- .get_rgb_dec(hex2dec_lookup, rgb_hex)

  rgb_rank  <- rank(rgb_dec)
  rgb_mean  <- round(mean(rgb_dec))
  rgb_range <- range(rgb_dec)

  list(rgb_rank, rgb_mean, rgb_range)

}

