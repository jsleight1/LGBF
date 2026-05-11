generate_summary_metrics <- function(x,
                                     cols = c(
                                       "LA_Information_LocalAuthority",
                                       "Indicators_Information_ServiceArea",
                                       "Indicators_Information_Code",
                                       "Indicators_Information_Category"
                                     )) {
  x %>%
    select(all_of(cols)) %>%
    distinct() %>%
    pivot_longer(everything()) %>%
    group_by(.data[["name"]]) %>%
    summarise(n_unique = n_distinct(.data[["value"]])) %>%
    deframe()
}

generate_sidebar <- function(x) {
  sidebarMenu(
    id = "sidebar",
    c(list(menuItem("Introduction", tabName = "intro")), map(x, menu_item))
  )
}

generate_body_items <- function(x, metrics) {
  do.call(
    tabItems,
    c(
      list(intro_ui("intro", metrics)),
      list_flatten(map(x, generate_indicator_areas_items))
    )
  )
}

generate_indicator_areas_items <- function(x) {
  list(
    tabItem(
      tabName = glue("visual_{make_names(id(x))}"),
      visual_ui(x)
    ),
    tabItem(
      tabName = glue("datatable_{make_names(id(x))}"),
      datatable_ui(x)
    )
  )
}

make_names <- function(x) {
  gsub("\\.+", "_", make.names(x))
}

generate_indicator_areas <- function(x) {
  x %>%
    group_split(
      .data[["LA_Information_LocalAuthority"]],
      .data[["Indicators_Information_Code"]]
    ) %>%
    map(indicator) %>%
    indicator_area(id = unique(x[["Indicators_Information_ServiceArea"]]))
}

spinner <- function(...) {
  shinyWidgets::addSpinner(..., spin = "bounce", color = "#377EB8")
}
