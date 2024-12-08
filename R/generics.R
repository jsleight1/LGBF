#' Validate object has correct stucture.
#' @param x Object to validate e.g. indicator_area/indicator object.
#' @param ... Passed to methods
#' @export
validate <- function(x, ...) UseMethod("validate")

#' Get data set of object.
#' @param x Appropriate object e.g. indicator_area/indicator object.
#' @export
dataset <- function(x) UseMethod("dataset")

#' Get id of object.
#' @param x Appropriate object e.g. indicator_area/indicator object.
#' @export
id <- function(x) UseMethod("id")

#' @rdname id
#' @export
id.default <- function(x) attr(x, "id")

#' Get title of object.
#' @param x Appropriate object e.g. indicator object.
#' @export
title <- function(x) UseMethod("title")

#' Get category of object.
#' @param x Appropriate object e.g. indicator object.
#' @export
category <- function(x) UseMethod("category")

#' Get authority of object.
#' @param x Appropriate object e.g. indicator_area/indicator object.
#' @export
authority <- function(x) UseMethod("authority")

#' Get available plot types for object.
#' @param x Appropriate object e.g. indicator object.
#' @export
plot_types <- function(x) UseMethod("plot_types")

#' Get plot data for object.
#' @param x Appropriate object e.g. indicator object.
#' @param ... Passed to methods.
#' @export
plot_data <- function(x, ...) UseMethod("plot_data")

#' Get user interface containing visualisation for object.
#' @param x Appropriate object e.g. indicator_area/indicator object.
#' @param ... Passed to methods.
#' @export
visual_ui <- function(x, ...) UseMethod("visual_ui")

#' Get server side code for visualisation for object.
#' @param x Appropriate object e.g. indicator_area/indicator object.
#' @param ... Passed to methods.
#' @export
visual_server <- function(x, ...) UseMethod("visual_server")

#' Get user interface containing datatable for object.
#' @param x Appropriate object e.g. indicator_area object.
#' @param ... Passed to methods.
#' @export
datatable_ui <- function(x, ...) UseMethod("datatable_ui")

#' Get server side code for datatable for object.
#' @param x Appropriate object e.g. indicator_area object.
#' @param ... Passed to methods.
#' @export
datatable_server <- function(x, ...) UseMethod("datatable_server")

#' Get menu item user interface for object.
#' @param x Appropriate object e.g. indicator_area object.
#' @param ... Passed to methods.
#' @export
menu_item <- function(x) UseMethod("menu_item")
