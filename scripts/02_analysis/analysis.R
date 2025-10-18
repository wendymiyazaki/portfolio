################################################################################
# Nurse color analysis
################################################################################
#
# Wendy Miyazaki
# wxm344@miami.edu
# 10/16/2025
#
# This is assignment 2 and I am starting to do some analysis and develop some 
# plots that I can use for my final project.
#
################################################################################

# SET UP #######################################################################

# Load packages 
library(ggplot2)

# Load data
data(data = nurse_color)

# Calculate average brightness
data_nurse_summary <- data_nurse |>
  group_by(photo_type) |>
  summarize(avg_brightness = mean(br, na.rm = TRUE),
            sd_brightness = sd(br, na.rm = TRUE),
            count = n())

library(ggplot2)

ggplot(data_nurse, aes(x = h, y = br, color = color_shade)) +
  geom_point(alpha = 0.7, size = 3) +
  scale_color_manual(values = c("dark" = "gray20", "medium" = "gray70", "light" = "gray95")) +
  labs(x = "Hue (H)", y = "Brightness (Br)", color = "Color Shade",
       title = "Brightness vs Hue of Nurse Shark Colors") +
  theme_minimal()
