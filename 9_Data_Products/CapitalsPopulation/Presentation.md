Capitals of the World and their Population
========================================================
author: Gerardo Mondragón
date: August 20th, 2020
autosize: true

Overview
========================================================

I have built an interactive plot using the **plotly** package in R. This plot displays the population of all the capital cities in the world, as grouped by continent. One can select which continents to display/hide. 

When you hover on top of a specific point, a bubble pops up with the specific population, capital and country it belongs to. 

The Data
========================================================

The data is a csv that I have previously used for the weekly assignments in this course. You can of course download it from my Github repository in the */9_Data_Products/Project/* directory. It is basically a merge of two dataframes, one containing the capitals of the countries and their continent, and another which contains the population. Since there were some discrepancies in the data (such as countries that have recently changed their capital), a manual revision and correction of these entries was made. 

Reading the Data
========================================================

The plotting process in itself is very simple using reactive code from Shiny. However, in order to properly display the plot in [shinyapps.io](https://jerrymn.shinyapps.io/CapitalsPopulation/), *read_csv* (from the *readr* package) was used in place of the traditional *read.csv*. This is due to non-ASCII characters in the dataset. 


```r
library(readr)
capitals <- read_csv("capitals.csv", locale = locale(encoding = "Latin1"))
head(capitals)
```

```
# A tibble: 6 x 4
  Capital     Country              Continent Population
  <chr>       <chr>                <chr>          <dbl>
1 Abu Dhabi   United Arab Emirates Asia          585097
2 Abuja       Nigeria              Africa        778567
3 Accra       Ghana                Africa       1640507
4 Adamstown   Pitcairn Islands     Australia         56
5 Addis Ababa Ethiopia             Africa       3040740
6 Algiers     Algeria              Africa       3415811
```

The Plot
========================================================

Here the plot is not as interactive as in [shinyapps.io](https://jerrymn.shinyapps.io/CapitalsPopulation/), but hopefully you can get an idea. 

![plot of chunk unnamed-chunk-2](Presentation-figure/unnamed-chunk-2-1.png)
