## CS 61 - Final Project
## Database Systems
## Carter Kruse

# Creating an animated bar plot that ranks various attributes across seasons.

# If done correctly, you should be able to see the bars actually slide up and down.
# The bar plot should have flipped coordinates, such that the longest bar/highest
# value should always be on top.

install.packages("RMySQL")

library(tidyverse)
library(devtools)
library(gganimate)
library(magick)
library(RMySQL)

# Connecting to the database, with the appropriate details.

database <- dbConnect(MySQL(), user = "root", password = "password", dbname = "premier_league", host = "localhost")

# Query 1
# Is there a relationship between a player's market value and their success, as 
# determined by the number of goals and assists in a given season?

# Retrieving the appropriate data from the database.

query_1 <- "SELECT CONCAT(player_first_name, player_last_name) AS `Player`, player_id AS `Player ID`, squad AS `Squad`, season AS `Season`, market_value AS `Market Value`, goals AS `Goals`, assists AS `Assists`, (goals + assists) AS `Combined` FROM player_season JOIN player_info USING (player_id) JOIN season USING (season_id) JOIN team_info USING (player_season_id) JOIN offensive_stats USING (player_season_id) WHERE position != \"DF\" ORDER BY market_value DESC;"
data_1 <- dbGetQuery(database, query_1)

# Viewing the data set.

glimpse(data_1)

# Sorting the data set, grouping by season and arranging by market value to 
# create a ranking system.

ranked_data_1 <- data_1 %>%
  group_by(Season) %>%
  arrange(Season, desc(`Market Value`)) %>%
  mutate(Rank = as.double(1:n()),
         Season = factor(Season)) %>%
  filter(Rank <= 10)

# Viewing the (ranked) data set.

glimpse(ranked_data_1)

# Basic plot, with a qualitative (discrete) color palette.

ranked_data_1_bar_plot <- ranked_data_1 %>%
  ggplot() +
  geom_col(aes(x = Rank, y = `Market Value`, fill = factor(`Player ID` %% 4), group = `Player ID`), 
           width = 0.8, alpha = 0.8) +
  geom_text(aes(x = Rank, y = -4000000, label = Player, group = `Player ID`),
            hjust = 1, size = 4, color = "#000000", family = "serif") +
  geom_text(aes(x = Rank, y = `Market Value` - 6800000, label = paste0("Goals: ", Goals), group = `Player ID`),
            hjust = 1, size = 4, color = "#000000", family = "serif") +
  geom_text(aes(x = Rank, y = `Market Value` + 3400000, label = paste0("Assists: ", Assists), group = `Player ID`),
            hjust = 0, size = 4, color = "#000000", family = "serif") +
  geom_text(aes(x = Rank, y = `Market Value` + 50000000, label = paste0("($", `Market Value` / 1000000, "M)"), group = `Player ID`),
            hjust = 0, size = 4, color = "#000000", family = "serif") +
  scale_fill_brewer(palette = "Set1") +
  scale_x_reverse() +
  scale_y_continuous(limits = c(-100000000, 240000000)) +
  coord_flip(clip = "off") +
  labs(title = "Premier League - Top 10 Players (By Market Value)", 
       subtitle = "{closest_state}") +
  theme_minimal() +
  theme(legend.position = "none")

ranked_data_1_bar_plot

# Customizing the theme, including the titles, labels, and legend.

ranked_data_1_final_bar_plot <- ranked_data_1_bar_plot +
  theme(panel.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        plot.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        panel.grid = element_blank(),
        #
        title = element_text(color = "#000000", size = 10, family = "serif"),
        axis.title = element_blank(),
        axis.text = element_blank(),
        #
        axis.line.x = element_line(color = "#000000", size = 1),
        axis.line.y = element_blank(),
        axis.ticks = element_blank())

ranked_data_1_final_bar_plot

# The bar chart is animated across the seasons.

animation_1 <- ranked_data_1_final_bar_plot +
  transition_states(Season, transition_length = 2, state_length = 1) +
  enter_fly(x_loc = -20, y_loc = 60000000) +
  exit_fly(x_loc = -20, y_loc = 60000000)

# Displaying and saving the animation.

animate(animation_1, duration = 15, fps = 25)
anim_save("animation_1.gif")

# Query 2
# Which players had the highest "on target" percentage, and which had the highest
# "scoring" percentage?

# Retrieving the appropriate data from the database.

query_2_1 <- "SELECT CONCAT(player_first_name, player_last_name) AS `Player`, player_id AS `Player ID`, squad AS `Squad`, season AS `Season`, (sot / shots) AS `On Target %`, (goals / shots) AS `Scoring %` FROM player_season JOIN player_info USING (player_id) JOIN season USING (season_id) JOIN team_info USING (player_season_id) JOIN offensive_stats USING (player_season_id) WHERE shots > 10 ORDER BY (goals / shots) DESC;"
data_2_1 <- dbGetQuery(database, query_2_1)

# Viewing the data set.

glimpse(data_2_1)

# Sorting the data set, grouping by season and arranging by scoring % to create
# a ranking system.

ranked_data_2_1 <- data_2_1 %>%
  group_by(Season) %>%
  arrange(Season, desc(`Scoring %`)) %>%
  mutate(Rank = as.double(1:n()),
         Season = factor(Season)) %>%
  filter(Rank <= 10)

# Viewing the (ranked) data set.

glimpse(ranked_data_2_1)

# Basic plot, with a qualitative (discrete) color palette.

ranked_data_2_1_bar_plot <- ranked_data_2_1 %>%
  ggplot() +
  geom_col(aes(x = Rank, y = `Scoring %`, fill = factor(`Player ID` %% 4), group = `Player ID`), 
           width = 0.8, alpha = 0.8) +
  geom_text(aes(x = Rank, y = -0.02, label = Player, group = `Player ID`),
            hjust = 1, size = 4, color = "#000000", family = "serif") +
  geom_text(aes(x = Rank, y = `Scoring %` + 0.02, label = paste0("Scoring: ", `Scoring %` * 100, "%"), group = `Player ID`),
            hjust = 0, size = 4, color = "#000000", family = "serif") +
  scale_fill_brewer(palette = "Set1") +
  scale_x_reverse() +
  scale_y_continuous(limits = c(-0.3, 0.6)) +
  coord_flip(clip = "off") +
  labs(title = "Premier League - Top 10 Players (By Scoring %)", 
       subtitle = "{closest_state}") +
  theme_minimal() +
  theme(legend.position = "none")

ranked_data_2_1_bar_plot

# Customizing the theme, including the titles, labels, and legend.

ranked_data_2_1_final_bar_plot <- ranked_data_2_1_bar_plot +
  theme(panel.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        plot.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        panel.grid = element_blank(),
        #
        title = element_text(color = "#000000", size = 10, family = "serif"),
        axis.title = element_blank(),
        axis.text = element_blank(),
        #
        axis.line.x = element_line(color = "#000000", size = 1),
        axis.line.y = element_blank(),
        axis.ticks = element_blank())

ranked_data_2_1_final_bar_plot

# The bar chart is animated across the seasons.

animation_2_1 <- ranked_data_2_1_final_bar_plot +
  transition_states(Season, transition_length = 2, state_length = 1) +
  enter_fly(x_loc = -20, y_loc = 0.1) +
  exit_fly(x_loc = -20, y_loc = 0.1)

# Displaying and saving the animation.

animate(animation_2_1, duration = 15, fps = 25)
anim_save("animation_2_1.gif")

# Query 2
# Which teams had the highest "on target" percentage, and which had the highest
# "scoring" percentage? */

# Retrieving the appropriate data from the database.

query_2_2 <- "SELECT squad AS `Squad`, season AS `Season`, AVG(sot / shots) AS `On Target %`, AVG(goals / shots) AS `Scoring %` FROM player_season JOIN player_info USING (player_id) JOIN season USING (season_id) JOIN team_info USING (player_season_id) JOIN offensive_stats USING (player_season_id) GROUP BY squad, season ORDER BY AVG(goals / shots) DESC;"
data_2_2 <- dbGetQuery(database, query_2_2)

# Viewing the data set.

glimpse(data_2_2)

# Creating a squad id (used for colors).

data_2_2_modified <- data_2_2 %>%
  mutate(`Squad ID` = as.integer(factor(Squad)))

# Viewing the data set.

glimpse(data_2_2_modified)

# Sorting the data set, grouping by season and arranging by scoring % to create
# a ranking system.

ranked_data_2_2 <- data_2_2_modified %>%
  group_by(Season) %>%
  arrange(Season, desc(`Scoring %`)) %>%
  mutate(Rank = as.double(1:n()),
         Season = factor(Season)) %>%
  filter(Rank <= 10)

# Viewing the (ranked) data set.

glimpse(ranked_data_2_2)

# Basic plot, with a qualitative (discrete) color palette.

ranked_data_2_2_bar_plot <- ranked_data_2_2 %>%
  ggplot() +
  geom_col(aes(x = Rank, y = `Scoring %`, fill = factor(`Squad ID` %% 4), group = `Squad ID`), 
           width = 0.8, alpha = 0.8) +
  geom_text(aes(x = Rank, y = -0.02, label = Squad, group = `Squad ID`),
            hjust = 1, size = 4, color = "#000000", family = "serif") +
  geom_text(aes(x = Rank, y = `Scoring %` + 0.02, label = paste0("Scoring: ", `Scoring %` * 100, "%"), group = `Squad ID`),
            hjust = 0, size = 4, color = "#000000", family = "serif") +
  scale_fill_brewer(palette = "Set1") +
  scale_x_reverse() +
  scale_y_continuous(limits = c(-0.3, 0.6)) +
  coord_flip(clip = "off") +
  labs(title = "Premier League - Top 10 Squads (By Scoring %)", 
       subtitle = "{closest_state}") +
  theme_minimal() +
  theme(legend.position = "none")

ranked_data_2_2_bar_plot

# Customizing the theme, including the titles, labels, and legend.

ranked_data_2_2_final_bar_plot <- ranked_data_2_2_bar_plot +
  theme(panel.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        plot.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        panel.grid = element_blank(),
        #
        title = element_text(color = "#000000", size = 10, family = "serif"),
        axis.title = element_blank(),
        axis.text = element_blank(),
        #
        axis.line.x = element_line(color = "#000000", size = 1),
        axis.line.y = element_blank(),
        axis.ticks = element_blank())

ranked_data_2_2_final_bar_plot

# The bar chart is animated across the seasons.

animation_2_2 <- ranked_data_2_2_final_bar_plot +
  transition_states(Season, transition_length = 2, state_length = 1) +
  enter_fly(x_loc = -20, y_loc = 0.1) +
  exit_fly(x_loc = -20, y_loc = 0.1)

# Displaying and saving the animation.

animate(animation_2_2, duration = 15, fps = 25)
anim_save("animation_2_2.gif")

# Query 3
# Which teams were most successful on set pieces (free kicks, corners, penalty 
# kicks, etc)? Does this reflect the impact of specific players?

# Retrieving the appropriate data from the database.

query_3 <- "SELECT squad AS `Squad`, season AS `Season`, SUM(fk_goal) AS `Free Kick Goals`, SUM(pk_scored) AS `PK Goals`, SUM(corners) AS `Corner Goals`, SUM(fk_goal + pk_scored + corners) AS `Combined` FROM player_season JOIN player_info USING (player_id) JOIN season USING (season_id) JOIN team_info USING (player_season_id) JOIN offensive_stats USING (player_season_id) GROUP BY squad, season ORDER BY AVG(fk_goal + pk_scored + corners) DESC;"
data_3 <- dbGetQuery(database, query_3)

# Viewing the data set.

glimpse(data_3)

# Creating a squad id (used for colors).

data_3_modified <- data_3 %>%
  mutate(`Squad ID` = as.integer(factor(Squad)))

# Viewing the data set.

glimpse(data_3_modified)

# Sorting the data set, grouping by season and arranging by combined goals to 
# create a ranking system.

ranked_data_3 <- data_3_modified %>%
  group_by(Season) %>%
  arrange(Season, desc(Combined)) %>%
  mutate(Rank = as.double(1:n()),
         Season = factor(Season)) %>%
  filter(Rank <= 10)

# Viewing the (ranked) data set.

glimpse(ranked_data_3)

# Basic plot, with a qualitative (discrete) color palette.

ranked_data_3_bar_plot <- ranked_data_3 %>%
  ggplot() +
  geom_col(aes(x = Rank, y = Combined, fill = factor(`Squad ID` %% 4), group = `Squad ID`), 
           width = 0.8, alpha = 0.8) +
  geom_text(aes(x = Rank, y = -16, label = Squad, group = `Squad ID`),
            hjust = 1, size = 4, color = "#000000", family = "serif") +
  geom_text(aes(x = Rank, y = `Combined` + 16, label = paste0("Goals: ", Combined), group = `Squad ID`),
            hjust = 0, size = 4, color = "#000000", family = "serif") +
  scale_fill_brewer(palette = "Set1") +
  scale_x_reverse() +
  scale_y_continuous(limits = c(-140, 460)) +
  coord_flip(clip = "off") +
  labs(title = "Premier League - Top 10 Squads (By Set Pieces)", 
       subtitle = "{closest_state}") +
  theme_minimal() +
  theme(legend.position = "none")

ranked_data_3_bar_plot

# Customizing the theme, including the titles, labels, and legend.

ranked_data_3_final_bar_plot <- ranked_data_3_bar_plot +
  theme(panel.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        plot.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        panel.grid = element_blank(),
        #
        title = element_text(color = "#000000", size = 10, family = "serif"),
        axis.title = element_blank(),
        axis.text = element_blank(),
        #
        axis.line.x = element_line(color = "#000000", size = 1),
        axis.line.y = element_blank(),
        axis.ticks = element_blank())

ranked_data_3_final_bar_plot

# The bar chart is animated across the seasons.

animation_3 <- ranked_data_3_final_bar_plot +
  transition_states(Season, transition_length = 2, state_length = 1) +
  enter_fly(x_loc = -20, y_loc = 100) +
  exit_fly(x_loc = -20, y_loc = 100)

# Displaying and saving the animation.

animate(animation_3, duration = 15, fps = 25)
anim_save("animation_3.gif")

# Query 4
# Is there a relationship between a player's age and their market value? Are 
# there outliers with respect to "success"?

# Retrieving the appropriate data from the database.

query_4 <- "SELECT CONCAT(player_first_name, player_last_name) AS `Player`, player_id AS `Player ID`, LEFT(season, 4) - born AS `Age`, squad AS `Squad`, season AS `Season`, market_value AS `Market Value` FROM player_season JOIN player_info USING (player_id) JOIN season USING (season_id) JOIN team_info USING (player_season_id) ORDER BY market_value DESC;"
data_4 <- dbGetQuery(database, query_4)

# Viewing the data set.

glimpse(data_4)

# Sorting the data set, grouping by season and arranging by market value to 
# create a ranking system.

ranked_data_4 <- data_4 %>%
  group_by(Season) %>%
  arrange(Season, desc(`Market Value`)) %>%
  mutate(Rank = as.double(1:n()),
         Season = factor(Season)) %>%
  filter(Rank <= 10)

# Viewing the (ranked) data set.

glimpse(ranked_data_4)

# Basic plot, with a qualitative (discrete) color palette.

ranked_data_4_bar_plot <- ranked_data_4 %>%
  ggplot() +
  geom_col(aes(x = Rank, y = `Market Value`, fill = factor(`Player ID` %% 4), group = `Player ID`), 
           width = 0.8, alpha = 0.8) +
  geom_text(aes(x = Rank, y = -4000000, label = Player, group = `Player ID`),
            hjust = 1, size = 4, color = "#000000", family = "serif") +
  geom_text(aes(x = Rank, y = `Market Value` - 6800000, label = paste0("Age: ", Age), group = `Player ID`),
            hjust = 1, size = 4, color = "#000000", family = "serif") +
  geom_text(aes(x = Rank, y = `Market Value` + 3400000, label = paste0("($", `Market Value` / 1000000, "M)"), group = `Player ID`),
            hjust = 0, size = 4, color = "#000000", family = "serif") +
  scale_fill_brewer(palette = "Set1") +
  scale_x_reverse() +
  scale_y_continuous(limits = c(-100000000, 240000000)) +
  coord_flip(clip = "off") +
  labs(title = "Premier League - Top 10 Players (By Market Value)", 
       subtitle = "{closest_state}") +
  theme_minimal() +
  theme(legend.position = "none")

ranked_data_4_bar_plot

# Customizing the theme, including the titles, labels, and legend.

ranked_data_4_final_bar_plot <- ranked_data_4_bar_plot +
  theme(panel.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        plot.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        panel.grid = element_blank(),
        #
        title = element_text(color = "#000000", size = 10, family = "serif"),
        axis.title = element_blank(),
        axis.text = element_blank(),
        #
        axis.line.x = element_line(color = "#000000", size = 1),
        axis.line.y = element_blank(),
        axis.ticks = element_blank())

ranked_data_4_final_bar_plot

# The bar chart is animated across the seasons.

animation_4 <- ranked_data_4_final_bar_plot +
  transition_states(Season, transition_length = 2, state_length = 1) +
  enter_fly(x_loc = -20, y_loc = 60000000) +
  exit_fly(x_loc = -20, y_loc = 60000000)

# Displaying and saving the animation.

animate(animation_4, duration = 15, fps = 25)
anim_save("animation_4.gif")

# Query 5
# Is there a relationship between a player's fouls (including yellow/red cards) 
# and their position on the field? */

# Retrieving the appropriate data from the database.

query_5 <- "SELECT CONCAT(player_first_name, player_last_name) AS `Player`, player_id AS `Player ID`, squad AS `Squad`, season AS `Season`, position AS `Position`, yellow AS `Yellows`, red AS `Reds`, fouls AS `Fouls` FROM player_season JOIN player_info USING (player_id) JOIN season USING (season_id) JOIN team_info USING (player_season_id) JOIN foul_stats USING (player_season_id) ORDER BY fouls DESC;"
data_5 <- dbGetQuery(database, query_5)

# Viewing the data set.

glimpse(data_5)

# Creating a position id (used for colors).

data_5_modified <- data_5 %>%
  mutate(`Position ID` = as.integer(factor(Position)))

# Viewing the data set.

glimpse(data_5_modified)

# Sorting the data set, grouping by season and arranging by fouls to create a
# ranking system.

ranked_data_5 <- data_5_modified %>%
  group_by(Season) %>%
  arrange(Season, desc(`Fouls`)) %>%
  mutate(Rank = as.double(1:n()),
         Season = factor(Season)) %>%
  filter(Rank <= 10)

# Viewing the (ranked) data set.

glimpse(ranked_data_5)

# Basic plot, with a qualitative (discrete) color palette.

ranked_data_5_bar_plot <- ranked_data_5 %>%
  ggplot() +
  geom_col(aes(x = Rank, y = Fouls, fill = factor(`Position ID` %% 4), group = `Player ID`), 
           width = 0.8, alpha = 0.8) +
  geom_text(aes(x = Rank, y = -4, label = Player, group = `Player ID`),
            hjust = 1, size = 4, color = "#000000", family = "serif") +
  geom_text(aes(x = Rank, y = Fouls - 4, label = paste0("Position: ", Position), group = `Player ID`),
            hjust = 1, size = 4, color = "#000000", family = "serif") +
  geom_text(aes(x = Rank, y = Fouls + 4, label = paste0("Fouls: ", Fouls), group = `Player ID`),
            hjust = 0, size = 4, color = "#000000", family = "serif") +
  scale_fill_brewer(palette = "Set1") +
  scale_x_reverse() +
  scale_y_continuous(limits = c(-40, 100)) +
  coord_flip(clip = "off") +
  labs(title = "Premier League - Top 10 Players (By Fouls)", 
       subtitle = "{closest_state}") +
  theme_minimal() +
  theme(legend.position = "none")

ranked_data_5_bar_plot

# Customizing the theme, including the titles, labels, and legend.

ranked_data_5_final_bar_plot <- ranked_data_5_bar_plot +
  theme(panel.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        plot.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
        panel.grid = element_blank(),
        #
        title = element_text(color = "#000000", size = 10, family = "serif"),
        axis.title = element_blank(),
        axis.text = element_blank(),
        #
        axis.line.x = element_line(color = "#000000", size = 1),
        axis.line.y = element_blank(),
        axis.ticks = element_blank())

ranked_data_5_final_bar_plot

# The bar chart is animated across the seasons.

animation_5 <- ranked_data_5_final_bar_plot +
  transition_states(Season, transition_length = 2, state_length = 1) +
  enter_fly(x_loc = -20, y_loc = 40) +
  exit_fly(x_loc = -20, y_loc = 40)

# Displaying and saving the animation.

animate(animation_5, duration = 15, fps = 25)
anim_save("animation_5.gif")
