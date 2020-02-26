#devtools::install_github("ropenhealth/openfda")

library(openfda)
library(tidyverse)


# this works. 
# TURNS OUT THAT THERE IS ALL THE INFO IF YOU ARE WILLING TO LOOK WITHIN THE PACKAGING DATASET!!
x = fda_query("/drug/ndc.json") %>% 
    fda_api_key("kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy") %>% 
    fda_limit(5) %>% 
    fda_filter("generic_name","ustekinumab") %>% 
    fda_search() %>% 
    fda_exec()

df <- 
    x$packaging %>% 
    bind_rows() %>% 
    as_tibble()
    
    
# str_c(x, )

y = fda_query("/drug/ndc.json") %>% 
    fda_api_key("kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy") %>% 
    fda_filter("generic_name", "methotrexate") %>% 
    # fda_count("generic_name") %>% 
    fda_search() %>% 
    fda_exec()
y = fda_query("/drug/ndc.json") %>% 
    fda_api_key("kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy") %>% 
    # fda_filter("generic_name", "methotrexate") %>% 
    fda_count("brand_name") %>% 
    fda_exec()

 # https://api.fda.gov/drug/label.json?search=humira&skip=3&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy
#this gives 15


# Need to figure out how to get all the (all the entries) into the data


df <- as_tibble(x) %>% 
    select(-openfda)
