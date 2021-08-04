
.get_hex2dec <- function() {
  stats::setNames(0:15, c(0:9, LETTERS[1:6]))
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

.print_hue_guide <- function() {

  hue_hex <- c(
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

  purrr::walk2(
    names(hue_hex),
    hue_hex,
    dh_graph, adorn_s = FALSE, adorn_l = FALSE
  )

}

.print_light_guide <- function() {

  light_hex <- c(
    "#FED" = "Light",
    "#987" = "Middle",
    "#321" = "Dark"
  )

  purrr::walk2(
    names(light_hex),
    light_hex,
    dh_graph, adorn_h = FALSE, adorn_s = FALSE
  )

}

.print_sat_guide <- function() {

  sat_hex <- c(
    "#F80" = "Saturated",
    "#D82" = "Washed",
    "#A85" = "Muted",
    "#888" = "Grey"
  )

  purrr::walk2(
    names(sat_hex),
    sat_hex,
    dh_graph, adorn_h = FALSE, adorn_l = FALSE
  )

}
