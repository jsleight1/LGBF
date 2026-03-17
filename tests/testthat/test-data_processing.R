library(mockery)

test_that("process_lgbf_data works", {
    m <- mock()
    with_mocked_bindings(
        download_csv_data = function(x) {
            meta_cols <- required_lgbf_metadata_cols()
            meta_cols <- setNames(names(meta_cols), meta_cols)
            data <- if(grepl("indicator-information", x)) {
                unique(select(example_indicator_data, all_of(meta_cols)))
            } else {
                rm_cols <- setdiff(meta_cols, "Indicators_Information_Code")
                select(example_indicator_data, -all_of(rm_cols))
            }
        },
        out <- process_lgbf_data()
    )
    expect_s3_class(out, "data.frame")
    expect_identical(out, example_indicator_data)
})

test_that("save_lgbf_data works", {
  dev_config <- get_config(config = "development")
  m <- mock()
  with_mocked_bindings(
    save_local_lgbf_data = function(...) m(...),
    out <- save_lgbf_data(dev_config)
  )
  expect_args(m, 1, dev_config)

  prod_config <- get_config(config = "production")
  m <- mock()
  with_mocked_bindings(
    save_azure_lgbf_data = function(...) m(...),
    out <- save_lgbf_data(prod_config)
  )
  expect_args(m, 1, prod_config)
})

test_that("load_lgbf_data works", {
  dev_config <- get_config(config = "development")
  m <- mock()
  with_mocked_bindings(
    load_local_lgbf_data = function(...) m(...),
    out <- load_lgbf_data(dev_config)
  )
  expect_args(m, 1, dev_config)

  prod_config <- get_config(config = "production")
  m <- mock()
  with_mocked_bindings(
    load_azure_lgbf_data = function(...) m(...),
    out <- load_lgbf_data(prod_config)
  )
  expect_args(m, 1, prod_config)
})