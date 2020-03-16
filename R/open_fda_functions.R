

find_ndc <- function(name.category, name) {
    #this executes the search
    run <- query(name.category, name)
    df_run <- dataframed_unique(run)
    return(df_run)
}




query <- function(search.list, search.drug, limit = 100, skip = 0) {
    # this function takes a search.list (like "generic_name" or "brand_name")
    # and then the name of the drug you are interested in and outputs a
    # dataframe from the openfda
    .query_text  <- function(search.list, search.drug, limit = 100, skip){
        openfda::fda_query("/drug/ndc.json") %>% 
        openfda::fda_api_key("kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy") %>% 
        openfda::fda_limit(limit) %>% 
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


dataframed_unique <- function(queried.df) {
    # This function takes the out output of a drug query and turns it into a
    # database where each row is different drug entry
    
    output_type <- inherits(queried.df, "data.frame")

    # if the data came from multiple (looping queries I need to map this
    # function onto multiple argumen    ts)
    if(output_type) {
        output_df <- queried.df %>% 
            dplyr::select(-openfda) %>% 
            dplyr::unnest_longer(packaging)
        return(output_df)
    }
    
    output_df <- queried.df %>% 
        purrr::map(select, -openfda) %>% 
        purrr::map(tidyr::unnest_longer, packaging)
    return(output_df)
    # for some reason the data for each individual is hidden inside packaging.
    
}




