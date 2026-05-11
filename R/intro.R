intro_ui <- function(x) {
  list(
    card(
      card_header("Welcome to the LGBF dashboard"),
      h5(
        "This dashboard presents a summary of local authority indicator
        data obtained from the Local Government Benchmarking Framework
        (LGBF). The dashboard aims to consolidate indicator data across
        Scotland's local authorities to understand how effective they
        are delivering services."
      ),
      h5(
        "Indicators are categorised into indicator service areas, which can be
        viewed in the sidebar. The 'Visualisation' tab contains a series
        of interactive line plots visualising each indicator and values
        used to derive this indicator (if applicable) against time. The
        'DataTable' tab contains the data used to produce these figures."
      )
    ),
    layout_column_wrap(
      value_box(
        title = "Number of local authorities",
        value = x[["LA_Information_LocalAuthority"]]
      ),
      value_box(
        title = "Number of indicator areas",
        value = x[["Indicators_Information_ServiceArea"]]
      ),
      value_box(
        title = "Number of indicator categories",
        value = x[["Indicators_Information_Category"]]
      ),
      value_box(
        title = "Number of indicators",
        value = x[["Indicators_Information_Code"]]
      )
    ),
    card(
      card_header("References"),
      h5("All data used to produce this dashboard was downloaded from the
                Local Government Benchmarking Framework", tags$a(
        href = "https://www.improvementservice.org.uk/benchmarking/explore-the-data",
        target = "_blank",
        "(LGBF)"
      ), "dataset.")
    )
  )
}
