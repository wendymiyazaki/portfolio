################################################################################
# Assignment 4: Visualizing spatial data
################################################################################
#
# Wendy Miyazaki
# wxm344@miami.edu
# 11/13/25
#
# This is assignment 4 and is the script for my spatial data visualization for 
# my project. I am going to be producing a map with the different catch sites of
# the nurse sharks that I have sampled for my project. 
#
###############################################################################

# SET UP #######################################################################

# Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)
library(stringr)
library(sf) 
library(ggspatial)
library(rnaturalearth)
library(mapview)

# LOAD DATA -------------------------------------------------------------------
# Load the cleaned nurse_color.rds
nurse_color <- read_rds("data/processed/nurse_color.rds")

# Load the CatchSiteCoordinates.csv
catch_sites <- read_csv("data/raw/CatchSiteCoordinates.csv") |> 
  clean_names() |> 
  select(tag, site, gps_start) |> 
  filter(tag %in% nurse_color$tag)

# PROCESSING ##################################################################
# Join the site info to the nurse_color dataset
nurse_color_full <- nurse_color |>
  left_join(catch_sites, by = "tag") |> 
  drop_na(site, gps_start) |> 
  distinct(tag, .keep_all = TRUE) 

# GPS conversion to longitude and latitude 
convert_gps_simple <- function(x) {parts <- str_split(x, " ", simplify = TRUE)
  lat_raw <- parts[1]
  lon_raw <- parts[2]
  # Extract degrees and minutes
  lat_deg <- as.numeric(str_extract(lat_raw, "\\d+(?=')"))
  lat_min <- as.numeric(str_extract(lat_raw, "(?<=')\\d+\\.\\d+"))
  lon_deg <- as.numeric(str_extract(lon_raw, "\\d+(?=')"))
  lon_min <- as.numeric(str_extract(lon_raw, "(?<=')\\d+\\.\\d+"))
  # Convert to decimal degrees
  lat <- lat_deg + lat_min / 60
  lon <- -(lon_deg + lon_min / 60)
  tibble(latitude = lat, longitude = lon)}

# Apply conversion to all gps_start entries
coords <- map_dfr(nurse_color_full$gps_start, convert_gps_simple)

# Add coordinates to dataset
nurse_color_full <- bind_cols(nurse_color_full, coords)

# Remove gps_start column
nurse_color_full <- nurse_color_full |>
  select(-gps_start)

# Summarize by catch site (one point per site)
catch_sites_sf <- nurse_color_full |> 
  group_by(site) |> 
  summarize(
    longitude = mean(longitude),
    latitude = mean(latitude),
    .groups = "drop") |> 
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

# Inspect data 
mapview(catch_sites_sf)

# Get world coastline for context
coast <- ne_countries(scale = "medium", returnclass = "sf")

# VISUALIZE ####################################################################
# Set limits to zoom in around your catch sites
xlims <- range(st_coordinates(catch_sites_sf)[,1]) + c(-0.1, 0.1)
ylims <- range(st_coordinates(catch_sites_sf)[,2]) + c(-0.1, 0.1)

# Create even x-axis breaks
x_breaks <- pretty(xlims, n = 4)

# Create my map
p <- ggplot() +
  # Base layer
  geom_sf(data = coast, fill = "gray", color = "black", linewidth = 0.3) +
  geom_sf(data = catch_sites_sf, aes(color = site), size = 4) +
  # Zoom in to just the catch sites
  coord_sf(xlim = xlims, ylim = ylims, expand = FALSE) +
  scale_x_continuous(breaks = x_breaks) +
  scale_y_continuous() +
  scale_color_viridis_d(option = "turbo") + 
  theme_bw() +
  annotation_north_arrow(location = "tl") +
  annotation_scale(location = "bl") +
  labs(
    title = "Catch locations for sampled nurse sharks",
    x = "Longitude (°)",
    y = "Latitude (°)",
    color = "Catch site",
    caption = "Data sources: Nurse shark dataset recorded in the field") +
  theme(
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 1),
    axis.text.x = element_text(angle = 0, vjust = 0.5))

# EXPORT #######################################################################
ggsave(plot = p,
       filename = "results/img/catch_sites_map.png",
       width = 8,
       height = 6)