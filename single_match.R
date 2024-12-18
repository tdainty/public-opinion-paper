if(!require(tinytex)) install.packages(install.packages("tinytex"))
if(!require(fuzzyjoin)) install.packages(install.packages("fuzzyjoin"))
if(!require(dplyr)) install.packages(install.packages("dplyr"))
if(!require(stringdist)) install.packages(install.packages("stringdist"))
if(!require(vctrs)) install.packages(install.packages("vctrs"))
if(!require(furrr)) install.packages(install.packages("furrr"))
if(!require(tidyverse)) install.packages(install.packages("tidyverse"))

library(fuzzyjoin); library(dplyr); library(stringdist); library(tidyverse)



getwd()
setwd("C:/Users/tdain/OneDrive/Desktop/R Data/Borders and Public Opinion Paper/public-opinion-paper/data")


a <- read.csv("centroid_with_borders.csv")

b <- read.csv("WVS_province_key.csv")
names(b) <- c("S007", "S007_01", "S009", "Dist_Name", "Country", "Prov_Country")

b = b[!(b$Dist_Name %in% "other"),]

a$Prov_Country <- paste(a$Dist_Name, a$C_Name, sep = "-")

a_fuzzy <- data.frame(a$Prov_Country, a$NEAR_DIST)
b_fuzzy <-data.frame(b$Prov_Country)
b_fuzzy <- b_fuzzy %>% distinct(b$Prov_Country)


t <- fuzzy_inner_join(a_fuzzy, b_fuzzy, 
                      match_fun = list(function(x,y) stringdist(x,y, 
                                                                method="osa") < 6, 
                                       `==`, 
                                       function(x,y) str_detect(x,y)),
                      by = c("Prov_Country"))


result <- stringdist_join(a_fuzzy, b_fuzzy, 
                          by = "Prov_Country",
                          mode = "left",
                          ignore_case = FALSE, 
                          method = "jw", 
                          max_dist = 99, 
                          distance_col = "dist") %>%
  group_by(Prov_Country.x) %>%
  slice_min(order_by = dist, n = 1)



joined_result <- stringdist_join(a_fuzzy, b_fuzzy, 
                                 by = "Prov_Country",
                                 mode = "left",
                                 ignore_case = FALSE, 
                                 method = "jw", 
                                 max_dist = 99, 
                                 distance_col = "dist")

