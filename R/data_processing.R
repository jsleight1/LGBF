process_lgbf_data <- function(
    metadata_url = "https://data.spatialhub.scot/dataset/9a3728b4-49ea-40af-ab10-fc0305bace84/resource/00845629-44d0-489e-8c5e-9f49ed6b19ce/download/indicator-information.csv",
    data_url = "https://data.spatialhub.scot/dataset/9a3728b4-49ea-40af-ab10-fc0305bace84/resource/7ba35197-7ca7-4477-a38b-01fd4180466b/download/lgbf_data_table_real.csv") {
  metadata <- download_csv_data(metadata_url)
  data <- download_csv_data(data_url)

  data |>
    inner_join(
      select(metadata, all_of(required_lgbf_metadata_cols())),
      by = "Indicators_Information_Code"
    )
}

download_csv_data <- function(x) {
  tmpfile <- paste0(tempfile(), ".csv")
  req <- request(x) |>
    req_retry(max_tries = 5) |>
    req_perform()
  writeBin(req[["body"]], tmpfile)
  readr::read_csv(tmpfile)
}

required_lgbf_metadata_cols <- function() {
  c(
    "Indicators_Information_Code" = "Code",
    "Indicators_Information_Title" = "Title",
    "Indicators_Information_ServiceArea" = "ServiceArea",
    "Indicators_Information_Numerator_Title" = "Numerator_Title",
    "Indicators_Information_Denominator_Title" = "Denominator_Title",
    "Indicators_Information_Unit" = "Unit",
    "Indicators_Information_Category" = "Category"
  )
}

save_lgbf_data <- function(config = get_config(), ...) {
  switch(config[["type"]],
    "development" = save_local_lgbf_data,
    "production" = save_azure_lgbf_data
  )(config, ...)
}

save_local_lgbf_data <- function(
    config = get_config(),
    data = process_lgbf_data(),
    ...) {
  saveRDS(data, config[["processed_data_file"]])
}

save_azure_lgbf_data <- function(
    config = get_config(),
    data = process_lgbf_data(),
    ...) {
  container <- azure_container(config)
  file <- config[["processed_data_file"]]
  storage_save_rds(data, container = container, file = file)
}

load_lgbf_data <- function(config = get_config(), ...) {
  switch(config[["type"]],
    "development" = load_local_lgbf_data,
    "production" = load_azure_lgbf_data
  )(config, ...)
}

load_local_lgbf_data <- function(config = get_config(), ...) {
  readRDS(config[["processed_data_file"]])
}

load_azure_lgbf_data <- function(config = get_config(), ...) {
  container <- azure_container(config)
  file <- config[["processed_data_file"]]
  storage_load_rds(container = container, file = file)
}

azure_container <- function(config = get_config()) {
  account_url <- config[["blob_account_url"]]
  account_key <- config[["blob_account_key"]]
  container <- config[["azure_storage_container"]]
  storage_endpoint(endpoint = account_url, key = account_key) |>
    storage_container(name = container)
}

get_config <- function(...) {
  config::get(
    file = system.file("config.yml", package = "LGBF"),
    ...
  )
}
