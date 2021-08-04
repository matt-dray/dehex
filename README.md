
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

⚠ The package is very much a work-in-progress and things may change or
break at any time.

The package functions follow the five steps in [David DeSandro’s dotCSS
2018 talk](https://metafizzy.co/blog/read-color-hex-codes/) ([thanks
Maëlle](https://twitter.com/ma_salmon/status/1420726230194794496?s=20)):

1.  Three-digit shorthand
2.  Bar chart
3.  Hue from shape
4.  Lightness from total
5.  Saturation from range

You simplify your hex code, convert it to a bar chart of its RGB values,
and then assess that for hue, lightness and saturation. The result is a
colour name in the form ‘dark muted azure’, for example

## Install

Install the development version from GitHub with:

``` r
remotes::install_github("matt-dray/dehex")
```

## Three-digit shorthand

First, convert a full six-character hex code to its three-character
shortcode. This takes the first value from each pair of characters.

``` r
long <- "#E69DFB"
short <- dehex::dh_shorten(long)
short
# [1] "#E9F"
```

You could also generate a random one with `dh_random()`.

## Bar chart

Use `dh_graph()` to print to the console a bar chart that shows the
decimal values of red (R), green (G) and blue (B) for your shortened hex
code. The RGB columns are coloured in RStudio, thanks to [the {crayon}
package](https://github.com/r-lib/crayon).

``` r
dehex::dh_graph(short)
# #E9F
# R ███████████████░
# G ██████████░░░░░░
# B ████████████████
# S ░░░░░░░░░███████
# L ░░░░░░░░░░░░░█░░
```

Note that the chart is adorned by extra information that tells you
something about the lightness (L, i.e. the RGB average) and saturation
(S, i.e. the RGB range). Set the `adorn_*` arguments to `FALSE` to
remove these.

## Hue from shape

To assess the hue of your hex code, compare its RGB profile from
`dh_graph()` to the guide provided by `dh_guide("H")`. The exact amounts
don’t matter; it’s the relative values of RGB that we care about.

``` r
dehex::dh_guide("H")
# Red (primary)
# R ████████████████
# G █░░░░░░░░░░░░░░░
# B █░░░░░░░░░░░░░░░
# 
# Green (primary)
# R █░░░░░░░░░░░░░░░
# G ████████████████
# B █░░░░░░░░░░░░░░░
# 
# Blue (primary)
# R █░░░░░░░░░░░░░░░
# G █░░░░░░░░░░░░░░░
# B ████████████████
# 
# Yellow (secondary)
# R ████████████████
# G ████████████████
# B █░░░░░░░░░░░░░░░
# 
# Cyan (secondary)
# R █░░░░░░░░░░░░░░░
# G ████████████████
# B ████████████████
# 
# Magenta (secondary)
# R ████████████████
# G █░░░░░░░░░░░░░░░
# B ████████████████
# 
# Orange (tertiary)
# R ████████████████
# G █████████░░░░░░░
# B █░░░░░░░░░░░░░░░
# 
# Chartreuse (tertiary)
# R █████████░░░░░░░
# G ████████████████
# B █░░░░░░░░░░░░░░░
# 
# Aquamarine (tertiary)
# R █░░░░░░░░░░░░░░░
# G ████████████████
# B █████████░░░░░░░
# 
# Azure (tertiary)
# R █░░░░░░░░░░░░░░░
# G █████████░░░░░░░
# B ████████████████
# 
# Violet (tertiary)
# R █████████░░░░░░░
# G █░░░░░░░░░░░░░░░
# B ████████████████
# 
# Rose (tertiary)
# R ████████████████
# G █░░░░░░░░░░░░░░░
# B █████████░░░░░░░
# 
# Grey
# R █████████░░░░░░░
# G █████████░░░░░░░
# B █████████░░░░░░░
```

## Lightness from total

To assess the lightness of your hex code, compare its RGB profile from
`dh_graph()` to the guide provided by `dh_guide("L")`. A higher total
RGB means it’s lighter in colour, but I’ve chosen to show the mean value
as a guide.

``` r
dehex::dh_guide("L")
# Light
# R ████████████████
# G ███████████████░
# B ██████████████░░
# L ░░░░░░░░░░░░░░█░
# 
# Middle
# R ██████████░░░░░░
# G █████████░░░░░░░
# B ████████░░░░░░░░
# L ░░░░░░░░█░░░░░░░
# 
# Dark
# R ████░░░░░░░░░░░░
# G ███░░░░░░░░░░░░░
# B ██░░░░░░░░░░░░░░
# L ░░█░░░░░░░░░░░░░
```

## Saturation from range

To assess the saturation of your hex code, compare its RGB profile from
`dh_graph()` to the guide provided by `dh_guide("L")`. A larger RGB
range means a more saturated colour.

``` r
dehex::dh_guide("S")
# Saturated
# R ████████████████
# G █████████░░░░░░░
# B █░░░░░░░░░░░░░░░
# S ████████████████
# 
# Washed
# R ██████████████░░
# G █████████░░░░░░░
# B ███░░░░░░░░░░░░░
# S ░░████████████░░
# 
# Muted
# R ███████████░░░░░
# G █████████░░░░░░░
# B ██████░░░░░░░░░░
# S ░░░░░██████░░░░░
# 
# Grey
# R █████████░░░░░░░
# G █████████░░░░░░░
# B █████████░░░░░░░
# S ░░░░░░░░█░░░░░░░
```

## The solution

You can learn how to describe your hex code’s colour by comparing its
RGB profile against profiles that describe different hues, saturation
and lightness. So our example of \#E9F is ‘light washed purple’.

TODO: We probably need a `dh_solve()` function that output the ‘correct’
answer, which prints the descriptive colour name and each of the
relevant HSL charts. It might be good to output a sample of the colour
to a plot as well (both the three- and original six-digit hex codes).

## Code of Conduct

Please note that the {dehex} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
