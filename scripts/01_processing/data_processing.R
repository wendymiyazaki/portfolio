################################################################################
# Data Wrangling
################################################################################
#
# Wendy Miyazaki
# wxm344@miami.edu
# 10/16/2025
#
# This is assignment 2 and I am starting to develop some R script to clean my 
# data that I am using for my final project.

################################################################################

# SET UP #######################################################################

# Load packages 
library(tidyverse)
library(janitor)
library(dplyr)

# Load data
nurse_color <- read_csv("data/raw/NurseColorData.csv") |> 
  clean_names() # Standardize column names to snake_case

# Look at data
view(nurse_color)

# Get to know my data
dim(nurse_color) # Check dimensions
colnames(nurse_color) # Check column names

# Processing ###################################################################

# Remove columns with no data
nurse_color <- nurse_color |>
  select(tag, catch_date, photo_type, photo_wb,
         hex, h, s, br, r, g, b) 

# Remove rows with no data
nurse_color <- nurse_color |> 
  filter(row_number() <= 69)

# Convert character columns to factors 
nurse_color <- nurse_color |>
  mutate(photo_type = as.factor(photo_type),
         photo_wb = as.factor(photo_wb))

# Create new column: average RGB value
nurse_color <- nurse_color |>
  mutate(photo_type = as.factor(photo_type),
         photo_wb = as.factor(photo_wb)) |> 
  mutate(avg_rgb = (r + g + b) / 3)

# Create new column for color categories and assign color categories
nurse_color <- nurse_color |>
  mutate(photo_type = as.factor(photo_type),
         photo_wb = as.factor(photo_wb)) |> 
  mutate(avg_rgb = (r + g + b) / 3, 
         color_shade = case_when(avg_rgb < 70 ~ "dark",
                                 avg_rgb < 120 ~ "medium",
                                 TRUE ~ "light"),
         color_shade = factor(color_shade, 
                              levels = c("dark", 
                                         "medium", "light")))

# Summarize and inspect the cleaned data
glimpse(nurse_color)
summary(nurse_color)
