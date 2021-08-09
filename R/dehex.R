
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
#' @param adorn_h Logical. Add an optional value showing the relative rank of
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
  rgb_dec <- .get_rgb_dec(rgb_hex, hex2dec_lookup)

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
    if (adorn_s)  c("S ", blocksets$S, "\n"),
    if (adorn_l)  c("L ", blocksets$L, "\n"),
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

#' Get a Name for a Hex Code With Optional Diagnostic Plots and Swatch
#'
#' Convert a colour hex code to an English string that roughly describes its
#' colour in terms of hue, saturation and lightness, like 'dark saturated
#' azure'. Optionally print to the console the hue, saturation and lightness
#' graphs that best approximate that hex code. Optionally plot a block with
#' the colour that the hex code encodes.
#'
#' @param hex_code Character. A valid hex colour code starting with a hash mark
#'     (#). Characters must take the values 0 to 9 or A to F (case insensitive).
#' @param graphs Logical. Do you want to print the result and associated hue,
#'     saturation and lightness bar charts to the console? Defaults to TRUE.
#' @param swatch Logical. Print to a graphical device a plot of the colour
#'     represented by (three-digit) hex code? Defaults to TRUE.
#'
#' @return A character string. Optionally some console output and a plot.
#'
#' @export
#' @examples dh_solve("#08F", graphs = FALSE, swatch = FALSE)
dh_solve <- function(hex_code, graphs = TRUE, swatch = TRUE) {

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

  # Asses user input
  user_hex   <- .get_rgb_hex(hex_short)
  user_dec   <- .get_rgb_dec(user_hex, hex2dec_lookup)
  user_rank  <- .rank_with_tolerance(user_dec)  # hue
  user_range <- diff(range(user_dec))  # saturation
  user_mean  <- round(mean(user_dec))  # lightness

  # Assess hues
  hue_hex_list  <- purrr::map(.get_rgb2name("H"), .get_rgb_hex)
  hue_dec_list  <- purrr::map(hue_hex_list, ~.get_rgb_dec(.x, hex2dec_lookup))
  hue_rank_list <- purrr::map(hue_dec_list, rank)

  # User's hue solved
  hue_rank_list_lgl <- purrr::map(hue_rank_list, ~ all(`==`(.x, user_rank)))
  hue_solved        <- names(Filter(isTRUE, hue_rank_list_lgl))

  # User's saturation solved
  sat_solved <- dplyr::case_when(
    user_range == 0 ~ "grey",
    user_range >= 1  & user_range <= 5  ~ "muted",
    user_range >= 6  & user_range <= 11  ~ "washed",
    user_range >= 12 & user_range <= 16 ~ "saturated",
    TRUE ~ "ERROR"
  )

  # User's lightness solved
  light_solved <- dplyr::case_when(
    user_mean >= 0  & user_mean <= 5  ~ "dark",
    user_mean >= 6  & user_mean <= 10 ~ "middle",
    user_mean >= 11 & user_mean <= 16 ~ "light",
    TRUE ~ "ERROR"
  )

  if (swatch) {

    dh_swatch(hex_short)

  }

  if (!graphs) {

    return(paste(light_solved, sat_solved, hue_solved))

  }

  if (graphs) {

    dh_graph(
      hex_short,
      paste("input code:", hex_short),
    )

    dh_graph(
      .get_rgb2name("H")[hue_solved],
      paste("hue:", hue_solved),
      adorn_s = FALSE, adorn_l = FALSE
    )

    dh_graph(
      .get_rgb2name("S")[sat_solved],
      paste("saturation:", sat_solved),
      adorn_h = FALSE, adorn_l = FALSE
    )

    dh_graph(
      .get_rgb2name("L")[light_solved],
      paste("lightness:", light_solved),
      adorn_h = FALSE, adorn_s = FALSE
    )

    return(paste(light_solved, sat_solved, hue_solved))

  }

}

#' Plot the Colour of a Short Hex Code
#'
#' Check the colour of an input hex colour code by plotting it.
#'
#' @param hex_code Character. A valid hex colour code starting with a hash mark
#'     (#). Characters must take the values 0 to 9 or A to F (case insensitive).
#'
#' @return A plot.
#' @export
#'
#' @examples dh_swatch("#F14362")
dh_swatch <- function(hex_code) {

  if (!grepl("^#([[:xdigit:]]{6}|[[:xdigit:]]{3})$", hex_code)) {
    stop(
      "'hex_code' must be a valid 3- or 6-character hex code starting with '#'."
    )
  }

  if (grepl("^#[[:xdigit:]]{6}$", hex_code)) {
    hex_code <- dh_shorten(hex_code)
  }

  hex_short <- toupper(hex_code)
  hex_doubleup <- paste(
    strsplit(hex_short, "")[[1]][c(1, 2, 2, 3, 3, 4, 4)],
    collapse = ""
  )

  grid::grid.newpage()

  grid::grid.draw(
    grid::rectGrob(
      gp = grid::gpar(fill = hex_doubleup, lty = 0)
    )
  )

}

