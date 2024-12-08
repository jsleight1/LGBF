#' Create indicator object
#'
#' @description
#' Indicator objects contain a data.frame of data for a single indicator in
#' a single local authority
#'
#' @param x data.frame object indicator data for a single local authority.
#' @param ... Passed to new_tibble.
#'
#' @export
indicator <- function(x, ...) {
    out <- new_indicator(x, ...)
    validate(out)
}

new_indicator <- function(x, ...) {
    new_tibble(x, class = "indicator", ...)
}

#' @rdname validate
#' @export
validate.indicator <- function(x, ...) {
    assert_that(inherits(dataset(x), "data.frame"),
        msg = "indicator must be of data.frame class")
    assert_that(inherits(id(x), "character") && length(id(x)) == 1,
        msg = "id must be character of length 1")
    assert_that(inherits(title(x), "character") && length(title(x)) == 1,
        msg = "title must be character of length 1")
    assert_that(inherits(authority(x), "character") && length(authority(x)) == 1,
        msg = "authority must be character of length 1")
    assert_that(inherits(category(x), "character") && length(category(x)) == 1,
        msg = "category must be character of length 1")
    col_check <- required_indicator_cols() %in% colnames(dataset(x))
    assert_that(all(col_check),
        msg = paste(paste(required_indicator_cols()[!col_check], collapse = ", "),
            "missing from data set")
    )
    x
}

required_indicator_cols <- function() {
    c(
        "LA_Data_LGBF_Year",
        "LA_Data_LA_IndicatorReal",
        "LA_Data_LA_Numerator_real",
        "LA_Data_LA_Den_Real",
        "Scotland_Data_Scotland_Indicator_Real",
        "Scotland_Data_Scotland_Num_Real",
        "Scotland_Data_Scotland_Den_Real",
        "FG_Data_FG_Avg_Indicator_Real",
        "FG_Data_FG_Avg_Num_Real",
        "FG_Data_FG_Avg_Den_Real",
        "Indicators_Information_Unit",
        "Indicators_Information_Title",
        "Indicators_Information_Code",
        "Indicators_Information_Numerator_Title",
        "Indicators_Information_Denominator_Title",
        "Indicators_Information_Category"
    )
}

#' Create example indicator object.
#' @export
example_indicator <- function() {
    LGBF::example_indicator_data %>%
        filter(
            .data[["Indicators_Information_Code"]] == "SW01",
            .data[["LA_Information_LocalAuthority"]] == "Aberdeen City"
        ) %>%
        indicator()
}

#' @export
print.indicator <- function(x, ...) {
    cat("id =", id(x), "\n")
    cat("title =", title(x), "\n")
    cat("authority =", authority(x), "\n")
    cat("category =", category(x), "\n")
    NextMethod()
}

#' @rdname dataset
#' @export
dataset.indicator <- function(x) x

#' @rdname id
#' @export
id.indicator <- function(x) {
    unique(x[["Indicators_Information_Code"]])
}

#' @rdname title
#' @export
title.indicator <- function(x) {
    unique(x[["Indicators_Information_Title"]])
}

#' @rdname authority
#' @export
authority.indicator <- function(x) {
    unique(x[["LA_Information_LocalAuthority"]])
}

#' @rdname category
#' @export
category.indicator <- function(x) {
    unique(x[["Indicators_Information_Category"]])
}

#' Is object indicator object?
#' @param x Object to test.
#' @export
is_indicator <- function(x) inherits(x, "indicator")

#' @rdname plot_types
#' @export
plot_types.indicator <- function(x) {
    c("indicator", "numerator_denominator")
}

#' @rdname plot_data
#' @param type character type of plot to get data for.
#' @export
plot_data.indicator <- function(x, type, ...) {
    switch(arg_match(type, values = plot_types(x)),
        "indicator" = indicator_plot_data,
        "numerator_denominator" = numerator_denominator_plot_data
    )(x, ...)
}

indicator_plot_data <- function(x, ...) {
    dataset(x) %>%
        select(
            "LA_Data_LGBF_Year",
            "Indicators_Information_Unit",
            "Indicators_Information_Title",
            "Local Authority" = "LA_Data_LA_IndicatorReal",
            "Scotland" = "Scotland_Data_Scotland_Indicator_Real",
            "Family Group" = "FG_Data_FG_Avg_Indicator_Real"
        ) %>%
        mutate(
            text = glue(
                "Year: {.data[['LA_Data_LGBF_Year']]}\n",
                "Indicator : {.data[['Indicators_Information_Title']]}\n",
                "Local Authority : {.data[['Local Authority']]}\n",
                "Family Group : {.data[['Family Group']]}\n",
                "Scotland : {.data[['Scotland']]}\n"
            )
        )
}

numerator_denominator_plot_data <- function(x, ...) {
    dataset(x) %>%
        select(
            "Indicators_Information_Code",
            "LA_Information_LocalAuthority",
            "LA_Data_LGBF_Year",
            "LA_Data_LA_Numerator_real",
            "LA_Data_LA_Den_Real",
            "Indicators_Information_Numerator_Title",
            "Indicators_Information_Denominator_Title"
        ) %>%
        mutate(
            text = glue(
                "Year: {unique(dataset(x)[['LA_Data_LGBF_Year']])}\n",
                "{unique(dataset(x)[['Indicators_Information_Numerator_Title']])}: {.data[['LA_Data_LA_Numerator_real']]}\n",
                "{unique(dataset(x)[['Indicators_Information_Denominator_Title']])}: {.data[['LA_Data_LA_Den_Real']]}\n",
            )
        )
}

#' @export
plot.indicator <- function(x, type, ...) {
    switch(arg_match(type, values = plot_types(x)),
        "indicator" = indicator_plot,
        "numerator_denominator" = numerator_denominator_plot
    )(x, ...)
}

indicator_plot <- function(x, ...) {
    dat <- plot_data(x, "indicator", ...)
    unit <- unique(dat[["Indicators_Information_Unit"]])
    plot_ly() %>%
        add_trace(
            x = ~dat[["LA_Data_LGBF_Year"]],
            y = ~dat[["Local Authority"]],
            name = "Local Authority",
            text = ~dat[["text"]],
            mode = "lines+markers",
            type = "scatter",
            hovertemplate = "%{text}<extra></extra>"
        ) %>%
        add_trace(
            x = ~dat[["LA_Data_LGBF_Year"]],
            y = ~dat[["Family Group"]],
            name = "Family Group",
            text = ~dat[["text"]],
            mode = "lines+markers",
            type = "scatter",
            hovertemplate = "%{text}<extra></extra>"
        ) %>%
        add_trace(
            x = ~dat[["LA_Data_LGBF_Year"]],
            y = ~dat[["Scotland"]],
            name = "Scotland",
            text = ~dat[["text"]],
            mode = "lines+markers",
            type = "scatter",
            hovertemplate = "%{text}<extra></extra>"
        ) %>%
        layout(
            xaxis = list(
                title = "",
                zerolinecolor = '#ffff',
                zerolinewidth = 2,
                gridcolor = 'ffff'
            ),
            yaxis = list(
                title = "",
                zerolinecolor = '#ffff',
                zerolinewidth = 2,
                gridcolor = 'ffff',
                tickformat = case_when(
                    unit == "Percentage" ~ ".1%",
                    TRUE ~ ""
                ),
                tickprefix = case_when(
                    unit == "Pounds" ~ enc2utf8("\u00A3"),
                    TRUE ~ ""
                ),
                ticksuffix = case_when(
                    unit == "tonnes" ~ "t",
                    unit == "t" ~ "days",
                    TRUE ~ ""
                )
            ),
            legend = list(orientation = "h", x = 0.3, y = -0.3),
            margin = list(l = 50, r = 50, b = 50, t = 50, pad = 4)
        )
}

numerator_denominator_plot <- function(x, ...) {
    if (!contains_num_den(x)) {
        return (NULL)
    }
    dat <- plot_data(x, "numerator_denominator", ...)
    num_title <- unique(dat[["Indicators_Information_Numerator_Title"]]) %>%
        newline_title()
    den_title <- unique(dat[["Indicators_Information_Denominator_Title"]]) %>%
        newline_title()
    plot_ly() %>%
        add_trace(
            x = ~dat[["LA_Data_LGBF_Year"]],
            y = ~dat[["LA_Data_LA_Numerator_real"]],
            name = num_title,
            text = dat[["text"]],
            mode = "lines+markers",
            type = "scatter",
            hovertemplate = "%{text}<extra></extra>"
        ) %>%
        add_trace(
            x = ~dat[["LA_Data_LGBF_Year"]],
            y = ~dat[["LA_Data_LA_Den_Real"]],
            name = den_title,
            text = dat[["text"]],
            yaxis = "y2",
            mode = "lines+markers",
            type = "scatter",
            hovertemplate = "texttext%{text}<extra></extra>"
        ) %>%
        layout(
            yaxis2 = list(
                overlaying = "y",
                side = "right",
                title = den_title
            ),
            xaxis = list(
                title = "",
                zerolinecolor = '#ffff',
                zerolinewidth = 2,
                gridcolor = 'ffff'
            ),
            yaxis = list(
                title = num_title,
                zerolinecolor = '#ffff',
                zerolinewidth = 2,
                gridcolor = 'ffff'
            ),
            legend = list(orientation = "h", x = 0.4, y = -0.4),
            margin = list(l = 50, r = 100, b = 50, t = 50, pad = 4)
        )
}

newline_title <- function(x, n = 30) {
    paste(strwrap(x, width = n), collapse = "\n")
}

#' @rdname visual_ui
#' @param ns Namespace function to generate UI with.
#' @export
visual_ui.indicator <- function(x, ns, ...) {
    ns <- NS(ns(make_names(id(x))))
    tabPanel(title = title(x), uiOutput(ns("indicator_ui")))
}

#' @rdname visual_server
#' @export
visual_server.indicator <- function(x, ...) {
    moduleServer(
        make_names(id(x)),
        function(input, output, session) {
            ns <- session[["ns"]]
            output[["indicator"]] <- renderPlotly(
                plot(x, "indicator")
            )
            output[["numerator_denominator"]] <- renderPlotly(
                plot(x, "numerator_denominator")
            )
            output[["indicator_ui"]] <- renderUI({
                num_den_ui <- num_den_ui(x, ns)
                fluidRow(
                    column(
                        spinner(plotlyOutput(ns("indicator"))),
                        width = ifelse(is.null(num_den_ui), 12, 6)
                    ),
                    num_den_ui,
                    downloadButton(ns("download"), "Download data")
                )
            })
            output[["download"]] <- downloadHandler(
                filename = str_c(id(x), ".csv"),
                content = function(file) {
                    write_csv(dataset(x), file)
                }
            )
        }
    )
}

num_den_ui <- function(x, ns) {
    out <- NULL
    if(contains_num_den(x)) {
        out <- column(
            spinner(plotlyOutput(ns("numerator_denominator"))),
            width = 6
        )
    }
    out
}

contains_num_den <- function(x) {
    !all(is.na(dataset(x)[["LA_Data_LA_Numerator_real"]])) &&
        !all(is.na(dataset(x)[["LA_Data_LA_Den_Real"]]))
}
