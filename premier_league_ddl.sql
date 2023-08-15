/* CS 61 - Final Project */
/* Database Systems */
/* Carter Kruse */

-- -----------------------------------------------------
-- Schema
-- -----------------------------------------------------

/* If the database already exists, we remove it, and create
	a new instance of it. */
DROP DATABASE IF EXISTS premier_league;
CREATE DATABASE premier_league;

/* The `SHOW DATABASES` command demonstrates that we have
	successfully created the database. */
SHOW DATABASES;

/* We use this command to specify the database we aim to use. */
USE premier_league;

-- -----------------------------------------------------
-- Tables
-- -----------------------------------------------------

/* Throughout this section, `DROP [TABLE]` commands are commented
	out, as they were used for troubleshooting throughout. */

-- DROP TABLE player_info;

/* Typical information about a player, including their ID, name,
	birth year, and nationality. */
CREATE TABLE IF NOT EXISTS player_info
(
	# Player ID assigned to each player.
	player_id INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
    player_first_name VARCHAR(45) NULL, # Player's first name.
    player_last_name VARCHAR(45) NULL, # Player's last name.
    born VARCHAR(45) NULL, # Player's birth year.
    nation VARCHAR(45) NULL, # Player's nationality
    PRIMARY KEY (player_id)
);

-- DROP TABLE season;

/* Typical information about a season, encoded with an ID. */
CREATE TABLE IF NOT EXISTS season
(
	# Season ID assigned to each season.
	season_id INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
    season VARCHAR(45) NOT NULL, # Season (as XXXX-XXXX).
    PRIMARY KEY (season_id)
);

-- DROP TABLE player_season;

/* A table encoding the seasons each player participated in. */
CREATE TABLE IF NOT EXISTS player_season
(
	# Player/Season ID assigned to each player for each season.
	player_season_id INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
    player_id INT UNSIGNED NULL, # Player ID assigned to each player.
    season_id INT UNSIGNED NULL, # Season ID assigned to each season.
    PRIMARY KEY (player_season_id),
    FOREIGN KEY (player_id) REFERENCES player_info (player_id),
    FOREIGN KEY (season_id) REFERENCES season (season_id)
);

-- DROP TABLE team_info;

/* Typical information about a player and season, including their
	squad, position, and market value. */
CREATE TABLE IF NOT EXISTS team_info
(
	# Player/Season ID assigned to each player for each season.
	player_season_id INT UNSIGNED UNIQUE NOT NULL,
    squad VARCHAR(45) NULL, # Player's squad.
    position VARCHAR(45) NULL, # Player's position.
    market_value INT UNSIGNED NULL, # Player's market value.
    PRIMARY KEY (player_season_id),
    FOREIGN KEY (player_season_id) REFERENCES player_season (player_season_id)
);

-- DROP TABLE general_stats;

/* General statistics about a player and season, including their
	appearances, minutes played, and times subbed on/off. */
CREATE TABLE IF NOT EXISTS general_stats
(
	# Player/Season ID assigned to each player for each season.
	player_season_id INT UNSIGNED UNIQUE NOT NULL,
    app INT UNSIGNED NULL, # Player's appearances.
    minutes INT UNSIGNED NULL, # Player's minutes played.
    sub_on INT UNSIGNED NULL, # Player's number of times subbed on.
    sub_off INT UNSIGNED NULL, # Player's number of times subbed off.
    PRIMARY KEY (player_season_id),
    FOREIGN KEY (player_season_id) REFERENCES player_season (player_season_id)
);

-- DROP TABLE offensive_stats;

/* Offensive statistics about a player and season, including their
	goals, passes, assists, shots, shots on target, number of times
    they hit the post, header goals scored, PKs scored, free kicks 
    scored, through balls, misses, corners, and crosses. */
CREATE TABLE IF NOT EXISTS offensive_stats
(
	# Player/Season ID assigned to each player for each season.
	player_season_id INT UNSIGNED UNIQUE NOT NULL,
    goals INT UNSIGNED NULL, # Player's goals.
    passes INT UNSIGNED NULL, # Player's passes.
    assists INT UNSIGNED NULL, # Player's assists.
    shots INT UNSIGNED NULL, # Player's shots.
    sot INT UNSIGNED NULL, # Player's shots on target.
    hit_post INT UNSIGNED NULL, # Player's number of times they hit the post.
    head_goal INT UNSIGNED NULL, # Player's header goals scored.
    pk_scored INT UNSIGNED NULL, # Player's PKs scored.
    fk_goal INT UNSIGNED NULL, # Player's free kicks scored.
    thr_ball INT UNSIGNED NULL, # Player's through balls.
    misses INT UNSIGNED NULL, # Player's misses.
    corners INT UNSIGNED NULL, # Player's corners.
    crosses INT UNSIGNED NULL, # Player's crosses.
    PRIMARY KEY (player_season_id),
    FOREIGN KEY (player_season_id) REFERENCES player_season (player_season_id)
);

-- DROP TABLE defensive_stats;

/* Defensive statistics about a player and season, including their
	number of header clearances, blocks, interceptions, last man
    saves, tackles, errors leading to goals, own goals, and clearances. */
CREATE TABLE IF NOT EXISTS defensive_stats
(
	# Player/Season ID assigned to each player for each season.
	player_season_id INT UNSIGNED UNIQUE NOT NULL,
    head_clear INT UNSIGNED NULL, # Player's number of header clearances.
    blocks INT UNSIGNED NULL, # Player's blocks.
    interceptions INT UNSIGNED NULL, # Player's interceptions.
    last_man INT UNSIGNED NULL, # Player's last man saves.
    tackles INT UNSIGNED NULL, # Player's tackles.
    elg INT UNSIGNED NULL, # Player's errors leading to goals.
    own_goal INT UNSIGNED NULL, # Player's own goals.
    clears INT UNSIGNED NULL, # Player's clearances.
    PRIMARY KEY (player_season_id),
    FOREIGN KEY (player_season_id) REFERENCES player_season (player_season_id)
);

-- DROP TABLE foul_stats;

/* Foul statistics about a player and season, including their
	yellow cards, red cards, offsides, and fouls. */
CREATE TABLE IF NOT EXISTS foul_stats
(
	# Player/Season ID assigned to each player for each season.
	player_season_id INT UNSIGNED UNIQUE NOT NULL,
    yellow INT UNSIGNED NULL, # Player's yellows.
    red INT UNSIGNED NULL, # Player's reds.
    offsides INT UNSIGNED NULL, # Player's offsides.
    fouls INT UNSIGNED NULL, # Player's fouls.
    PRIMARY KEY (player_season_id),
    FOREIGN KEY (player_season_id) REFERENCES player_season (player_season_id)
);

-- -----------------------------------------------------
-- Results
-- -----------------------------------------------------

SHOW TABLES;

/* An advanced version of the `SHOW TABLES` command that allows
	for renaming of the column that is the result. */
SELECT table_name AS 'Premier League Tables'
FROM information_schema.tables
WHERE tables.table_schema = 'premier_league';

/* Removing the table containing the JSON imported data. */
DROP TABLE premier_league_data;
