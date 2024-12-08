test_that("indicator area construction works", {
    out <- LGBF::example_indicator_data %>%
        group_split(
            .data[["LA_Information_LocalAuthority"]],
            .data[["Indicators_Information_Code"]]
        ) %>%
        map(indicator) %>%
        indicator_area(id = "service_area") %>%
        expect_no_error()

    expect_s3_class(out, "indicator_area")
    expect_true(is_indicator_area(out))
    expect_identical(dataset(out), out[["x"]])
    expect_identical(id(out), "service_area")
    expect_identical(authority(out), c(rep("Aberdeen City", 2), rep("Falkirk", 2)))
})

test_that("example_indicator_area works", {
    dat <- example_indicator_area() %>%
        expect_no_error()
    expect_s3_class(dat, "indicator_area")
})


test_that("visual_ui.indicator_area works", {
    out <- example_indicator_area() %>%
        visual_ui() %>%
        expect_no_error()
    expect_s3_class(out, "shiny.tag")
})

test_that("datatable_ui.indicator_area works", {
    out <- example_indicator_area() %>%
        datatable_ui() %>%
        expect_no_error()
    expect_s3_class(out, "shiny.tag")
})

test_that("menu_item.indicator_area works", {
    out <- example_indicator_area() %>%
        menu_item() %>%
        expect_no_error()
    expect_s3_class(out, "shiny.tag")
})

