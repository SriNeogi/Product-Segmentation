
# Dataset
*Sample deals data containing row-wise time series data. The first 2 columns (Market and Sales Product) are non-numerical columns, so we remove them, run the Kmeans cluster model on the numerical matrix and then add them back at the end. 
*The features used for Kmeans analysis are Mean Volume and Coefficient of variation. 

# Libraries
library(dplyr)
library(tidyverse)
library(stringr)
library(padr)
library(pracma)
library(cluster)
library(factoextra)



# Contributing
If you'd like to contribute to this project, please open an issue or submit a pull request. Your contributions are greatly appreciated!
