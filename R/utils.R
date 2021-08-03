
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


    blockset_mean <- setNames(rep(blocks[["empty"]], 15), as.character(1:15))
    blockset_mean[round(mean(rgb_dec))] <- blocks[["full"]]

    blockset <- c(blockset, list("L" = blockset_mean))

  }

  if (sat) {

    rgb_min <- min(rgb_dec)
    rgb_max <- max(rgb_dec)

    blockset_range <- setNames(rep(blocks[["empty"]], 15), as.character(1:15))
    blockset_range[rgb_min:rgb_max] <- blocks[["full"]]

    blockset <- c(blockset, list("S" = blockset_range))

  }

  return(blockset)

}
