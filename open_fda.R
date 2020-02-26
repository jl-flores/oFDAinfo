# Work on this code began February 25th 2020

# AS OF RIGHT NOW THEY BOTH WORK, need to keep checking then move on and make it output the data in some interesting way

hum_broken <- find_ndc("generic_name", "infliximab")
hum_broken <- query("brand_name", "humira")
ust_works <- query("brand_name", "stelara")
ust_works_full <- find_ndc("brand_name", "stelara")
ust_works_full <- find_ndc("brand_name", "ustekinumab")

find_ndc <- function(name.category, name) {
    run <- query(name.category, name)
    # checking to make sure some data was found
    if(length(run) == 0) {
        stop("There are no results for this combination of category and name. 
             Are you sure they are correct?")
    }
    
    # if data was found, run the next step
    df_run <- dataframed_unique(run)
    return(df_run)
}




query <- function(search.list, search.drug) {
    # this function takes a search.list (like "generic_name" or "brand_name")
    # and then the name of the drug you are interested in and outputs a
    # dataframe from the openfda
    require(openfda)
    require(dplyr)
    
    query_text  <- fda_query("/drug/ndc.json") %>% 
        fda_api_key("kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy") %>% 
        fda_limit(100) %>% 
        fda_filter(search.list, search.drug) %>% 
        fda_search() %>% 
        fda_exec()
    return(query_text)
    
}


dataframed_unique <- function(queried.df) {
    # This function takes the out output of a drug query and turns it into a
    # database where each row is different drug entry
    require(openfda)
    require(dplyr)
    require(tidyr)
    
    output_df <- queried.df %>% 
        select(-openfda) %>% 
        unnest_longer(packaging)
        # unnest_longer(route) %>% 
        # unnest_longer(active_ingredients) %>% 
        # select(product_ndc:brand_name, route, product_type:brand_name_base)
        # 
    return(output_df)
}




