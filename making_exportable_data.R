
openfda_tidydf <- function(data.frame.drug) {
    # This function takes the output of the query as input and turns the data
    # into a replicable dataframe that can then be combined so that all the
    # drugs can be together.
    require(dplyr)
        
    delisted <- data.frame.drug %>% 
        mutate(package_ndc = as.character(packaging$package_ndc),
               marketing_start_date = as.character(packaging$marketing_start_date),
               description = as.character(packaging$description),
               sample = as.character(packaging$sample)) %>% 
            select(-packaging)
    renamed <- delisted %>% 
        select(tidyselect::any_of(c("generic_name","brand_name", "package_ndc", 
                                    "product_ndc", "brand_name_base","labeler_name",
                                    "route", "dosage_form", "description"))
               )
    
    if("route" %in% names(renamed)) {
        renamed <- mutate(renamed, route = as.character(route))
    }
    
    return(renamed)
}


# output_csv <- function(dataf, append_existing = FALSE, path_output = "output/ndc_codes.csv") {
#     # Outputs the data into a csv format. If you already have an existing csv
#     # with name "ndc_codes" and you simply want to add to the end of that then
#     # you can set append_existing = TRUE. If you append there could be duplicate rows
#     combined <- dplyr::bind_rows(dataf)
#     readr::write_csv(combined, path = path_output , append = append_existing)
#     
# }

ndc_query <- function(list_names, append_existing = FALSE, 
                      path_output = "output/ndc_codes.csv",
                      csv = TRUE) {
    # The workhorse function: run it with a list of names of the format c("name
    # type", "drug name") and it will output the csv (if csv = true) or else
    # just a df (csv = false)
    require(purrr)
    require(dplyr)
    require(readr)

    num_drugs <- length(list_names)
    combined_df <- vector("list", length = num_drugs)

    for(ind_drug in 1:num_drugs){
        param <- list_names[[ind_drug]][1]
        drug  <- list_names[[ind_drug]][2]
        df_drug <- find_ndc(param, drug)
        output_type <- inherits(df_drug, "data.frame")
        if(output_type){
            df_drug_clean <- openfda_tidydf(df_drug)
        }else {
            df_drug_clean <- map(df_drug, openfda_tidydf)
            df_drug_clean <- do.call(bind_rows, df_drug_clean)
        }
        combined_df[[ind_drug]] <- df_drug_clean
    }
    
    combined_df <- bind_rows(combined_df)
    
    if(csv) {
        write_csv(combined_df, append = append_existing, path = path_output)
    } 
    return(combined_df)
}




