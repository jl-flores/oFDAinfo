
source("open_fda_functions.R")

ust <- find_ndc("generic_name", "ustekinumab")
hum <- find_ndc("brand_name", "humira")

bind_rows(ust,hum)


write.csv(ust, "hello")

dimnames(ust)

ust2 <- ust %>% select_if(Negate(is.list))

poop <- ust %>% 
    mutate(package_ndc = as.character(packaging$package_ndc),
           marketing_start_date = as.character(packaging$marketing_start_date),
           description = as.character(packaging$description),
           sample = as.character(packaging$sample)) %>% 
    select(-packaging)
           
poop <- poop %>% select(tidyselect::any_of(c("generic_name","brand_name", "package_ndc",
                                     "product_ndc", "brand_name_base", "labeler_name", "route", 
                                     "dosage_form", "description")
                                   )
                )

if("route" %in% names(poop)) {
    poop <- poop %>% mutate(route = as.character(route))
}
