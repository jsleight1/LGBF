#' Launch shiny application
#' @param ... Passed to shinyApp.
#' @export
LGBF <- function(...) {
    combined_data <- process_data()

    indicator_areas <- combined_data %>%
        group_split(.data[["Indicators_Information_ServiceArea"]]) %>%
        map(generate_indicator_areas)

    summary_metrics <- generate_summary_metrics(combined_data)

    ui <- dashboardPage(
        dashboardHeader(title = "LGBF Dashboard"),
        dashboardSidebar(
            generate_sidebar(indicator_areas)
        ),
        dashboardBody(
            generate_body_items(indicator_areas, summary_metrics)
        )
    )
    server <- function(input, output) {
        walk(indicator_areas, visual_server)
        walk(indicator_areas, datatable_server)
    }

    shinyApp(ui, server, ...)
}