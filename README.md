<!-- README.md is generated from README.Rmd. Please edit that file -->
kagari (縢り)
=============

This package organizes individual data from various measuring instruments into tidy dataset. `kagari` is a Japanese word meaning sew (c.f [和綴じ](https://www.google.co.jp/search?q=%E5%92%8C%E7%B6%B4%E3%81%98&source=lnms&tbm=isch)). The author hope to sew a user-friendly book---i.e. tidy dataset---from individual pages---i.e. messy raw data.

You can install:

-   the latest development version from github with

``` r
# install.packages("devtools") # if not installed
devtools::install_github("KeachMurakami/kagari")
```

Prerequisite
------------

``` r
library(tidyverse)
library(kagari)
#> 
#>  Some coefficient for ‘Oxygen electrode measurements’ were attached
```

Data load
---------

`read_***` deals with raw data obtained by `***`---a name of the software or the device:

-   `read_li6400()`: reads `.txt`/`.csv`/`.tsv` format data obtained by LI6400/LI6400XT (LI-COR) with Xterm.

-   `read_junior_pam()`: reads `.csv` format data obtained by JUNIOR-PAM (Heinz Walz) with WinControl.

-   `read_field_lambda()`: reads `.csv` format data obtained by field-lambda with color viewer.

-   `read_color_reader()`: reads `.csv` format data obtained by CR-10 Plus (Konica Minolta).

The first argument is always a file path. The output is wide format data containing the measured variables and measured times.

Data manipulation
-----------------

`mutate_***` calculates parameters from raw data obtained by `***`---a name of the software or the device---and adds new columns to the input `tibble`.

-   `mutate_oxy()`: calculates and adds maximum gross photosynthetic O<sub>2</sub> evolution rate, functional PSII content, and cytochrome content from data obtained by liquid phase oxygen electrode system (Hansatech) with single-turnover.

``` r
tibble(o2_calibration = c(1.3, 1.31),
       pn_under_saturing_irradiance = c(.3, .51),
       pn_under_dark = c(-.11, -.05),
       pn_under_fr_and_flash = c(.1, .09),
       pn_under_fr = c(-.002, 0)) %>%
  mutate_oxy(.tbl = ., calb = o2_calibration,
             positive_pmax = pn_under_saturing_irradiance, negative_pmax = pn_under_dark,
             positive_psii = pn_under_fr_and_flash, negative_psii = pn_under_fr,
             leaf_area = 2.22*10^-4, hz = 10) %>%
  knitr::kable(format = "markdown")
```

<table>
<colgroup>
<col width="12%" />
<col width="23%" />
<col width="11%" />
<col width="17%" />
<col width="10%" />
<col width="7%" />
<col width="8%" />
<col width="8%" />
</colgroup>
<thead>
<tr class="header">
<th align="right">o2_calibration</th>
<th align="right">pn_under_saturing_irradiance</th>
<th align="right">pn_under_dark</th>
<th align="right">pn_under_fr_and_flash</th>
<th align="right">pn_under_fr</th>
<th align="right">pmax</th>
<th align="right">psii</th>
<th align="right">cytf</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="right">1.30</td>
<td align="right">0.30</td>
<td align="right">-0.11</td>
<td align="right">0.10</td>
<td align="right">-0.002</td>
<td align="right">19.99018</td>
<td align="right">0.8395877</td>
<td align="right">0.4794487</td>
</tr>
<tr class="even">
<td align="right">1.31</td>
<td align="right">0.51</td>
<td align="right">-0.05</td>
<td align="right">0.09</td>
<td align="right">0.000</td>
<td align="right">33.53936</td>
<td align="right">0.7216268</td>
<td align="right">0.8940091</td>
</tr>
</tbody>
</table>

The first argument is always a tibble.

Session information
-------------------

``` r
devtools::session_info()
#> Session info -------------------------------------------------------------
#>  setting  value                       
#>  version  R version 3.5.0 (2018-04-23)
#>  system   x86_64, darwin15.6.0        
#>  ui       X11                         
#>  language (EN)                        
#>  collate  en_US.UTF-8                 
#>  tz       Australia/Brisbane          
#>  date     2018-07-18
#> Packages -----------------------------------------------------------------
#>  package    * version    date       source                               
#>  assertthat   0.2.0      2017-04-11 CRAN (R 3.5.0)                       
#>  backports    1.1.2      2017-12-13 CRAN (R 3.5.0)                       
#>  base       * 3.5.0      2018-04-24 local                                
#>  bindr        0.1.1      2018-03-13 CRAN (R 3.5.0)                       
#>  bindrcpp   * 0.2.2      2018-03-29 CRAN (R 3.5.0)                       
#>  broom      * 0.4.4.9000 2018-06-21 Github (tidyverse/broom@2721de4)     
#>  cellranger   1.1.0      2016-07-27 CRAN (R 3.5.0)                       
#>  cli          1.0.0      2017-11-05 CRAN (R 3.5.0)                       
#>  colorspace   1.3-2      2016-12-14 CRAN (R 3.5.0)                       
#>  compiler     3.5.0      2018-04-24 local                                
#>  crayon       1.3.4      2017-09-16 CRAN (R 3.5.0)                       
#>  datasets   * 3.5.0      2018-04-24 local                                
#>  devtools   * 1.13.5     2018-02-18 CRAN (R 3.5.0)                       
#>  digest       0.6.15     2018-01-28 CRAN (R 3.5.0)                       
#>  dplyr      * 0.7.5      2018-05-19 CRAN (R 3.5.0)                       
#>  evaluate     0.10.1     2017-06-24 CRAN (R 3.5.0)                       
#>  forcats    * 0.3.0      2018-02-19 CRAN (R 3.5.0)                       
#>  ggplot2    * 3.0.0.9000 2018-07-16 Github (hadley/ggplot2@79e8b45)      
#>  glue         1.2.0      2017-10-29 CRAN (R 3.5.0)                       
#>  graphics   * 3.5.0      2018-04-24 local                                
#>  grDevices  * 3.5.0      2018-04-24 local                                
#>  grid         3.5.0      2018-04-24 local                                
#>  gtable       0.2.0      2016-02-26 CRAN (R 3.5.0)                       
#>  haven        1.1.1      2018-01-18 CRAN (R 3.5.0)                       
#>  highr        0.6        2016-05-09 CRAN (R 3.5.0)                       
#>  hms          0.4.2      2018-03-10 CRAN (R 3.5.0)                       
#>  htmltools    0.3.6      2017-04-28 CRAN (R 3.5.0)                       
#>  httr         1.3.1      2017-08-20 CRAN (R 3.5.0)                       
#>  jsonlite     1.5        2017-06-01 CRAN (R 3.5.0)                       
#>  kagari     * 0.1.0      2018-07-18 Github (KeachMurakami/kagari@6f2bc3c)
#>  knitr      * 1.20       2018-02-20 CRAN (R 3.5.0)                       
#>  lattice      0.20-35    2017-03-25 CRAN (R 3.5.0)                       
#>  lazyeval     0.2.1      2017-10-29 CRAN (R 3.5.0)                       
#>  lubridate  * 1.7.4      2018-04-11 CRAN (R 3.5.0)                       
#>  magrittr   * 1.5        2014-11-22 CRAN (R 3.5.0)                       
#>  MASS       * 7.3-49     2018-02-23 CRAN (R 3.5.0)                       
#>  memoise      1.1.0      2017-04-21 CRAN (R 3.5.0)                       
#>  methods    * 3.5.0      2018-04-24 local                                
#>  modelr       0.1.2      2018-05-11 cran (@0.1.2)                        
#>  munsell      0.4.3      2016-02-13 CRAN (R 3.5.0)                       
#>  nlme         3.1-137    2018-04-07 CRAN (R 3.5.0)                       
#>  pillar       1.2.3      2018-05-25 cran (@1.2.3)                        
#>  pkgconfig    2.0.1      2017-03-21 CRAN (R 3.5.0)                       
#>  plyr         1.8.4      2016-06-08 CRAN (R 3.5.0)                       
#>  purrr      * 0.2.5      2018-05-29 CRAN (R 3.5.0)                       
#>  R6           2.2.2      2017-06-17 CRAN (R 3.5.0)                       
#>  Rcpp         0.12.17    2018-05-18 cran (@0.12.17)                      
#>  readr      * 1.1.1      2017-05-16 CRAN (R 3.5.0)                       
#>  readxl       1.1.0      2018-04-20 CRAN (R 3.5.0)                       
#>  reshape2     1.4.3      2017-12-11 CRAN (R 3.5.0)                       
#>  rlang        0.2.1      2018-05-30 cran (@0.2.1)                        
#>  rmarkdown    1.10       2018-06-11 cran (@1.10)                         
#>  rprojroot    1.3-2      2018-01-03 CRAN (R 3.5.0)                       
#>  rstudioapi   0.7        2017-09-07 CRAN (R 3.5.0)                       
#>  rvest        0.3.2      2016-06-17 CRAN (R 3.5.0)                       
#>  scales       0.5.0      2017-08-24 CRAN (R 3.5.0)                       
#>  stats      * 3.5.0      2018-04-24 local                                
#>  stringi      1.2.3      2018-06-12 cran (@1.2.3)                        
#>  stringr    * 1.3.1      2018-05-10 cran (@1.3.1)                        
#>  tibble     * 1.4.2      2018-01-22 CRAN (R 3.5.0)                       
#>  tidyr      * 0.8.1      2018-05-18 cran (@0.8.1)                        
#>  tidyselect   0.2.4      2018-02-26 CRAN (R 3.5.0)                       
#>  tidyverse  * 1.2.1      2017-11-14 CRAN (R 3.5.0)                       
#>  tools        3.5.0      2018-04-24 local                                
#>  utils      * 3.5.0      2018-04-24 local                                
#>  withr        2.1.2      2018-03-15 CRAN (R 3.5.0)                       
#>  xml2         1.2.0      2018-01-24 CRAN (R 3.5.0)                       
#>  yaml         2.1.19     2018-05-01 cran (@2.1.19)
```
