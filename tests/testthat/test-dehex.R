
# dh_shorten
test_that("six-character hex shortening works", {

  expect_equal(dh_shorten("#ffffff"), "#FFF")
  expect_equal(dh_shorten("#fff"), "#FFF")
  expect_match(dh_shorten("#ffffff"), "^#[[:xdigit:]]{3}$")
  expect_match(dh_shorten("#fff"), "^#[[:xdigit:]]{3}$")

  expect_type(dh_shorten("#ffffff"), "character")
  expect_equal(length(dh_shorten("#ffffff")), 1)
  expect_equal(nchar(dh_shorten("#ffffff")), 4)
  expect_equal(nchar(dh_shorten("#fff")), 4)

  expect_error(dh_shorten("#fffffff"))
  expect_error(dh_shorten("x"))
  expect_error(dh_shorten(1))
  expect_error(dh_shorten(list()))
  expect_error(dh_shorten(data.frame()))
  expect_error(dh_shorten(matrix()))

})

# dh_random
test_that("random hex is produced", {

  expect_match(dh_random(), "^#[[:xdigit:]]{6}$")
  expect_match(dh_random(shorten = TRUE), "^#[[:xdigit:]]{3}$")

  expect_type(dh_random(), "character")
  expect_type(dh_random(shorten = TRUE), "character")
  expect_length(dh_random(), 1)
  expect_length(dh_random(shorten = TRUE), 1)
  expect_equal(nchar(dh_random()), 7)
  expect_equal(nchar(dh_random(shorten = TRUE)), 4)

  expect_error(dh_random("x"))
  expect_error(dh_random(1))
  expect_error(dh_random(list()))
  expect_error(dh_random(data.frame()))
  expect_error(dh_random(matrix()))

})

# dh_graph
test_that("a graph is produced for user's hex", {

  expect_output(
    dh_graph("#fff"),
    "^\\#FFF.*R.*H 2.*G.*H 2.*B.*H 2.*S.*L"
  )

  expect_equal(capture.output(dh_graph("#fff", text = "hello"))[1], "hello")

  expect_length(capture.output(dh_graph("#fff")), 7)
  expect_length(capture.output(dh_graph("#fff", adorn_h = FALSE)), 7)
  expect_length(capture.output(dh_graph("#fff", adorn_s = FALSE)), 6)
  expect_length(capture.output(dh_graph("#fff", adorn_l = FALSE)), 6)

  expect_error(dh_graph("#fffffff"))
  expect_error(dh_graph("x"))
  expect_error(dh_graph(1))
  expect_error(dh_graph(list()))
  expect_error(dh_graph(data.frame()))
  expect_error(dh_graph(matrix()))

})

# dh_guide
test_that("guides are printed", {

  expect_output(dh_guide(type = "H"), "^red.*R.*H 3.*grey")
  expect_output(dh_guide(type = "S"), "^saturated.*R.*G.*B.*S.*grey")
  expect_output(dh_guide(type = "L"), "^light.*R.*G.*B.*L.*dark")

  expect_length(capture.output(dh_guide(type = "H")), 65)
  expect_length(capture.output(dh_guide(type = "S")), 24)
  expect_length(capture.output(dh_guide(type = "L")), 18)

  expect_error(dh_guide("x"))
  expect_error(dh_guide(1))
  expect_error(dh_guide(list()))
  expect_error(dh_guide(data.frame()))
  expect_error(dh_guide(matrix()))

})

# dh_solve
test_that("solved output is generated", {


  expect_type(
    dh_solve("#fff", graphs = FALSE, swatch = FALSE),
    "character"
  )

  expect_equal(
    dh_solve("#fff", graphs = FALSE, swatch = FALSE),
    "light grey grey"
  )

  expect_output(
    dh_solve("#fff", graphs = TRUE, swatch = FALSE),
    paste0(
      "^Result: #FFF is 'light grey grey'.*",
      "input code: #FFF.*",
      "R.*H 2.*G.*H 2.*B.*H 2.*S.*L.*hue.*saturation.*lightness"
    )
  )

  expect_length(
    capture.output(dh_solve("#fff", graphs = FALSE, swatch = FALSE)),
    1
  )

  expect_length(
    capture.output(dh_solve("#fff", graphs = TRUE, swatch = FALSE)),
    26
  )

  expect_error(dh_solve("#fffffff"))
  expect_error(dh_solve("x"))
  expect_error(dh_solve(1))
  expect_error(dh_solve(list()))
  expect_error(dh_solve(data.frame()))
  expect_error(dh_solve(matrix()))

})

# dh_swatch
test_that("swatch of colour is plotted", {

  expect_error(dh_swatch("#fffffff"))
  expect_error(dh_swatch("x"))
  expect_error(dh_swatch(1))
  expect_error(dh_swatch(list()))
  expect_error(dh_swatch(data.frame()))
  expect_error(dh_swatch(matrix()))

})
