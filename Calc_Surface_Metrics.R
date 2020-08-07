## Calculate surface metrics

## Clean Global Environment 
rm(list=ls())

# load libraries
library(geodiv)
library(raster)
library(sp)
library(tidyverse)

## Load source
source("source_gsm_geodiv.R")

#### Set projection settings before running the script ####
A=make_EPSG()
LL_prj <- as.character(subset(A, A$code=="4326")[3]) 
UTM_prj <- as.character(subset(A, A$code=="5383")[3]) 

## Set names
project_name = "charinus"
raster_name = "elevation"

#### Load data ####
# # load the clippings
clippings_elev <- readRDS("./ellipsoid_landscapes/clippings_flatten_elevation.rds")

#### Specify metrics ####
## Make list to choose which surface metrics to calculate
## Not running yet

#suface_metric_sub <- c("sa", 
#                       "ssk", 
#                       "std", 
#                       "stdi")


# Calculate metrics locally but overall printing progress
gsm <- calculate_gsm(clippings_elev)

# May take a while to run, so save your results as RData to load them later
#save(gsm, file="./gsm_results/gsm_elevation.RData")
#load(file="./gsm_results/gsm_elevation.RData")

# Bind to one dataframe
gsm_data <- dplyr::bind_rows(gsm)
head(gsm_data)

## Save data
write.csv(gsm_data, paste0("./gsm_results/gsm_data_", raster_name, "_", project_name, ".csv"), row.names = F)

## Obs: ainda preciso voltar com as colunas de IDs das cavernas, e depois fazer a correspondência para IDs dos indivíduos (copiar os mesmsos valores para os pares de cavernas repetidos).

##The end
