
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


output_csv <- function(..., append_existing = FALSE ) {
    # Outputs the data into a csv format. If you already have an existing csv
    # with name "ndc_codes" and you simply want to add to the end of that then
    # you can set append_existing = TRUE
    combined <- dplyr::bind_rows(...)
    print(combined)
    readr::write_csv(combined, path = "fdc_codes.csv", append = append_existing)
    
}





