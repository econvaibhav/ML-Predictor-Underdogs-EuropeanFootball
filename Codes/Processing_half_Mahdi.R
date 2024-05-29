library(tidyverse)
library(lubridate)


library(caret)
library(XML)
library(quanteda)
library(topicmodels)
library(randomForest)
library(kernlab)
library(ROSE)

################################################################################

appearances <- read.csv("appearances.csv")
club_games <- read.csv("club_games.csv")
clubs <- read.csv("clubs.csv")
competitions <- read.csv("competitions.csv")
game_events <- read.csv("game_events.csv")
game_lineups <- read.csv("game_lineups.csv")
games <- read.csv("games.csv")
player_valuations <- read.csv("player_valuations.csv")
players <- read.csv("players.csv")

################################################################################


appearances <- appearances %>%
  separate(date, into = c("Year", "Month", "Day"), sep = "\\-")

distinct_data <- appearances %>%
  group_by(player_id, Year) %>%
  slice_sample(n = 1) %>%
  ungroup()

players_every_year <- distinct_data %>%
  filter(Year %in% 2016:2023) %>%
  group_by(player_id) %>%
  summarise(YearCount = n()) %>% 
  filter(YearCount == 8 )

################################################################################

filtered_appearances <- appearances %>%
  filter(Year %in% 2016:2023)

appearance_1623 <- semi_join(filtered_appearances, players_every_year, by = "player_id")



################################################################################

player_valuations <- player_valuations %>%
  separate(date, into = c("Year", "Month", "Day"), sep = "\\-")

filtered_player_valuations <- player_valuations %>%
  filter(Year %in% 2016:2023)

player_valuations_1623 <- semi_join(filtered_player_valuations, players_every_year, by = "player_id")

player_valuations_1623 <- player_valuations_1623 %>%
  group_by(player_id, Year) %>%
  arrange(desc(Month), desc(Day)) %>%
  slice(1) %>%
  ungroup()

player_valuations_1623 <- player_valuations_1623 %>%
  select(-current_club_id, -player_club_domestic_competition_id, -Month, -Day)

player_valuations_1623 <- player_valuations_1623 %>%
  arrange(player_id, Year) %>%
  group_by(player_id) %>%
  mutate(
    value_increase = if_else(market_value_in_eur > lag(market_value_in_eur, default = first(market_value_in_eur)), 1, 0)
  ) %>%
  ungroup()

################################################################################

game_lineups <- game_lineups %>%
  separate(date, into = c("Year", "Month", "Day"), sep = "\\-")

filtered_game_lineups <- game_lineups %>%
  filter(Year %in% 2016:2023)

game_lineups_2 <- semi_join(filtered_game_lineups, players_every_year, by = "player_id")

game_lineups_1623 <- game_lineups_2 %>%
  group_by(player_id, Year) %>%
  summarise(
    matches = n(),
    club_changed = as.integer(n_distinct(club_id) > 1),
    type_ratio = sum(type == "starting_lineup") / sum(type == "substitutes"),
    ever_captain = as.integer(any(team_captain == 1)),
    .groups = 'drop'
  )


game_lineups_1623$type_ratio <- ifelse(is.infinite(game_lineups_1623$type_ratio), 
                                       game_lineups_1623$matches,
                                       game_lineups_1623$type_ratio)


################################################################################

df_1623 <- inner_join(player_valuations_1623, game_lineups_1623, by = c("player_id", "Year"))

################################################################################

uncommon_valuations <- anti_join(player_valuations_1623, game_lineups_1623, by = c("player_id", "Year"))
uncommon_lineups <- anti_join(game_lineups_1623, player_valuations_1623, by = c("player_id", "Year"))

################################################################################

write.csv(df_1623, "df_1623.csv")
