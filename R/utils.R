
.get_hex2dec <- function(dec_vals = 0:15) {
  stats::setNames(c(dec_vals), c(0:9, LETTERS[1:6]))
}

.get_rgb_hex <- function(hex_short) {
  stats::setNames(
    strsplit(hex_short, "")[[1]][2:4],
    c("R", "G", "B")
  )
}

.get_rgb_dec <- function(hex2dec_lookup, rgb_hex) {
  purrr::set_names(
    purrr::map_dbl(c("R", "G", "B"), ~hex2dec_lookup[rgb_hex[.x]]),
    c("R", "G", "B")
  )
}

.get_blocks <- function() {
  list(full = "\U2588", empty = "\U2591")
}

.get_rgb_blocksets <- function(blocks, rgb_dec, light = FALSE, sat = FALSE) {

  blockset <- purrr::set_names(
    purrr::map(
      c("R", "G", "B"),
      ~c(
        rep(blocks[["full"]], rgb_dec[.x]),
        rep(blocks[["empty"]], 15 - rgb_dec[.x])
      )
    ),
    c("R", "G", "B")
  )

  if (light) {


    blockset_mean <-
      stats::setNames(rep(blocks[["empty"]], 15), as.character(1:15))
    blockset_mean[round(mean(rgb_dec))] <- blocks[["full"]]

    blockset <- c(blockset, list("L" = blockset_mean))

  }

  if (sat) {

    rgb_min <- min(rgb_dec)
    rgb_max <- max(rgb_dec)

    blockset_range <-
      stats::setNames(rep(blocks[["empty"]], 15), as.character(1:15))
    blockset_range[rgb_min:rgb_max] <- blocks[["full"]]

    blockset <- c(blockset, list("S" = blockset_range))

  }

  return(blockset)

}

.print_hue_guide <- function() {

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

.print_light_guide <- function(light = TRUE) {

  light_hex <- c(
    "#FED" = "Light",
    "#987" = "Middle",
    "#321" = "Dark"
  )

  purrr::walk2(names(light_hex), light_hex, dh_graph, light = light)

}

.print_sat_guide <- function(sat = TRUE) {

  sat_hex <- c(
    "#F80" = "Saturated",
    "#D82" = "Washed",
    "#A85" = "Muted",
    "#888" = "Grey"
  )

  purrr::walk2(names(sat_hex), sat_hex, ~dh_graph(.x, .y, sat = sat))

}
