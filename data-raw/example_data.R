library(tidyverse)
library(httr2)

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

data_url <- "https://www.improvementservice.org.uk/__data/assets/file/0024/42369/LGBF_Files_Nov24.zip"
file_path <- download_lgbf_data(data_url)

real_data <- read_csv(paste0(file_path, "/LGBF_Data_Table_Real.csv"))

meta <- read_csv(paste0(file_path, "/Indicators_Information.csv"))

req_meta_cols <- c(
    "Indicators_Information_Code",
    "Indicators_Information_Title",
    "Indicators_Information_ServiceArea",
    "Indicators_Information_Numerator_Title",
    "Indicators_Information_Denominator_Title",
    "Indicators_Information_Unit",
    "Indicators_Information_Category"
)

example_indicator_data <- real_data %>%
    inner_join(
        select(meta, all_of(req_meta_cols)),
        by = "Indicators_Information_Code"
    ) %>%
    filter(
        LA_Information_LocalAuthority %in% c("Aberdeen City", "Falkirk"),
        LA_Data_LGBF_Year %in% c("2010-11", "2011-12"),
        Indicators_Information_Code %in% c("C&L02", "SW01")
    )


usethis::use_data(example_indicator_data, overwrite = TRUE)
