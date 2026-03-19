#' Launch shiny application
#' @param ... Passed to shinyApp.
#' @export
LGBF <- function(...) {
  combined_data <- load_lgbf_data()

  indicator_areas <- combined_data %>%
    group_split(.data[["Indicators_Information_ServiceArea"]]) %>%
    map(generate_indicator_areas)
  names(indicator_areas) <- map_chr(indicator_areas, id)

  summary_metrics <- generate_summary_metrics(combined_data)

  # ui <- dashboardPage(
  #     dashboardHeader(title = "LGBF Dashboard"),
  #     dashboardSidebar(
  #         generate_sidebar(indicator_areas)
  #     ),
  #     dashboardBody(
  #         generate_body_items(indicator_areas, summary_metrics)
  #     )
  # )
  # server <- function(input, output) {
  #     walk(indicator_areas, visual_server)
  #     walk(indicator_areas, datatable_server)
  # }

  ui <- page_navbar(
    theme = bs_theme(
      brand = system.file("www", "_brand.yml", package = "LGBF")
    ),
    title = "LGBF Dashboard",
    id = "main",
    nav_panel(
      bs_icon("house-fill"),
      layout_sidebar(
        sidebar = do.call(
          navset_pill_list,
          c(
            list(
              id = "sidebar",
              widths = c(12, 1),
              well = FALSE,
              nav_panel("Introduction")
            ),
            unname(lapply(indicator_areas, function(i) {
              nav_panel(id(i))
            }))
          )
        ),
        uiOutput("main_content")
      )
    ),
    nav_spacer(),
    nav_item(
      span(
        href = "https://www.linkedin.com/in/jack-sleight-461a6699/",
        target = "_blank",
        bs_icon("linkedin"),
        class = "navbar-link"
      )
    ),
    nav_item(
      span(
        href = "https://github.com/jsleight1/LGBF",
        target = "_blank",
        bs_icon("github"),
        class = "navbar-link"
      )
    ),
    nav_item(
      span(
        glue("v{as.character(packageVersion('LGBF'))}"),
        class = "navbar-link"
      )
    ),
    footer = div(
      class = "footer",
      "Created by Jack Sleight"
    )
  )

  server <- function(input, output) {
    observe({
      output[["main_content"]] <- renderUI({
        log_info(glue("Selected {input[['sidebar']]} panel"))
        c(
          list("Introduction" = intro_ui(summary_metrics)),
          lapply(indicator_areas, visual_ui)
        )[[input[["sidebar"]]]]
      })
    }) |>
      bindEvent(input[["sidebar"]])

    walk(indicator_areas, visual_server)
  }

  shinyApp(ui, server, ...)
}
