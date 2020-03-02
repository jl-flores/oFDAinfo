

find_ndc <- function(name.category, name) {
    run <- query(name.category, name)

    # if data was found, run the next step
    df_run <- dataframed_unique(run)
    return(df_run)
}




query <- function(search.list, search.drug, limit = 100, skip = 0) {
    # this function takes a search.list (like "generic_name" or "brand_name")
    # and then the name of the drug you are interested in and outputs a
    # dataframe from the openfda
    require(openfda)
    require(dplyr)
    require(purrr)
    
    .query_text  <- function(search.list, search.drug, limit = 100, skip){
        fda_query("/drug/ndc.json") %>% 
        fda_api_key("kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy") %>% 
        fda_limit(limit) %>% 
        fda_skip(skip) %>% 
        fda_filter(search.list, search.drug) %>% 
        fda_search() %>% 
        fda_exec()
    }
    
    queried <- .query_text(search.list, search.drug, skip = 0)
    # checking to make sure some data was found
    if(nrow(queried) == 0) {
        stop("There are no results for this combination of category and name. 
             Are you sure they are correct?")
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
        output_list <- discard(output_list, is.null)
        return(output_list)
    }  
     
}


dataframed_unique <- function(queried.df) {
    # This function takes the out output of a drug query and turns it into a
    # database where each row is different drug entry
    require(openfda)
    require(dplyr)
    require(tidyr)
    require(purrr)
    
    output_type <- inherits(queried.df, "data.frame")

    # if the data came from multiple (looping queries I need to map this
    # function onto multiple arguments)
    if(output_type) {
        output_df <- queried.df %>% 
            select(-openfda) %>% 
            unnest_longer(packaging)
        return(output_df)
    }
    
    output_df <- queried.df %>% 
        map(select, -openfda) %>% 
        map(unnest_longer, packaging)
    return(output_df)
    # for some reason the data for each individual is hidden inside packaging.
    
}




