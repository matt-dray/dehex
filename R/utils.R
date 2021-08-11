
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
.get_rgb_dec <- function(rgb_hex, hex2dec_lookup) {
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
    rgb_dec_rank <- .rank_with_tolerance(rgb_dec)
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
      # primary
      "red"   = "#F00",
      "green" = "#0F0",
      "blue"  = "#00F",
      # secondary
      "yellow"  = "#FF0",
      "cyan"    = "#0FF",
      "magenta" = "#F0F",
      # tertiary
      "orange"     = "#F80",
      "chartreuse" = "#8F0",
      "aquamarine" = "#0F8",
      "azure"      = "#08F",
      "violet"     = "#80F",
      "rose"       = "#F08",
      # grey
      "grey"       = "#888"
    )

  }

  if (type == "S") {

    col_vector <- c(
      "saturated" = "#F80",
      "washed"    = "#C83",
      "muted"     = "#986",
      "grey"      = "#888"
    )

  }

  if (type == "L") {

    col_vector <- c(
      "light"  = "#FED",
      "middle" = "#987",
      "dark"   = "#321"
    )

  }

  return(col_vector)

}

# Cat the full set of visual-aid bar charts for H, S, L
.print_guide <- function(type = c("H", "S", "L"), crayon) {

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
    rgb_dict, names(rgb_dict),
    dh_graph,
    adorn_h = adorn_h_lgl,
    adorn_s = adorn_s_lgl,
    adorn_l = adorn_l_lgl,
    crayon = crayon
  )

}

# Allow for a wider tolerance when computing ties in RGB hue
.rank_with_tolerance <- function(rgb_vec, tolerance = 2) {

  rg_diff <- abs(rgb_vec[["R"]] - rgb_vec[["G"]])
  gb_diff <- abs(rgb_vec[["G"]] - rgb_vec[["B"]])
  rb_diff <- abs(rgb_vec[["R"]] - rgb_vec[["B"]])

  diff_tol <- tolerance

  if (rg_diff <= diff_tol & gb_diff <= diff_tol & rb_diff <= diff_tol) {

    rgb_ranked <- c("R" = 2, "G" = 2, "B" = 2)

  } else if (rg_diff <= diff_tol) {

    rgb_ranked <- rank(rgb_vec)
    rgb_ranked["R"] <- rgb_ranked["G"] <-
      mean(c(rgb_ranked["R"], rgb_ranked["G"]))

  } else if (gb_diff <= diff_tol) {

    rgb_ranked <- rank(rgb_vec)
    rgb_ranked["G"] <- rgb_ranked["B"] <-
      mean(c(rgb_ranked["G"], rgb_ranked["B"]))

  } else if (rb_diff <= diff_tol) {

    rgb_ranked <- rank(rgb_vec)
    rgb_ranked["R"] <- rgb_ranked["B"] <-
      mean(c(rgb_ranked["R"], rgb_ranked["B"]))

  } else {

    rgb_ranked <- rank(rgb_vec)

  }

  return(rgb_ranked)

}
