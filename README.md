
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
‘read’ a colour from its hex code. I’m colourblind (a deuteranope) so
this might be a useful skill.

## The DeSandro method

[David DeSandro gave a talk at dotCSS
2018](https://metafizzy.co/blog/read-color-hex-codes/) about ‘reading’
colour hex codes by eye to get a colour like dark saturated orange’
([thanks
Maëlle](https://twitter.com/ma_salmon/status/1420726230194794496?s=20)).

There are five steps:

1.  Simplify from a six- to a three-digit hex code
2.  Create an RGB bar chart from the short hex code
3.  Assess hue from the chart ‘shape’
4.  Assess saturation from the RGB range
5.  Assess lightness from the RGB total

This package contains functions that guide you through that process and
can ‘solve’ the hex code for you.

## Install

You can install the development version from GitHub.

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
code. The RGB columns are printed in colour in RStudio, thanks to [the
{crayon} package](https://github.com/r-lib/crayon).

``` r
dehex::dh_graph(short)
# #E9F
# R ███████████████░ H 2
# G ██████████░░░░░░ H 1
# B ████████████████ H 3
# S ░░░░░░░░░███████
# L ░░░░░░░░░░░░░█░░
```

Note that the chart is adorned by extra information that tells you
something about the hue (H, i.e. the relative ‘rank’ of each RGB
channel), saturation (S, i.e. the RGB range) and lightness (L, i.e. the
RGB average). You can remove these guides by setting the `adorn_*`
arguments to `FALSE`.

The idea is to compare this to a set of guides that provide rough
categorisations of hue, saturation and lightness to generate an English
phrase.

## Guides

### Hue from shape

To assess the hue of your hex code, compare its RGB profile from
`dh_graph()` to the guide provided by `dh_guide("H")`. The exact amounts
don’t matter; it’s the relative values of RGB that we care about. For
this reason, the end of each bar shows you the relative `rank()` of each
channel (smallest value is ranked ‘1’ and so on).

<details>
<summary>
Click to see the hue guides
</summary>

``` r
dehex::dh_guide("H")
# red
# R ████████████████ H 3
# G █░░░░░░░░░░░░░░░ H 1.5
# B █░░░░░░░░░░░░░░░ H 1.5
# 
# green
# R █░░░░░░░░░░░░░░░ H 1.5
# G ████████████████ H 3
# B █░░░░░░░░░░░░░░░ H 1.5
# 
# blue
# R █░░░░░░░░░░░░░░░ H 1.5
# G █░░░░░░░░░░░░░░░ H 1.5
# B ████████████████ H 3
# 
# yellow
# R ████████████████ H 2.5
# G ████████████████ H 2.5
# B █░░░░░░░░░░░░░░░ H 1
# 
# cyan
# R █░░░░░░░░░░░░░░░ H 1
# G ████████████████ H 2.5
# B ████████████████ H 2.5
# 
# magenta
# R ████████████████ H 2.5
# G █░░░░░░░░░░░░░░░ H 1
# B ████████████████ H 2.5
# 
# orange
# R ████████████████ H 3
# G █████████░░░░░░░ H 2
# B █░░░░░░░░░░░░░░░ H 1
# 
# chartreuse
# R █████████░░░░░░░ H 2
# G ████████████████ H 3
# B █░░░░░░░░░░░░░░░ H 1
# 
# aquamarine
# R █░░░░░░░░░░░░░░░ H 1
# G ████████████████ H 3
# B █████████░░░░░░░ H 2
# 
# azure
# R █░░░░░░░░░░░░░░░ H 1
# G █████████░░░░░░░ H 2
# B ████████████████ H 3
# 
# violet
# R █████████░░░░░░░ H 2
# G █░░░░░░░░░░░░░░░ H 1
# B ████████████████ H 3
# 
# rose
# R ████████████████ H 3
# G █░░░░░░░░░░░░░░░ H 1
# B █████████░░░░░░░ H 2
# 
# grey
# R █████████░░░░░░░ H 2
# G █████████░░░░░░░ H 2
# B █████████░░░░░░░ H 2
```

</details>

### Saturation from range

To assess the saturation of your hex code, compare its RGB profile from
`dh_graph()` to the guide provided by `dh_guide("S")`. A larger RGB
range means a more saturated colour.

<details>
<summary>
Click to see the saturation guides
</summary>

``` r
dehex::dh_guide("S")
# saturated
# R ████████████████
# G █████████░░░░░░░
# B █░░░░░░░░░░░░░░░
# S ████████████████
# 
# washed
# R █████████████░░░
# G █████████░░░░░░░
# B ████░░░░░░░░░░░░
# S ░░░██████████░░░
# 
# muted
# R ██████████░░░░░░
# G █████████░░░░░░░
# B ███████░░░░░░░░░
# S ░░░░░░████░░░░░░
# 
# grey
# R █████████░░░░░░░
# G █████████░░░░░░░
# B █████████░░░░░░░
# S ░░░░░░░░█░░░░░░░
```

</details>

### Lightness from total

To assess the lightness of your hex code, compare its RGB profile from
`dh_graph()` to the guide provided by `dh_guide("L")`. A higher total
RGB means it’s lighter in colour, but I’ve chosen to show the mean value
as a guide.

<details>
<summary>
Click to see the lightness guides
</summary>

``` r
dehex::dh_guide("L")
# light
# R ████████████████
# G ███████████████░
# B ██████████████░░
# L ░░░░░░░░░░░░░░█░
# 
# middle
# R ██████████░░░░░░
# G █████████░░░░░░░
# B ████████░░░░░░░░
# L ░░░░░░░░█░░░░░░░
# 
# dark
# R ████░░░░░░░░░░░░
# G ███░░░░░░░░░░░░░
# B ██░░░░░░░░░░░░░░
# L ░░█░░░░░░░░░░░░░
```

</details>

## The solution

Luckily, `dh_solve()` returns the ‘answer’ for your colour. So, for our
input \#E9F, the ‘answer’ is:

``` r
dehex::dh_solve(short, graphs = FALSE)
# [1] "light washed violet"
```

Of course, you could just use this function to get a simple way of
communicating colour from hex codes without learning how to do it by
‘reading’ a hex code yourself.

You can also ask to return the relevant bar charts that best describe
the hue, saturation and lightness that led to the result.

``` r
dehex::dh_solve(short)
# #E9F is light washed violet 
# 
# input code: #E9F
# R ███████████████░ H 2
# G ██████████░░░░░░ H 1
# B ████████████████ H 3
# S ░░░░░░░░░███████
# L ░░░░░░░░░░░░░█░░
# 
# hue: violet
# R █████████░░░░░░░ H 2
# G █░░░░░░░░░░░░░░░ H 1
# B ████████████████ H 3
# 
# saturation: washed
# R █████████████░░░
# G █████████░░░░░░░
# B ████░░░░░░░░░░░░
# S ░░░██████████░░░
# 
# lightness: light
# R ████████████████
# G ███████████████░
# B ██████████████░░
# L ░░░░░░░░░░░░░░█░
```

## Code of Conduct

Please note that the {dehex} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
