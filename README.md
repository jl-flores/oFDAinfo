
<!-- README.md is generated from README.Rmd. Please edit that file -->

# oFDAinfo

<!-- badges: start -->

<!-- badges: end -->

The goal of oFDAinfo is to pull drug data from the [openFDA
API](https://open.fda.gov/). I use it to find their package-NDC code,
though there are many other uses.

## Installation

This package relies heavily on the
[openfda](https://github.com/ropenhealth/openfda) package, which must be
installed prior to downloading oFDAinfo. You can install the development
version of oFDAinfo from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ropenhealth/openfda")
devtools::install_github("jonahgorodensky/oFDAinfo")
```

## Example

At its most basic there is only one function of interest, `ndc_query`,
which both pulls from the API and cleans the data into one dataframe.

``` r
library(oFDAinfo)
## basic example code
drugs_of_interest <- list(c("generic_name", "methotrexate"), 
                          c("brand_name", "humira")
                          )
output <- ndc_query(drugs_of_interest,  csv = FALSE)
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:methotrexate&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=brand_name:humira&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100
output
#> # A tibble: 157 x 9
#>    product_ndc generic_name labeler_name brand_name dosage_form route
#>    <chr>       <chr>        <chr>        <chr>      <chr>       <chr>
#>  1 69238-1423  Methotrexate Amneal Phar… Methotrex… TABLET      ORAL 
#>  2 69238-1423  Methotrexate Amneal Phar… Methotrex… TABLET      ORAL 
#>  3 63323-122   METHOTREXAT… Fresenius K… Methotrex… INJECTION,… "c(\…
#>  4 63323-123   METHOTREXAT… Fresenius K… Methotrex… INJECTION,… "c(\…
#>  5 67253-320   METHOTREXATE Par Pharmac… METHOTREX… TABLET      ORAL 
#>  6 67253-320   METHOTREXATE Par Pharmac… METHOTREX… TABLET      ORAL 
#>  7 67457-466   Methotrexate Mylan Insti… Methotrex… INJECTION   "c(\…
#>  8 67457-480   Methotrexate Mylan Insti… Methotrex… INJECTION   "c(\…
#>  9 68382-775   Methotrexate Zydus Pharm… Methotrex… TABLET      ORAL 
#> 10 68382-775   Methotrexate Zydus Pharm… Methotrex… TABLET      ORAL 
#> # … with 147 more rows, and 3 more variables: brand_name_base <chr>,
#> #   package_ndc <chr>, description <chr>
```

Assuming the same type (eg. generic\_name or brand\_name) it is equally
possible to run `ndc_query(c("generic_name","drug1+drug2")` or
`ndc_query(c("generic_name","drug1"), c("generic_name","drug2")`. Though
the first is more concise I prefer the second as, although the outputs
are equivalent, the ordering of the rows is more predictable when each
drug is given its own
call.

``` r
first <- ndc_query(list(c("generic_name", "ibuprofen"), c("generic_name","ustekinumab")), csv = FALSE)
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=100 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=200 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=300 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=400 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=500 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=600 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=700 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=800 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=900 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=1000 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=1100 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=1200 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=1300 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100
second <- ndc_query(list(c("generic_name", "ibuprofen+ustekinumab")), csv = FALSE)
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=100 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=200 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=300 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=400 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=500 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=600 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=700 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=800 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=900 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=1000 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=1100 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=1200 
#> Fetching: https://api.fda.gov/drug/ndc.json?search=generic_name:ibuprofen+ustekinumab&api_key=kwBweTyY0zxYfj27l7t6P7o68nSdxYaBspGyoBBy&limit=100&skip=1300

dplyr::all_equal(first, second, ignore_row_order = TRUE)
#> [1] TRUE
dplyr::all_equal(first, second, ignore_row_order = FALSE)
#> [1] "Same row values, but different order"
```
