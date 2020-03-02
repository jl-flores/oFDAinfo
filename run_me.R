
source("open_fda_functions.R")
source("making_exportable_data.R")

drugs <- list(c("generic_name", "ibuprofen"),
              c("brand_name", "stelara")
              )

ndc_query(drugs )
