devtools::install_github("ropenhealth/openfda")

library(openfda)

x = fda_query("/drug/ndc.json") %>% 
    fda_api_key("kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy") %>% 
    fda_limit(5) %>% 
    fda_filter("generic_name","ustekinumab") %>% 
    fda_search() %>% 
    fda_exec()
# str_c(x, )

    fda_exec()
y = fda_query("/drug/ndc.json") %>% 
    fda_api_key("kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy") %>% 
    fda_filter("generic_name", "methotrexate") %>% 
    fda_count("generic_name") %>% 
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

looking <- read_tsv("Desktop/package.txt")
