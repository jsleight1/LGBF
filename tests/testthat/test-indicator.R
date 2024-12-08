test_that("indicator construction works", {
    out <- LGBF::example_indicator_data %>%
        filter(
            .data[["Indicators_Information_Code"]] == "SW01",
            .data[["LA_Information_LocalAuthority"]] == "Aberdeen City"
        ) %>%
        indicator() %>%
        expect_no_error()

    expect_s3_class(out, "indicator")
    expect_true(is_indicator(out))
    expect_identical(dataset(out), out)
    expect_identical(id(out), "SW01")
    expect_identical(title(out),
      "Home care costs per hour for people aged 65 or over")
    expect_identical(category(out), "Financial")
    expect_identical(authority(out), "Aberdeen City")
})

test_that("example_indicator works", {
    dat <- example_indicator() %>%
        expect_no_error()
    expect_s3_class(dat, "indicator")
})

test_that("plot_types.indicator works", {
    dat <- example_indicator()
    expect_identical(plot_types(dat),
        c("indicator",  "numerator_denominator"))

})

test_that("plot_data.indicator works", {
    dat <- example_indicator()

    out <- plot_data(dat, "indicator") %>%
        expect_no_error()
    expect_snapshot_output(as.data.frame(out))

    out <- plot_data(dat, "numerator_denominator") %>%
        expect_no_error()
    expect_snapshot_output(as.data.frame(out))

    plot_data(dat, "type") %>%
        expect_error()
})

test_that("plot.indicator works", {
    dat <- example_indicator()

    p <- plot(dat, "indicator") %>%
        expect_no_error()
    expect_s3_class(p, "plotly")

    p <- plot(dat, "numerator_denominator") %>%
        expect_no_error()
    expect_s3_class(p, "plotly")

    plot(dat, "type") %>%
        expect_error()
})

test_that("visual_ui.indicator works", {
    out <- example_indicator() %>%
        visual_ui(function(i) "ns") %>%
        expect_no_error()
    expect_s3_class(out, "shiny.tag")
})