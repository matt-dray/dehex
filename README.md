
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

1.  Simplify the hex code
2.  Create a bar chart
3.  Assess hue from graph ‘shape’
4.  Assess lightness from total
5.  Assess saturation from range

Install the development version from GitHub with:

``` r
remotes::install_github("matt-dray/dehex")
```

First, convert a full six-character hex code to its three-character
shortcode. We can generate a random one for our purposes.

``` r
set.seed(352)
long <- dehex::dh_random()
long
# [1] "#9125CB"

short <- dehex::dh_shorten(long)
short
# [1] "#92C"
```

(You could just pass the argument `shorten = TRUE` to `dh_random()` to
get a random three-character hex code, but I wanted to show you
`sh_shorten()` in action.)

Then print a bar chart to your console that describes the relative
amounts of red, green and blue described by the shortcode:

``` r
dehex::dh_graph(short)
# #92C
# R █████████░░░░░░
# G ██░░░░░░░░░░░░░
# B ████████████░░░
# S ░███████████░░░
# L ░░░░░░░█░░░░░░░
```

It also adds a couple more bars to show you information about the
saturation (S, i.e. the range of RGB values) and lightness (L, the
‘average’ RGB value). You can set the `adorn_*` arguments to `FALSE` if
you just want the RGB bars.

Your IDE (at least RStudio) will show the RGB columns as their
respective colours, thanks to [the {crayon}
package](https://github.com/r-lib/crayon).

You can print the 12 hues (plus grey) and assess the one with the most
similar RGB distribution to yours:

``` r
dehex::dh_guide("H")
# Red (primary)
# R ███████████████
# G ░░░░░░░░░░░░░░░
# B ░░░░░░░░░░░░░░░
# 
# Green (primary)
# R ░░░░░░░░░░░░░░░
# G ███████████████
# B ░░░░░░░░░░░░░░░
# 
# Blue (primary)
# R ░░░░░░░░░░░░░░░
# G ░░░░░░░░░░░░░░░
# B ███████████████
# 
# Yellow (secondary)
# R ███████████████
# G ███████████████
# B ░░░░░░░░░░░░░░░
# 
# Cyan (secondary)
# R ░░░░░░░░░░░░░░░
# G ███████████████
# B ███████████████
# 
# Magenta (secondary)
# R ███████████████
# G ░░░░░░░░░░░░░░░
# B ███████████████
# 
# Orange (tertiary)
# R ███████████████
# G ████████░░░░░░░
# B ░░░░░░░░░░░░░░░
# 
# Chartreuse (tertiary)
# R ████████░░░░░░░
# G ███████████████
# B ░░░░░░░░░░░░░░░
# 
# Aquamarine (tertiary)
# R ░░░░░░░░░░░░░░░
# G ███████████████
# B ████████░░░░░░░
# 
# Azure (tertiary)
# R ░░░░░░░░░░░░░░░
# G ████████░░░░░░░
# B ███████████████
# 
# Violet (tertiary)
# R ████████░░░░░░░
# G ░░░░░░░░░░░░░░░
# B ███████████████
# 
# Rose (tertiary)
# R ███████████████
# G ░░░░░░░░░░░░░░░
# B ████████░░░░░░░
# 
# Grey
# R ████████░░░░░░░
# G ████████░░░░░░░
# B ████████░░░░░░░
```

You can also view charts for the three broad lightness (L) categories.
The higher the mean value, the lighter the colour is. By default, a
marker is added to the chart to indicate the mean RGB value, which can
help decide how light the colour is.

``` r
dehex::dh_guide("L")
# Light
# R ███████████████
# G ██████████████░
# B █████████████░░
# L ░░░░░░░░░░░░░█░
# 
# Middle
# R █████████░░░░░░
# G ████████░░░░░░░
# B ███████░░░░░░░░
# L ░░░░░░░█░░░░░░░
# 
# Dark
# R ███░░░░░░░░░░░░
# G ██░░░░░░░░░░░░░
# B █░░░░░░░░░░░░░░
# L ░█░░░░░░░░░░░░░
```

You can also compare to the four broad saturation (S) categories. A
greater range in RGB values means it’s more saturated. By default, a bar
is added to show the range of the RGB values.

``` r
dehex::dh_guide("S")
# Saturated
# R ███████████████
# G ████████░░░░░░░
# B ░░░░░░░░░░░░░░░
# S ███████████████
# 
# Washed
# R █████████████░░
# G ████████░░░░░░░
# B ██░░░░░░░░░░░░░
# S ░████████████░░
# 
# Muted
# R ██████████░░░░░
# G ████████░░░░░░░
# B █████░░░░░░░░░░
# S ░░░░██████░░░░░
# 
# Grey
# R ████████░░░░░░░
# G ████████░░░░░░░
# B ████████░░░░░░░
# S ░░░░░░░█░░░░░░░
```

(Additional functionality to be added.)

## Code of Conduct

Please note that the {dehex} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
