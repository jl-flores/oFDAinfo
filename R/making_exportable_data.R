
#' @title Cleans the data
#' @description Cleans the data in a reproducible manner, creating dataframes with the same columns for each pull from the API
#' @param data.frame.drug List of API pulls (output of the find_ndc function)
#' @return Clean data with consistent columns
#' @details This function works on one dataframe. To work on a list of dataframes, as is often the output of \code{\link{[oFDAinfo]{find_ndc}}} must map this function over the list
#' @examples 
#' \dontrun{
#' z <- find_ndc("generic", "ustekinumab")
#' openfda_cleandf(z)
#' }
#' @seealso 
#'  \code{\link[dplyr]{mutate}},\code{\link[dplyr]{select}}
#'  \code{\link[tidyselect]{select_helpers}}
#' @rdname openfda_tidydf
#' @importFrom dplyr mutate select
#' @importFrom tidyselect any_of
openfda_cleandf <- function(data.frame.drug) {

    delisted <- data.frame.drug %>% 
        dplyr::mutate(package_ndc = as.character(packaging$package_ndc),
               marketing_start_date = as.character(packaging$marketing_start_date),
               description = as.character(packaging$description),
               sample = as.character(packaging$sample)
               ) %>% 
        dplyr::select(-packaging)
    renamed <- delisted %>% 
        dplyr::select(tidyselect::any_of(c("generic_name","brand_name", "package_ndc", 
                                    "product_ndc", "brand_name_base","labeler_name",
                                    "route", "dosage_form", "description"))
               )
    
    if("route" %in% names(renamed)) {
        renamed <- dplyr::mutate(renamed, route = as.character(route))
    }
    
    return(renamed)
}


#' @title Run a query of the API and output a clean, usable dataframe
#' @description Run a query of the FDA's API in its entirety and output the data as a dataframe
#' @param list.names a list of query parameters
#' @param append.existing Do you wish to add the output to an already created text file Default: FALSE
#' @param path.output Where would you like to output the csv, Default: 'output/ndc_codes.csv'
#' @param csv Do you want to output a csv. If false, \code{path.output} and \code{append.existing} is irrelevant, Default: FALSE
#' @return Returns a dataframe with all the results of the query 
#' @details This is the workhorse function of the \code{oFDAinfo} package
#' @examples 
#' \dontrun{
#' drugs <- list(c("generic_name", "ibuprofen"), c("brand_name", "humira"))
#' ndc_query(drugs, csv = TRUE)
#' }
#' @seealso 
#'  \code{\link[purrr]{map}}
#' @rdname ndc_query
#' @export 
#' @importFrom purrr map
#' @importFrom dplyr bind_rows
ndc_query <- function(list.names, append.existing = FALSE, 
                      path.output = "output/ndc_codes.csv",
                      csv = FALSE) {
    
    num_drugs <- length(list.names)
    combined_df <- vector("list", length = num_drugs)

    for(ind_drug in 1:num_drugs){
        param <- list.names[[ind_drug]][1]
        drug  <- list.names[[ind_drug]][2]
        df_drug <- find_ndc(param, drug)
        output_type <- inherits(df_drug, "data.frame")
        if(output_type){
            df_drug_clean <- openfda_cleandf(df_drug)
        }else {
            df_drug_clean <- purrr::map(df_drug, openfda_cleandf)
            df_drug_clean <- do.call(bind_rows, df_drug_clean)
        }
        combined_df[[ind_drug]] <- df_drug_clean
    }
    
    combined_df <- bind_rows(combined_df)
    
    if(csv) {
        write.csv(combined_df, append = append.existing, file = path.output)
    } 
    return(combined_df)
}




