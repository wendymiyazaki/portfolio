################################################################################
# Data Visualization
################################################################################
#
# Wendy Miyazaki
# wxm344@miami.edu
# 10/27/25
#
# This is assignment 3 and I will be using this script to visualize the data 
# that I cleaned last week. I will be making two plots that help me get started
# on deciding how I want to visualize my data. 
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(cowplot)
library(forcats)
  
## Load data -------------------------------------------------------------------
data_vis <- read_rds("data/processed/nurse_color.rds")

# PROCESSING ###################################################################
data_vis <- data_vis |> 
  mutate(color_shade = str_to_sentence(color_shade),
         color_shade = fct_relevel(color_shade, "Light", "Medium", "Dark"))

# Summarize average hue and average RGB values for each color shade
shade_summary <- data_vis |> 
  group_by(color_shade) |> 
  summarize(mean_hue = mean(h, na.rm = TRUE),
            mean_r = mean(r, na.rm = TRUE),
            mean_g = mean(g, na.rm = TRUE),
            mean_b = mean(b, na.rm = TRUE),
            .groups = "drop") |> 
# Convert the averaged RGB values (0–255) to a hex color
  mutate(representative_color = rgb(mean_r/255, mean_g/255, mean_b/255))

# VISUALIZE ####################################################################

# Build first figure: Mean hue by color shade, bars filled with true colors
p1 <- ggplot(shade_summary, aes(x = mean_hue,
                                y = color_shade,               
                                fill = representative_color)) +
  geom_col(color = "black") +     
  scale_fill_identity() +         
  labs(title = "Mean hue by color shade",
       subtitle = "Bars filled with the true average color per shade",
       x = "Hue (°)",
       y = "Color shade",
       caption = "Data source: Nurse shark color dataset") +
  theme_minimal(base_size = 12)

# Build second figure: Brightness vs. Average RGB, colored by actual observed color
p2 <- data_vis |> 
  arrange(color_shade, h) |>       
  ggplot(aes(x = avg_rgb, y = br)) +
  geom_point(aes(fill = hex),      
             shape = 21, color = "black", size = 4, alpha = 0.9) +
  facet_wrap(~photo_type, scales = "free_x") +  
  scale_fill_identity() +
  labs(title = "Relationship between brightness and average RGB",
       subtitle = "Each point represents a recorded color observation",
       x = "Average RGB intensity",
       y = "Brightness",
       caption = "Data source: Nurse shark color dataset") +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 0, hjust = 0.5), 
    axis.ticks.x = element_line())                         

my_plot <- plot_grid(p1, p2,
                     ncol = 1,
                     labels = c("A)", "B)"))

# EXPORT #######################################################################
ggsave(plot = my_plot,
       filename = "results/img/nurse_color_visualizations.png",
       width = 8,
       height = 10,
       bg = "white")