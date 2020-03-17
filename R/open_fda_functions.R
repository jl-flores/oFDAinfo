

#' @title find_ndc
#' @description helper function that runs the \code{\link{query}} and \code{\link{dataframed_unique}} functions
#' @param name.category What category your drug name falls under (Ex. "generic_name" or "brand_name")
#' @param name The name of the drug (Ex. "ibuprofen")
#' @return Dataframe of one drug's information from the openFDA API
#' @details DETAILS
#' @examples 
#' \dontrun{
#' find_ndc("generic_name", "ibuprofen")
#' }
#' @rdname find_ndc
find_ndc <- function(name.category, name) {
    #this executes the search
    run <- query(name.category, name)
    df_run <- dataframed_unique(run)
    return(df_run)
}




#' @title Create and execute search parameters for use within FDA's openFDA
#' @description Builds and executes queries. Allows for scraping all the information from drugs who have more than 100 entries (the maximum allowed by openFDA).  
#' @param search.list What category your drug name falls under (Ex. "generic_name" or "brand_name")
#' @param search.drug The name of the drug (Ex. "ibuprofen")
#' @return A list with the results of scraping the API
#' @details Output of this function is often very complicated and impossible to work with as some of the lists contain dataframes with list-columns
#' @examples 
#' \dontrun{
#' query("generic_name", "ibuprofen")
#' }
#' @seealso 
#'  \code{\link[openfda]{fda_query}},\code{\link[openfda]{fda_api_key}},\code{\link[openfda]{fda_limit}},\code{\link[openfda]{fda_skip}},\code{\link[openfda]{fda_filter}},\code{\link[openfda]{fda_search}},\code{\link[openfda]{fda_exec}}
#'  \code{\link[purrr]{keep}}
#' @rdname query
#' @export 
#' @importFrom openfda fda_query fda_api_key fda_limit fda_skip fda_filter fda_search fda_exec
#' @importFrom purrr discard
query <- function(search.list, search.drug) {
    
    limit <- 100
    
    .query_text  <- function(search.list, search.drug, lim = 100, skip){
        openfda::fda_query("/drug/ndc.json") %>% 
        openfda::fda_api_key("kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy") %>% 
        openfda::fda_limit(lim) %>% 
        openfda::fda_skip(skip) %>% 
        openfda::fda_filter(search.list, search.drug) %>% 
        openfda::fda_search() %>% 
        openfda::fda_exec()
    }
    
    queried <- .query_text(search.list, search.drug, skip = 0)
    # checking to make sure some data was found
    if(is.null(queried)) {
        stop(paste("One of either", search.list, "or", search.drug, "is incorrectly spelt OR this combination of name-type and drug does not exist within the openFDA database"))
    }
    
    
    # looping to get all data
    if (nrow(queried) != 100) {
        return(queried)
    } else {
        skip <- limit
        output_list <- vector("list", length = 100)
        output_list[[1]] <- queried
        index <- 2
        while (nrow(queried) == 100) {
            output_list[[index]] <- .query_text(search.list, search.drug, skip = skip)
            queried <- output_list[[index]]
            skip <- 100 * index
            index <- index + 1
        } 
        output_list <- purrr::discard(output_list, is.null)
        return(output_list)
    }  
     
}


#' @title Handles the API's strange API output format
#' @description Turn API's output into a list of clean (though not necessarily tidy) dataframes wherein each entry in one pull from the API
#' @param queried.df The output of the \code{\link{query}} function
#' @return List of clean dataframes. Each entry is one API pull
#' @details DETAILS
#' @examples 
#' \dontrun{
#' x <- query("generic_name", "ibuprofen")
#' dataframed_unique(x)
#' }
#' @seealso 
#'  \code{\link[dplyr]{select}}
#'  \code{\link[purrr]{map}}
#'  \code{\link[tidyr]{unnest_longer}}
#' @rdname dataframed_unique
#' @export 
#' @importFrom dplyr select
#' @importFrom purrr map
#' @importFrom tidyr unnest_longer
dataframed_unique <- function(queried.df) {
    
    output_type <- inherits(queried.df, "data.frame")

    if(output_type) {
        output_df <- queried.df %>% 
            dplyr::select(-openfda) %>% 
            tidyr::unnest_longer(packaging)
        return(output_df)
    }
    
    output_df <- queried.df %>% 
        purrr::map(dplyr::select, -openfda) %>% 
        purrr::map(tidyr::unnest_longer, packaging)
    return(output_df)
    # for some reason the data for each individual is hidden inside packaging.
    
}




