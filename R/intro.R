intro_ui <- function(id, x, ...) {
    tabItem(
        tabName = id,
        fluidRow(
            box(
                title = "Introduction",
                width = 12,
                status = "primary",
                solidHeader = TRUE,
                h3("Welcome to the LGBF dashboard"),
                h4("This dashboard presents a summary of local authority indicator
                data obtained from the Local Government Benchmarking Framework
                (LGBF). The dashboard aims to consolidate indicator data across
                Scotland's local authorities to understand how effective they
                are delivering services."),
                h4("Indicators are categorised into indicator service areas, which can be
                viewed in the sidebar. The 'Visualisation' tab contains a series
                of interactive line plots visualising each indicator and values
                used to derive this indicator (if applicable) against time. The
                'DataTable' tab contains the data used to produce these figures.")
            )
        ),
        fluidRow(
            valueBox(
                x[["LA_Information_LocalAuthority"]],
                "Number of local authorities",
                color = "red",
                width = 3
            ),
            valueBox(
                x[["Indicators_Information_ServiceArea"]],
                "Number of indicator areas",
                color = "red",
                width = 3
            ),
            valueBox(
                x[["Indicators_Information_Category"]],
                "Number of indicator categories",
                color = "red",
                width = 3
            ),
            valueBox(
                x[["Indicators_Information_Code"]],
                "Number of indicators",
                color = "red",
                width = 3
            )
        ),
        fluidRow(
            box(
                title = "References",
                width = 12,
                status = "primary",
                solidHeader = TRUE,
                h4("All data used to produce this dashboard was downloaded from the
                Local Government Benchmarking Framework", tags$a(
                    href = "https://www.improvementservice.org.uk/benchmarking/explore-the-data",
                    target = "_blank",
                    "(LGBF)"
                ), "dataset.")
            )
        )
    )
}
