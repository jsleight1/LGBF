#' @import ggplot2 dplyr shiny shinydashboard
NULL

#' @importFrom assertthat assert_that
#' @importFrom readr read_csv write_csv
#' @importFrom purrr imap map map_chr map_dfr map_lgl list_flatten walk
#' @importFrom plotly add_trace plot_ly plotlyOutput renderPlotly layout
#' @importFrom rlang arg_match
#' @importFrom shinyWidgets addSpinner
#' @importFrom tidyr pivot_longer
#' @importFrom httr2 request req_retry req_perform
#' @importFrom glue glue
#' @importFrom tibble new_tibble deframe enframe
#' @importFrom DT DTOutput renderDT
#' @importFrom stringr str_c
#' @importFrom stats setNames
#' @importFrom utils unzip
#' @importFrom magrittr %>%
NULL

utils::globalVariables(".")