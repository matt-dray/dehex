test_that("shortening works", {
  expect_error(dh_shorten("x"))
  expect_equal(nchar(dh_shorten("#ffffff")), 4)
  expect_equal(nchar(dh_shorten("#fff")), 4)
  expect_equal(length(dh_shorten("#ffffff")), 1)
  expect_equal(class(dh_shorten("#ffffff")), "character")
})

test_that("graph works", {
  expect_error(dh_graph("x"))
  expect_equal(class(dh_graph("#fff")) == "NULL")
})
