library(readr)
library(tidyverse)

appearances <- read_csv("appearances.csv")
club_games <- read_csv("club_games.csv")
clubs <- read_csv("clubs.csv")
competions <- read_csv("competitions.csv")
game_events <- read_csv("game_events.csv")
game_lineups <- read_csv("game_lineups.csv")
games <- read_csv("games.csv")
player_valuations <- read_csv("player_valuations.csv")
players <- read_csv("players.csv")


tranfer <- player_valuations %>%
  separate(date, into = c("Year", "Month", "Day"), sep = "\\-") 

#Setting a 10 year window
tranfer <- tranfer %>% 
  filter(Year >= 2014)

#understanding player valuation and clubs changes manually. 
ronaldo <- appearances %>% 
  filter(player_id == 8198)
###################################################################
club_appreances <- merge(appearances, club_games, by = c('game_id'))
club_appreances <- merge(club_appreances, clubs, by = c('club_id'))
clubs_df <- merge(club_appreances, competions, by = c('competition_id','name','url'))


###################################################################
#Creating the transfer data 
appearances <- appearances %>%
  arrange(player_id, date) %>%
  group_by(player_id) %>%
  mutate(
    previous_club = lag(player_club_id),
    transfer = ifelse(player_club_id != previous_club, TRUE, FALSE)
  ) 


#Lets run this through the gamelineups df as well to see if we missed something 

# Load necessary libraries
library(data.table)
library(lubridate)

# Convert the data.frame to data.table
setDT(game_lineups)

# Ensure 'date' is in the proper date format
game_lineups[, date := as.Date(date)]

# Calculate 'previous_club' and 'transfer' efficiently
game_lineups[, `:=`(
  previous_club = shift(club_id),
  transfer = as.logical(club_id != previous_club)
), by = player_id]

# Sort by player_id and date once to optimize subsequent operations
setorder(game_lineups, player_id, date)

# Identify and extract the games around the transfers
transfer_rows <- game_lineups[transfer == TRUE]






# Assuming 'game_lineups' is already a data.table and has the necessary columns

# Refactored function to handle data.table output properly
get_games_around_transfer <- function(data, player_id, transfer_date) {
  # Filter and order within the player's games
  player_games <- data[player_id == player_id, .SD, .SDcols = names(data)]
  setorder(player_games, date)
  
  # Create the subsets for games before and after
  games_before <- tail(player_games[date < transfer_date], 5)
  games_after  <- head(player_games[date >= transfer_date], 5)
  
  # Combine before and after games into one data.table
  rbind(games_before[, Type_transfer := 'Old Club (last 5 games)'],
        games_after[, Type_transfer := 'New Club (first 5 games)'])
}

# Application of the function to each transfer row efficiently
results <- transfer_rows[, get_games_around_transfer(game_lineups, player_id, date), by = .(player_id, date)]

# The result is a data.table containing all games around transfers
# Since the function returns a data.table, you can directly bind these as rows

# Optionally, if you need a more simplified structure
results <- rbindlist(results, use.names = TRUE, fill = TRUE)





# Remove duplicate entries (if any)
transfer <- unique(transfer)

# Display or further process 'results' as needed


library(tidyverse)
df_text <- speech_cw_preprocessed %>% 
  select(content.stemmed) %>% 
  na.omit()






print(head(df_text, 1234))


write.csv(df_text,'C:/Users/User/Downloads/df_text.csv')
write.table(df_text, file = "C:/Users/User/Downloads/df_text.txt", sep = "\t",
            row.names = FALSE)


metadata <- speech_cw_preprocessed %>% 
  select(c(Name:keyword))


###################################################################

colnames(player_valuations)[3] <- 'market_value'

final <- merge(player_valuations, players, by = c("player_id","current_club_id"), all.x = TRUE)

image_url <- players %>% 
  select(image_url, sub_position, position, foot)

image_url2 <- image_url %>%
  group_by(position) %>%
  na.omit() %>% 
  slice_sample(n = 30, replace = FALSE) 

print(sampled_data)



#########################################################################
market_data <- appearances %>%
  separate(date, into = c("Year", "Month", "Day"), sep = "\\-")

table(market_data$Year)

###########################################################

# Load the required tidyverse libraries
library(tidyverse)
# Filter the data to only include the years 2015 to 2023 and count the years for each player
players_every_year <- market_data %>%
  filter(Year %in% 2016:2023) %>%
  group_by(player_id) %>%
  summarise(YearCount = n()) %>% 
  filter(YearCount == 8 )

# Print the Player IDs
print(players_every_year$player_id)



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

players_every_year <- players_every_year %>% 
  select(player_id)




repeated_years <- rep(seq(2016, 2023), times = 1463)
repeated_years <- as.data.frame(repeated_years)


repeated_players <- rep(players_every_year$player_id, each = 8)
repeated_players <- as.data.frame(repeated_players)


df <- cbind(repeated_players, repeated_years)

playerstats <- appearances %>%
  filter(Year %in% 2016:2023) %>%
  group_by(player_id,Year) %>%
  summarise(total_yellow = sum(yellow_cards),
            total_red = sum(red_cards),
            total_goals = sum(goals),
            total_assists = sum(assists),
            min_per_match = sum(minutes_played)
  )




colnames(df) <- c('player_id', 'Year')












playerstats <- appearances %>%
  filter(Year %in% 2016:2023)

playerstats <- semi_join(playerstats, df, by = "player_id")

playerstats2 <- playerstats %>%
  group_by(player_id,Year) %>%
  summarise(matches_appearances = n(),
            yellow_permatch = sum(yellow_cards)/matches_appearances,
            red_permatch = sum(red_cards)/matches_appearances,
            goals_permatch = sum(goals)/matches_appearances,
            assists_permatch = sum(assists)/matches_appearances,
            min_permatch = sum(minutes_played)/matches_appearances
  )


df <- merge(df, playerstats2,by = c('player_id', 'Year'))



playerstats <- appearances %>%
  filter(Year %in% 2016:2023)

playerstats <- semi_join(playerstats, df, by = "player_id")

playerstats2 <- playerstats %>%
  group_by(player_id,Year) %>%
  summarise(matches_appearances = n(),
            yellow_permatch = sum(yellow_cards)/matches_appearances,
            red_permatch = sum(red_cards)/matches_appearances,
            goals_permatch = sum(goals)/matches_appearances,
            assists_permatch = sum(assists)/matches_appearances,
            min_permatch = sum(minutes_played)/matches_appearances
  )



colnames(players)

players_metadata <- players %>% 
  select(player_id, name, country_of_birth, country_of_citizenship, city_of_birth, date_of_birth, position, foot, height_in_cm)


df <- merge(df, players_metadata, by = 'player_id')

playerstats4 <- playerstats %>% 
  select(game_id, player_id, competition_id, Year)

club_games <- club_games %>% 
  select(game_id,is_win)

competions <- competions %>%
  select(competition_id, is_major_national_league)
  
  

is_win <- merge(playerstats4, club_games, by = 'game_id')
is_win <- merge(is_win, competions, by= 'competition_id')


is_win$major_league <- ifelse(is_win$is_major_national_league == TRUE, 1, 0)
is_win <- is_win %>% 
  select(-is_major_national_league, -competition_id, -game_id)





is_win <- is_win %>%
  filter(Year %in% 2016:2023)

is_win <- semi_join(is_win, df, by = "player_id")

is_win <- is_win %>%
  group_by(player_id,Year) %>%
  summarise(mat = n(),
            win_percentage = sum(is_win)/mat,
            major_league = max(major_league)
  )

final_df <- merge(df, is_win, by = c('player_id','Year'))


library(lubridate)

final_df3 <- final_df %>%
  separate(date_of_birth, into = c("Year_birth", "Month", "Day"), sep = "\\-")

final_df3 <- final_df3 %>% 
  select(-Month, -Day)

final_df3$Age <- as.numeric(final_df3$Year) - as.numeric(final_df3$Year_birth) 


df_1623 <- df_1623[,-1]
pre_model_data <- merge(final_df, df_1623, by= c('player_id', 'Year'))

mini_train <- head(pre_model_data, 2000)

#Year
pre_model_data$y2016 <- ifelse(pre_model_data$Year == '2016', 1,0)
pre_model_data$y2017 <- ifelse(pre_model_data$Year == '2017', 1,0)
pre_model_data$y2018 <- ifelse(pre_model_data$Year == '2018', 1,0)
pre_model_data$y2019 <- ifelse(pre_model_data$Year == '2019', 1,0)
pre_model_data$y2020 <- ifelse(pre_model_data$Year == '2020', 1,0)
pre_model_data$y2021 <- ifelse(pre_model_data$Year == '2021', 1,0)
pre_model_data$y2022 <- ifelse(pre_model_data$Year == '2022', 1,0)
pre_model_data$y2023 <- ifelse(pre_model_data$Year == '2023', 1,0)


#other
pre_model_data$mapprear <- ifelse(pre_model_data$matches_appearances >=  quantile(pre_model_data$matches_appearances, 0.75) , 1,0)
pre_model_data$yellow <- ifelse(pre_model_data$yellow_permatch >=  quantile(pre_model_data$yellow_permatch, 0.75), 1,0)
pre_model_data$red <- ifelse(pre_model_data$red_permatch >=  quantile(pre_model_data$red_permatch, 0.75), 1,0)
pre_model_data$goal <- ifelse(pre_model_data$goals_permatch >=  quantile(pre_model_data$goals_permatch, 0.75), 1,0)
pre_model_data$assist <- ifelse(pre_model_data$assists_permatch >=  quantile(pre_model_data$assists_permatch, 0.75), 1,0)
pre_model_data$min <- ifelse(pre_model_data$min_permatch >=  quantile(pre_model_data$min_permatch, 0.75), 1,0)

#postion
pre_model_data$attack <- ifelse(pre_model_data$position == 'Attack', 1,0)
pre_model_data$def <- ifelse(pre_model_data$position  == 'Defender', 1,0)
pre_model_data$goalkep <- ifelse(pre_model_data$position  == 'Goalkeeper', 1,0)
pre_model_data$midfield <- ifelse(pre_model_data$position  == 'Midfield', 1,0)


#foot 
pre_model_data$rfoot <- ifelse(pre_model_data$foot  == 'Right', 1,0)

pre_model_data$heightbinary <- ifelse(pre_model_data$height_in_cm >=  quantile(pre_model_data$height_in_cm, 0.75, na.rm = T), 1,0)
pre_model_data$highwin <- ifelse(pre_model_data$win_percentage >=  quantile(pre_model_data$win_percentage, 0.75, na.rm = T), 1,0)

pre_model_data$old <- ifelse(pre_model_data$Age >=  quantile(pre_model_data$Age, 0.75, na.rm = T), 1,0)
pre_model_data$expensiveguy <- ifelse(pre_model_data$market_value_in_eur >=  quantile(pre_model_data$market_value_in_eur, 0.75, na.rm = T), 1,0)
pre_model_data$lineuptime <- ifelse(pre_model_data$type_ratio >=  quantile(pre_model_data$type_ratio, 0.75, na.rm = T), 1,0)


binary_convert <- pre_model_data %>% 
  select(ever_captain:lineuptime, major_league, value_increase,club_changed)

write.csv(binary_convert,'C:/Users/User/Downloads/binary_convert.csv', row.names = F)

mini_train <- head(binary_convert, 2000)

binary_convert <- binary_convert %>% 
  na.omit()
