#' Create indicator area object
#'
#' @description
#' Indicator area objects contain a list of indicator objects for single
#' indicator serivce area.
#'
#' @param x list of indicator objects.
#' @param id Character id for object.
#' @param ... Passed to structure
#'
#' @export
indicator_area <- function(x, id, ...) {
    out <- new_indicator_area(x, id, ...)
    validate(out)
}

new_indicator_area <- function(x, id, ...) {
    structure(.Data = list(x = x), id = id, ..., class = "indicator_area")
}

#' @rdname validate
#' @export
validate.indicator_area <- function(x, ...) {
    assert_that(all(map_lgl(dataset(x), is_indicator)),
        msg = "indicator area object must only contain indicator objects")
    assert_that(inherits(id(x), "character") && length(id(x)) == 1,
        msg = "id attribute must be character")
    x
}

#' Create example indicator_area object.
#' @export
example_indicator_area <- function() {
    LGBF::example_indicator_data %>%
        group_split(
            .data[["Indicators_Information_Code"]],
            .data[["LA_Information_LocalAuthority"]]
        ) %>%
        map(indicator) %>%
        indicator_area(id = "service_area")
}

#' @export
print.indicator_area <- function(x, ...) {
    cat(class(x)[[1]],  "object ( N indicators = ",
        length(unique(map_chr(dataset(x), title))), ")\n")
    cat("id =", id(x), "\n")
    cat("N authorities = ", length(unique(authority(x))), "\n")
}

#' @rdname dataset
#' @export
dataset.indicator_area <- function(x) x[["x"]]

#' @rdname authority
#' @export
authority.indicator_area <- function(x) {
    map_chr(dataset(x), authority)
}

#' Is object indicator area object?
#' @param x object to test.
#' @export
is_indicator_area <- function(x) inherits(x, "indicator_area")

#' @rdname visual_ui
#' @export
visual_ui.indicator_area <- function(x, ...) {
    ns <- NS(make_names(id(x)))
    fluidRow(
        column(
            box(
                title = "Introduction",
                width = 12,
                status = "primary",
                solidHeader = TRUE,
                h3("Indicator visualisation"),
                h4("Indicator data for a selected local authority is visualised as
                a series of interactive line plots. Data are stratified
                into categories; 'Performance' 'Financial' and 'Satisfaction', which
                are displayed in independent boxes. Each box contains tab panels that
                can be used to navigate between different indicator data sets. The
                'Download data' button found in each tab panel allows downloading
                of the data set used to generate each plot.")
            ),
            box(
                title = id(x),
                width = 12,
                status = "primary",
                solidHeader = TRUE,
                selectInput(
                    ns("authority_select"),
                    label = "Select authority",
                    choices = unique(authority(x)),
                    selected = unique(authority(x))[[1]]
                ),
                uiOutput(ns("indicator_boxes"))
            ),
            width = 12
        )
    )
}

#' @rdname visual_server
#' @export
visual_server.indicator_area <- function(x, ...) {
    moduleServer(
        make_names(id(x)),
        function(input, output, session) {
            ns <- session[["ns"]]
            output[["indicator_boxes"]] <- renderUI({
                la <- req(input[["authority_select"]])
                dat <- dataset(x)[authority(x) == la] %>%
                    setNames(map_chr(., category)) %>%
                    enframe() %>%
                    group_split(.data[["name"]]) %>%
                    setNames(map_chr(., ~unique(.x[["name"]])))

                imap(dat, ~{
                    walk(.x[["value"]], visual_server)
                    do.call(
                        tabBox,
                        c(
                            map(.x[["value"]], visual_ui, ns = ns),
                            width = 12,
                            title = .y,
                            side = "right"
                        )
                    )
                })
            })
        }
    )
}

#' @rdname datatable_ui
#' @export
datatable_ui.indicator_area <- function(x, ...) {
    ns <- NS(make_names(id(x)))
    fluidRow(
        column(
            box(
                title = "Introduction",
                width = 12,
                status = "primary",
                solidHeader = TRUE,
                h3("Indicator datatable"),
                h4("Indicator data for a selected service area is presented
                as an interactive datatable. This table can be filtered, sorted
                and downloaded using the 'Download data' button.")
            ),
            box(
                title = id(x),
                width = 12,
                status = "primary",
                solidHeader = TRUE,
                DTOutput(outputId = ns("datatable")),
                downloadButton(ns("download"), "Download data")
            ),
            width = 12
        )
    )
}

#' @rdname datatable_server
#' @export
datatable_server.indicator_area <- function(x, ...) {
    moduleServer(
        make_names(id(x)),
        function(input, output, session) {
            data <- map_dfr(dataset(x), dataset)
            output[["datatable"]] <- renderDT(
                data,
                extensions = c("Scroller", "FixedColumns"),
                rownames = FALSE,
                escape = FALSE,
                selection = "none",
                filter = "top",
                options = list(
                    paging = TRUE,
                    scrollX = TRUE,
                    searching = TRUE,
                    pageLength = 10
                )
            )
            filtered_data <- reactiveVal()
            observeEvent(input[["datatable_rows_all"]], {
                filtered_data(data[req(input[["datatable_rows_all"]]), ])
            })
            output[["download"]] <- downloadHandler(
                filename = str_c(id(x), ".csv"),
                content = function(file) {
                    write_csv(filtered_data(), file)
                }
            )
        }
    )
}

#' @rdname menu_item
#' @export
menu_item.indicator_area <- function(x, ...) {
    menuItem(
        id(x),
        tabName = make_names(id(x)),
        menuSubItem(
            "Visualisation",
            tabName = glue("visual_{make_names(id(x))}")
        ),
        menuSubItem(
            "DataTable",
            tabName = glue("datatable_{make_names(id(x))}")
        )
    )
}