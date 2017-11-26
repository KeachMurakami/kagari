<!-- README.md is generated from README.Rmd. Please edit that file -->
kagari (縢り)
=============

kagari organizes individual data from various measuring instruments into tidy dataset.

You can install:

-   the latest development version from github with

``` r
# install.packages("devtools") # if not installed
devtools::install_github("KeachMurakami/kagari")
```

Reading
-------

`read_***` handles raw data obtained by the `***`---a name of software or device:

-   `read_field_lambda()`: read `.csv` format data obtained by color viewer for field-lambda

<!-- ```{r demo_read} -->
<!-- library(gasexchangeR) -->
<!-- sample_single <- "https://raw.githubusercontent.com/KeachMurakami/gasexchangeR/master/R/LI6400.txt" -->
<!-- sample_multi <- c("https://raw.githubusercontent.com/KeachMurakami/gasexchangeR/master/R/LI6400.txt", -->
<!--                   "https://raw.githubusercontent.com/KeachMurakami/gasexchangeR/master/R/LI6400XT.txt") -->
<!-- # simple read -->
<!-- read_licor(file = sample_single) -->
<!-- # include logs for changes in conditions -->
<!-- read_licor(file = sample_single, info_log = T) -->
<!-- # read multiple files into a data frame -->
<!-- read_licor(file = sample_multi) -->
<!-- ``` -->
<!-- ## Visualizations -->
<!-- `gasexchangeR` implements the following verbs useful for visualizations: -->
<!-- * `li_scat()`: view a relationship between variables -->
<!--     * `li_scat_light()`: -->
<!--     * `li_scat_co2()`: -->
<!--     * `li_scat_h2o()`: -->
<!--     * `li_scat_temp()`: -->
<!-- * `li_course()`: view time course of a variable -->
<!-- * `li_check()`: view primitive plots to check the environmental stability during the measurement -->
<!-- ```{r demo_plot} -->
<!-- li_scat(file = sample_multi, color = "VpdL") -->
<!-- li_course(file = sample_multi, color = "Ci") -->
<!-- ``` -->
Session information
-------------------

``` r
devtools::session_info()
#> Session info --------------------------------------------------------------
#>  setting  value                       
#>  version  R version 3.3.1 (2016-06-21)
#>  system   x86_64, darwin13.4.0        
#>  ui       X11                         
#>  language (EN)                        
#>  collate  en_US.UTF-8                 
#>  tz       Asia/Tokyo                  
#>  date     2017-11-26
#> Packages ------------------------------------------------------------------
#>  package   * version date       source                          
#>  backports   1.0.4   2016-10-24 cran (@1.0.4)                   
#>  devtools    1.12.0  2016-06-24 CRAN (R 3.3.0)                  
#>  digest      0.6.12  2017-01-27 cran (@0.6.12)                  
#>  evaluate    0.10.1  2017-06-24 cran (@0.10.1)                  
#>  htmltools   0.3.6   2017-04-28 cran (@0.3.6)                   
#>  knitr       1.17    2017-08-10 cran (@1.17)                    
#>  magrittr    1.5     2014-11-22 CRAN (R 3.3.1)                  
#>  memoise     1.0.0   2016-01-29 CRAN (R 3.3.1)                  
#>  Rcpp        0.12.13 2017-09-28 CRAN (R 3.3.2)                  
#>  rmarkdown   1.6     2017-06-15 CRAN (R 3.3.2)                  
#>  rprojroot   1.2     2017-01-16 cran (@1.2)                     
#>  stringi     1.1.5   2017-04-07 cran (@1.1.5)                   
#>  stringr     1.2.0   2017-02-18 cran (@1.2.0)                   
#>  withr       2.0.0   2017-08-08 Github (jimhester/withr@190d293)
#>  yaml        2.1.14  2016-11-12 cran (@2.1.14)
```
