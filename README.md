
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {dehex}

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![R-CMD-check](https://github.com/matt-dray/dehex/workflows/R-CMD-check/badge.svg)](https://github.com/matt-dray/dehex/actions)
[![Codecov test
coverage](https://codecov.io/gh/matt-dray/dehex/branch/main/graph/badge.svg)](https://codecov.io/gh/matt-dray/dehex?branch=main)
<!-- badges: end -->

‘Dehex’, from [Wiktionary](https://en.wiktionary.org/wiki/dehex):

> To remove a hex (a spell, especially an evil spell).

An R package containing simple functions to help me train myself to
quickly ‘read’ a colour from its hex code. I’m colourblind (a
deuteranope) so this might be a useful skill.

Install the development version from GitHub with:

``` r
remotes::install_github("matt-dray/dehex")
```

The package functions follow the five steps in [David DeSandro’s dotCSS
2018 talk](https://metafizzy.co/blog/read-color-hex-codes/):

1.  Simplify the hex code ✓
2.  Create a bar chart ✓
3.  Assess hue from shape
4.  Assess lightness from total
5.  Assess saturation from range

First, convert a full six-character hex code to its three-character
shortcode:

``` r
long <- "#C0FFEE"
short <- dehex::dh_shorten(long)
short
# [1] "#CFE"
```

Then print a bar chart to your console that describes the relative
amounts of red, green and blue described by the shortcode:

``` r
dehex::dh_graph(short)
# #CFE
# R ████████████░░░
# G ███████████████
# B ██████████████░
```

Your IDE will likely show the RGB columns as their respective colours,
thanks to [the {crayon} package](https://github.com/r-lib/crayon).

## Code of Conduct

Please note that the {dehex} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
