download_lgbf_data <- function(x) {
    tmpfile <- paste0(tempfile(), ".zip")
    origwd <- getwd()
    setwd(dirname(tmpfile))
    req <- request(x) %>%
        req_retry(max_tries = 5) |>
        req_perform(path = tmpfile)
    unzip(basename(req$body))
    setwd(origwd)
    dirname(req$body)
}

process_data <- function(
        data_url = "https://www.improvementservice.org.uk/__data/assets/file/0031/56983/LGBF-Datafiles-Jan-25.zip"
    ) {
    file_path <- download_lgbf_data(data_url)

    real_data <- read_csv(paste0(file_path, "/LGBF_Datafiles/LGBF_Data_Table_Real.csv"))

    meta <- read_csv(paste0(file_path, "/LGBF_Datafiles/Indicators_Information.csv"))

    req_meta_cols <- c(
        "Indicators_Information_Code",
        "Indicators_Information_Title",
        "Indicators_Information_ServiceArea",
        "Indicators_Information_Numerator_Title",
        "Indicators_Information_Denominator_Title",
        "Indicators_Information_Unit",
        "Indicators_Information_Category"
    )

    real_data %>%
        inner_join(
            select(meta, all_of(req_meta_cols)),
            by = "Indicators_Information_Code"
        )
}

generate_summary_metrics <- function(
        x,
        cols = c(
            "LA_Information_LocalAuthority",
            "Indicators_Information_ServiceArea",
            "Indicators_Information_Code",
            "Indicators_Information_Category"
        )
    ) {
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

