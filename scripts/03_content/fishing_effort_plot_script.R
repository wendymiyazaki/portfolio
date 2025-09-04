# Load packages 
library(EVR628tools)
library(tidyverse)

# Load data
data("data_fishing_effort")

# Create a simple plot
p <- ggplot(data_fishing_effort,
       aes(x = month, y = effort_hours)) +
  geom_point()

# Save plot
ggsave(plot = p, filename = "results/img/first_plot.png")