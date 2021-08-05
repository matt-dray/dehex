
# Vector of dec values named for their hex value
.get_hex2dec <- function() {
  stats::setNames(0:15, c(0:9, LETTERS[1:6]))
}

# Vector of RGB hex values for supplied short hexcode
.get_rgb_hex <- function(hex_short) {
  stats::setNames(
    strsplit(hex_short, "")[[1]][2:4],
    c("R", "G", "B")
  )
}

# Vector of RGB dec values for supplied short hexcode
.get_rgb_dec <- function(hex2dec_lookup, rgb_hex) {
  purrr::set_names(
    purrr::map_dbl(c("R", "G", "B"), ~hex2dec_lookup[rgb_hex[.x]]),
    c("R", "G", "B")
  )
}

# List of unicode blocks for bar charts
.get_blocks <- function() {
  list(full = "\U2588", empty = "\U2591")
}

# Build bars from blocks given RGB dec values
.get_rgb_blocksets <- function(blocks,
                               rgb_dec,
                               adorn_h = FALSE,
                               adorn_s = FALSE,
                               adorn_l = FALSE) {

  if (adorn_h) {
    rgb_dec_rank <- rank(rgb_dec)
  }

  blockset <- purrr::set_names(
    purrr::map(
      c("R", "G", "B"),
      ~c(
        rep(blocks[["full"]], rgb_dec[.x] + 1),
        rep(blocks[["empty"]], 15 - rgb_dec[.x]),
        ifelse(adorn_h, paste(" H", rgb_dec_rank[.x]), "")
      )
    ),
    c("R", "G", "B")
  )

  if (adorn_l) {

    blockset_mean <-
      stats::setNames(rep(blocks[["empty"]], 16), as.character(1:16))

    blockset_mean[round(mean(rgb_dec)) + 1] <- blocks[["full"]]

    blockset <- c(blockset, list("L" = blockset_mean))

  }

  if (adorn_s) {

    rgb_min <- min(rgb_dec)
    rgb_max <- max(rgb_dec)

    blockset_range <-
      stats::setNames(rep(blocks[["empty"]], 16), as.character(1:16))

    blockset_range[(rgb_min + 1):(rgb_max + 1)] <- blocks[["full"]]

    blockset <- c(blockset, list("S" = blockset_range))

  }

  return(blockset)

}

# Vector of colour names, named with their short hex code
.get_rgb2name <- function(type = c("H", "S", "L")) {

  if (type == "H") {

    col_vector <- c(
      "#F00" = "Red (primary)",
      "#0F0" = "Green (primary)",
      "#00F" = "Blue (primary)",
      "#FF0" = "Yellow (secondary)",
      "#0FF" = "Cyan (secondary)",
      "#F0F" = "Magenta (secondary)",
      "#F80" = "Orange (tertiary)",
      "#8F0" = "Chartreuse (tertiary)",
      "#0F8" = "Aquamarine (tertiary)",
      "#08F" = "Azure (tertiary)",
      "#80F" = "Violet (tertiary)",
      "#F08" = "Rose (tertiary)",
      "#888" = "Grey"
    )

  }

  if (type == "S") {

    col_vector <- c(
      "#F80" = "Saturated",
      "#D82" = "Washed",
      "#A85" = "Muted",
      "#888" = "Grey"
    )

  }

  if (type == "L") {

    col_vector <- c(
      "#FED" = "Light",
      "#987" = "Middle",
      "#321" = "Dark"
    )

  }

  return(col_vector)

}

# Cat the full set of visual-aid bar charts for H, S, L
.print_guide <- function(type = c("H", "S", "L")) {

  if (type == "H") {

    adorn_h_lgl <- TRUE
    adorn_s_lgl <- FALSE
    adorn_l_lgl <- FALSE

  }

  if (type == "S") {

    adorn_h_lgl <- FALSE
    adorn_s_lgl <- TRUE
    adorn_l_lgl <- FALSE

  }

  if (type == "L") {

    adorn_h_lgl <- FALSE
    adorn_s_lgl <- FALSE
    adorn_l_lgl <- TRUE

  }

  rgb_dict <- .get_rgb2name(type)

  purrr::walk2(
    names(rgb_dict), rgb_dict,
    dh_graph,
    adorn_h = adorn_h_lgl,
    adorn_s = adorn_s_lgl,
    adorn_l = adorn_l_lgl
  )

}
