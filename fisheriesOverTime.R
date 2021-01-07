# Fisheries status over time bubble chart

# About ####
# Produces a bubble chart of fisheries status over time by country using historical data from
# the capture fisheries database documented in Costello, C., Ovando, D., Clavelle, T., Strauss, C. K., 
# Hilborn, R., Melnychuk, M. C., ... & Leland, A. (2016). Global fishery prospects under 
# contrasting management regimes. Proceedings of the national academy of sciences, 113(18), 5125-5129.

# Obtaining the database ####
# The version of the database used can be obtained from https://datadryad.org/stash/dataset/doi:10.25349/D96G6H.
# This was a version uploaded for use with a subsequent paper.

# The database required from the repository is 'ProjectionData.csv'.

# Load required packages ####
library(tidyverse)
library(gganimate)
library(ggflags)
library(countrycode)
library(latex2exp)
library(scales)

# Load data ####

# Assumes 'ProjectionData.csv' is in the base working directory
data <- read.csv("ProjectionData.csv")

# Process data ####

# Manipulate data format
mean.data <- data %>% 
  filter(Year <= 2012) %>% # Historical data ends in 2012
  filter(Year >= 1960) %>% 
  drop_na(Catch, FvFmsy, BvBmsy) # Removes rows in which there is at least 1 NA in any of Catch, FvFmsy, or BvBmsy. Prevents problems with plotting below, although may skew results if rows with NA correlate with certain fisheries
  group_by(Country, Year) %>% 
  summarise(mean.BvBmsy = mean(BvBmsy, na.rm=TRUE), 
            mean.FvFmsy = mean(FvFmsy, na.rm=TRUE),
            tot.Catch = sum(Catch, na.rm=TRUE))

# Change country names to format recognisable by geom_flag
mean.data$Country <- tolower(countryname(mean.data$Country, destination = "iso2c", warn = TRUE)) # Warning indicates states/classifications presently excluded from results unless manual solution is implemented

# Remove rows in which "Country" could not be reclassified
mean.data <- mean.data %>% 
  drop_na()

# Plot data ####

plot <- ggplot(mean.data, aes(x = mean.BvBmsy, y = mean.FvFmsy, alpha = 0.7, country = Country, size = tot.Catch)) +
  geom_flag(aes(alpha = 0.7)) +
  geom_hline(yintercept = 1, linetype = "dotted") +
  geom_vline(xintercept = 1, linetype = "dotted") +
  labs(y = TeX("$\\frac{\\textit{F}}{\\textit{F_{MSY}}}"),
       x = TeX("$\\frac{\\textit{B}}{\\textit{B_{MSY}}}")) +
  scale_y_log10(labels = comma, limits = c(0.1, 12)) +
  scale_size(name = "Catch (t)", range = c(2,12), labels = comma) +
  guides(country = "none")

animation <- plot + 
  transition_time(Year) +
  labs(title = "Year: {frame_time}") + 
  ease_aes('linear')+
  enter_fade() +
  exit_fade()
  
animate(animation, fps = 25, duration = 20, end_pause = 125, height = 4, width = 6, res = 225, units = "in")

anim_save("animation.gif", animation = last_animation(), path = NULL)