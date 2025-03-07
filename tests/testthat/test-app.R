library(shinytest2)

with_mocked_bindings(
    process_data = function() LGBF::example_indicator_data,
    shiny_app <- LGBF()
)

test_that("LGBF app initial values works", {
    skip_on_cran()
    skip_on_ci()

    app <- AppDriver$new(shiny_app, name = "initial", width = 800, height = 700,
        seed = 4323)

    app$expect_values()
    app$expect_unique_names()
    app$stop()
})


test_that("LGBF app indicator area visualisation works", {
    skip_on_cran()
    skip_on_ci()

    app <- AppDriver$new(shiny_app, name = "visualisation", width = 800, height = 700,
        seed = 4323, load_timeout = 40 * 1000)

    app$set_inputs(sidebar = "visual_Adult_Social_Care_Services")
    app$wait_for_value(output = "Adult_Social_Care_Services-SW01-indicator")

    app$expect_values()
    app$expect_unique_names()
    app$stop()
})


test_that("LGBF app indicator area datatable works", {
    skip_on_cran()
    skip_on_ci()

    app <- AppDriver$new(shiny_app, name = "datatable", width = 800, height = 700,
        seed = 4323)

    app$set_inputs(sidebar = "datatable_Adult_Social_Care_Services")
    app$wait_for_value(output = "Adult_Social_Care_Services-datatable")

    app$expect_values()
    app$expect_unique_names()
    app$stop()
})
