
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dehex

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
<!-- badges: end -->

‘Dehex’, from [Wiktionary](https://en.wiktionary.org/wiki/dehex):

> To remove a hex (a spell, especially an evil spell).

This is an R package containing simple functions to help me train myself
to quickly ‘read’ a colour from its hex code. I’m colourblind (a
deuteranope) and would like a method to help me interpret these codes by
sight alone.

I’m following [David DeSandro’s dotCSS 2018
talk](https://metafizzy.co/blog/read-color-hex-codes/): ‘Read colour hex
codes’. There are five steps in DeSandro’s method (a tick means there’s
a function):

1.  Simplify the hex code ✓
2.  Create a bar chart ✓
3.  Assess hue from shape
4.  Assess lightness from total
5.  Assess saturation from range

Install the development version from GitHub with:

``` r
remotes::install_github("matt-dray/dehex")
```

First, convert a full six-character hex code to its three-character
shortcode:

``` r
long <- "#C0FFEE"
short <- dehex::dh_shorten(long)
short
[1] "#CFE"
```

Then print a bar chart to your console that describes the relative
amounts of red, green and blue, given their hexadecimal values in the
shortcode:

``` r
dehex::dh_graph(short)
#CFE
R ████████████░░░
G ███████████████
B ██████████████░
```

Your IDE will likely show the RGB as their respective colours, thanks to
[the {crayon} package](https://github.com/r-lib/crayon).

## Code of Conduct

Please note that the {dehex} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
