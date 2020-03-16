
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param data.frame.drug PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[dplyr]{mutate}},\code{\link[dplyr]{select}}
#'  \code{\link[tidyselect]{select_helpers}}
#' @rdname openfda_tidydf
#' @export 
#' @importFrom dplyr mutate select
#' @importFrom tidyselect any_of
openfda_tidydf <- function(data.frame.drug) {
    # This function takes the output of the query as input and turns the data
    # into a replicable dataframe that can then be combined so that all the
    # drugs can be together.
    require(dplyr)
        
    delisted <- data.frame.drug %>% 
        dplyr::mutate(package_ndc = as.character(packaging$package_ndc),
               marketing_start_date = as.character(packaging$marketing_start_date),
               description = as.character(packaging$description),
               sample = as.character(packaging$sample)) %>% 
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


#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param list.names PARAM_DESCRIPTION
#' @param append.existing PARAM_DESCRIPTION, Default: FALSE
#' @param path_output PARAM_DESCRIPTION, Default: 'output/ndc_codes.csv'
#' @param csv PARAM_DESCRIPTION, Default: TRUE
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[purrr]{map}}
#' @rdname ndc_query
#' @export 
#' @importFrom purrr map
ndc_query <- function(list.names, append.existing = FALSE, 
                      path_output = "output/ndc_codes.csv",
                      csv = TRUE) {
    # The workhorse function: run it with a list of names of the format c("name
    # type", "drug name") and it will output the csv (if csv = true) or else
    # just a df (csv = false)

    num_drugs <- length(list.names)
    combined_df <- vector("list", length = num_drugs)

    for(ind_drug in 1:num_drugs){
        param <- list.names[[ind_drug]][1]
        drug  <- list.names[[ind_drug]][2]
        df_drug <- find_ndc(param, drug)
        output_type <- inherits(df_drug, "data.frame")
        if(output_type){
            df_drug_clean <- openfda_tidydf(df_drug)
        }else {
            df_drug_clean <- purrr::map(df_drug, openfda_tidydf)
            df_drug_clean <- do.call(rbind, df_drug_clean)
        }
        combined_df[[ind_drug]] <- df_drug_clean
    }
    
    combined_df <- rbind(combined_df)
    
    if(csv) {
        write.csv(combined_df, append = append.existing, file = path_output)
    } 
    return(combined_df)
}




