
#' A Shiny App Walkthrough to Read Colour Hex Codes
#'
#' Rather than manually typing functions of {dehex} into your console, you can
#' instead run this Shiny app to be guided through the process of learning to
#' read a random colour hex code.
#'
#' @return Opens a Shiny app.
#' @export
#'
#' @examples \dontrun{dh_app()}
dh_app <- function() {

  ui <- shiny::fluidPage(

    # style ----
    theme = bslib::bs_theme(
      bg = "#111",
      fg = "#DDD",
      primary = "#F00",
      secondary = "#00F",
      base_font = bslib::font_google("Overpass Mono"),
      code_font = bslib::font_google("Overpass Mono")
    ),

    shiny::tags$style(shiny::HTML("#title{font-size:50px;}")),
    shiny::tags$style(shiny::HTML("#title,h2,h3{color:#0F0;}")),

    # title ----
    shiny::h1(id = "title", "Learn to read colour hex codes"),
    shiny::p(
      "A", a(href = "https://github.com/matt-dray/dehex", "{dehex}"), "demo following",
      a(href = "https://metafizzy.co/blog/read-color-hex-codes/", "David DeSandro's method")
    ),
    shiny::br(),

    shiny::sidebarLayout(

      shiny::sidebarPanel(

        # start ----

        shiny::p("Generate a random code then follow the steps in the tabs",),
        shiny::p(shiny::actionButton("action", label = "Generate")),
        shiny::tags$span(shiny::textOutput("hex_long"), style = "font-size:50px;")

      ),

      shiny::mainPanel(

        shiny::tabsetPanel(

          type = "tabs",

          # tab 1 ----
          shiny::tabPanel(
            title = "1. Simplify",
            shiny::h3("Task"),
            shiny::p("Simplify the colour hex code to three values."),
            shiny::h3("Explanation"),
            shiny::tags$div(
              shiny::tags$ul(
                shiny::tags$li("There are three pairs of alphanumeric characters in a colour hex code"),
                shiny::tags$li("The pairs represent red, green and blue (RGB), so #A1B2C3 has A1 for R, B2 for G and C3 for B)"),
                shiny::tags$li("The first value of each pair contains enough information for our needs, so #A1B2C3 can be simplified to #ABC")
              )
            ),
            shiny::h3("Hints"),
            shiny::HTML(
              paste(
                "<p><details><summary style='color:red'>Show the three-digit code</summary>",
                shiny::tags$span(shiny::textOutput("hex_short"), style = "font-size:50px;"),
                "</details></p>"
              )
            ),
            "Go to David's", shiny::a(href = "https://speakerdeck.com/desandro/read-color-hex-codes?slide=21", "relevant slide")
          ),

          # tab 2 ----
          shiny::tabPanel(
            title = "2. Chart",
            shiny::h3("Task"),
            shiny::p("Convert the simplified hex code to a bar chart of decimal values for red, green and blue (RGB)."),
            shiny::h3("Explanation"),
            shiny::tags$div(
              shiny::tags$ul(
                shiny::tags$li("The alphanumeric values are in hexadecimal code, taking values of 0 to 9 then A to F, which represent 10 to 15 in decimal"),
                shiny::tags$li("So you can convert your shortened hex code to decimal values  (#ABC encodes 10, 11 and 12 for R, G and B)"),
                shiny::tags$li("Imagine a bar chart of these values to get a sense of the RGB 'profile' of your simplified hex code")
              )
            ),
            shiny::h3("Hints"),
            shiny::HTML(
              paste(
                "<p><details><summary style='color:red'>Show the RGB chart</summary>",
                "Remember: the bars go from 0 to 15, encoding hexadecimal RGB values of 0 to 9 then A to F.",
                shiny::verbatimTextOutput("hex_graph_simple"),
                "</details></p>"
              )
            ),
            "Go to David's", shiny::a(href = "https://speakerdeck.com/desandro/read-color-hex-codes?slide=29", "relevant slide")
          ),

          # tab 3 ----
          shiny::tabPanel(
            title = "3. Hue",
            shiny::h3("Task"),
            shiny::p("Select the hue with the most similar RGB profile to your simplified hex code."),
            shiny::h3("Explanation"),
            shiny::tags$div(
              shiny::tags$ul(
                shiny::tags$li("Hue is basically the name of a colour, like 'red'"),
                shiny::tags$li("First, rank the RGB values of your simplified hex code (e.g. R is largest in #F11, with G and B tied beneath)"),
                shiny::tags$li("Then compare these ranks against RGB ranks for a set of named hues")
              )
            ),
            shiny::h3("Hints"),
            shiny::HTML(
              paste(
                "<p><details><summary style='color:red'>Show the RGB chart with added hue guide</summary>",
                "The 'H' at the end of the bar helps show the RGB ranks (1 is smallest, ties are possible).",
                shiny::verbatimTextOutput("hex_graph_h"),
                "</details></p>"
              )
            ),
            shiny::HTML(
              paste(
                "<p><details><summary style='color:red'>Show RGB charts for each hue</summary>",
                "Which RGB hue-rank profile best matches the one for your shortened hex code?",
                "To keep it simple, we're only using hue-rank profiles for red, green, blue and their secondary and tertiary mixtures (grey is aspecial case where RGB values are all tied).",
                shiny::verbatimTextOutput("hex_guide_h"),
                "</details></p>"
              )
            ),
            "Go to David's", shiny::a(href = "https://speakerdeck.com/desandro/read-color-hex-codes?slide=43", "relevant slide")
          ),

          # tab 4 ----
          shiny::tabPanel(
            title = "4. Saturation",
            shiny::h3("Task"),
            shiny::p("Select the saturation level that has the closest RGB range to your shortened hex code."),
            shiny::h3("Explanation"),
            shiny::tags$div(
              shiny::tags$ul(
                shiny::tags$li("Saturation is like the 'intensity' of a colour"),
                shiny::tags$li("Colour intensity is given by the difference between the smallest and largest RGB values encoded in the hex code"),
                shiny::tags$li("The greater the range of the RGB values, the more saturated"),
              )
            ),
            shiny::h3("Hints"),
            shiny::HTML(
              paste(
                "<p><details><summary style='color:red'>Show the RGB profile with added saturation guide</summary>",
                "The 'S' column has been added to help you see the range of RGB values.",
                shiny::verbatimTextOutput("hex_graph_s"),
                "</details></p>"
              )
            ),
            shiny::HTML(
              paste(
                "<p><details><summary style='color:red'>Show RGB charts for each saturation level</summary>",
                "Which of these RGB ranges best matches that of your shortened hex code? To keep things simple, we'll only look at three intensities (plus grey, which has zero range).",
                shiny::verbatimTextOutput("hex_guide_s"),
                "</details></p>"
              )
            ),
            "Go to David's", shiny::a(href = "https://speakerdeck.com/desandro/read-color-hex-codes?slide=51", "relevant slide")
          ),

          # tab 5 ----
          shiny::tabPanel(
            title = "5. Lightness",
            shiny::h3("Task"),
            shiny::p("Select the lightness value that has the closest mean RGB value to your shortened hex code."),
            shiny::h3("Explanation"),
            shiny::tags$div(
              shiny::tags$ul(
                shiny::tags$li("Lightness is as it sounds: how light or dark is the colour?"),
                shiny::tags$li("We can assess this by looking at the average of the RGB values"),
                shiny::tags$li("The higher the value, the lighter the colour"),
              )
            ),
            shiny::h3("Hints"),
            shiny::HTML(
              paste(
                "<p><details><summary style='color:red'>Show the RGB chart with added lightness guide</summary>",
                "The 'L' column has been added to help you see the average of the RGB values.",
                shiny::verbatimTextOutput("hex_graph_l"),
                "</details></p>"
              )
            ),
            shiny::HTML(
              paste(
                "<p><details><summary style='color:red'>Show RGB charts for each lightness level</summary>",
                "Which of these has the most similar average RGB value to your shortened hex code's average?",
                shiny::verbatimTextOutput("hex_guide_l"),
                "</details></p>"
              )
            ),
            "Go to David's", shiny::a(href = "https://speakerdeck.com/desandro/read-color-hex-codes?slide=47", "relevant slide")
          ),

          # tab 6 ----
          shiny::tabPanel(
            title = "6. Solve",
            shiny::h3("Task"),
            shiny::p("Put the hue, saturation and lightness levels together to get the rough colour name."),
            shiny::h3("Hints"),
            shiny::HTML(
              paste(
                "<p><details><summary style='color:red'>Show RGB charts for best matches</summary>",
                shiny::verbatimTextOutput("hex_solve_graphs"),
                "</details></p>"
              )
            ),
            shiny::HTML(
              paste(
                "<p><details><summary style='color:red'>Show the answer</summary>",
                shiny::tags$span(textOutput("hex_solve"), style = "font-size:50px;"),
                shiny::plotOutput("hex_swatch", width = "100%", height = 100),
                "</details></p>"
              )
            ),
            "Go to David's ", shiny::a(href = "https://speakerdeck.com/desandro/read-color-hex-codes?slide=62", "relevant slide")
          )  # tabPanel
        )  # tabsetPanel
      )  # mainPanel
    )  # sidebarLayout
  )  # fluidPage



  server <- function(input, output) {

    # React

    v <- reactiveValues(
      hex_long = NULL
    )

    observeEvent(input$action, {
      v$hex_random <- dehex::dh_random()
    })

    # Hex codes

    output$hex_long <- renderText({
      v$hex_random
    })

    error_message <- "Click 'Generate'"

    output$hex_short <- renderText({
      validate(need(v$hex_random, error_message))
      dehex::dh_shorten(v$hex_random)
    })

    # HSL guides

    output$hex_guide_h <- renderPrint({
      validate(need(v$hex_random, error_message))
      dehex::dh_guide("H", crayon = FALSE)
    })

    output$hex_guide_s <- renderPrint({
      validate(need(v$hex_random, error_message))
      dehex::dh_guide("S", crayon = FALSE)
    })

    output$hex_guide_l <- renderPrint({
      validate(need(v$hex_random, error_message))
      dehex::dh_guide("L", crayon = FALSE)
    })

    # Graphs

    output$hex_graph_simple <- renderPrint({
      validate(need(v$hex_random, error_message))
      dehex::dh_graph(
        dehex::dh_shorten(v$hex_random),
        adorn_h = FALSE,
        adorn_s = FALSE,
        adorn_l = FALSE,
        crayon = FALSE
      )
    })

    output$hex_graph_h <- renderPrint({
      validate(need(v$hex_random, error_message))
      dehex::dh_graph(
        dehex::dh_shorten(v$hex_random),
        adorn_s = FALSE,
        adorn_l = FALSE,
        crayon = FALSE
      )
    })

    output$hex_graph_s <- renderPrint({
      validate(need(v$hex_random, error_message))
      dehex::dh_graph(
        dehex::dh_shorten(v$hex_random),
        adorn_h = FALSE,
        adorn_l = FALSE,
        crayon = FALSE
      )
    })

    output$hex_graph_l <- renderPrint({
      validate(need(v$hex_random, error_message))
      dehex::dh_graph(
        dehex::dh_shorten(v$hex_random),
        adorn_h = FALSE,
        adorn_s = FALSE,
        crayon = FALSE
      )
    })

    output$hex_graph <- renderPrint({
      validate(need(v$hex_random, error_message))
      dehex::dh_graph(
        dehex::dh_shorten(v$hex_random),
        crayon = FALSE
      )
    })

    # Solution

    output$hex_solve <- renderText({
      validate(need(v$hex_random, error_message))
      dehex::dh_solve(v$hex_random)
    })

    output$hex_solve_graphs <- renderPrint({
      validate(need(v$hex_random, error_message))
      invisible(dehex::dh_solve(v$hex_random, graphs = TRUE, crayon = FALSE))
    })

    # Colour sample

    output$hex_swatch <- renderPlot({
      validate(need(v$hex_random, error_message))
      dehex::dh_swatch(dehex::dh_shorten(v$hex_random))
    }, width = 320, height = 100)

  }

  shinyApp(ui, server)

}
