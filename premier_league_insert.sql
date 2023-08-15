/* CS 61 - Final Project */
/* Database Systems */
/* Carter Kruse */

/* By turning off SQL safe updates, rows may be deleted from
	tables as appropriate, to clear the database. */
SET SQL_SAFE_UPDATES = 0;

/* Allows for deletion of rows from a given table. */
-- DELETE FROM [TABLE_NAME];

/* Used to reset the auto increment for a given table. */
-- ALTER TABLE [TABLE NAME] AUTO_INCREMENT = 1;

/* All of the INSERT INTO statements include a
	FROM premier_league_data statement, where the original data
	is kept. */

/* The 'player_info' table contains the distinct player 
	first/last name, year of birth, and nationality. */
INSERT INTO player_info (player_first_name, player_last_name, born, nation)
/* The 'SUBSTRING' and 'LOCATE' methods are used to break
	up a name into the first and last name. */
SELECT DISTINCT SUBSTRING(`Player`, 1, LOCATE(' ', `Player`)),
	SUBSTRING(`Player`, LOCATE(' ', `Player`) + 1, LENGTH(`Player`)), 
    `Born`, `Nation`
FROM premier_league_data;

/* The 'season' table contains the distinct season information. */
INSERT INTO season (season)
SELECT DISTINCT `Season`
FROM premier_league_data;

/* The 'player_season' table contains the distinct player ID
	and season ID, packaging these into a simple primary key. */
INSERT INTO player_season (player_id, season_id)
SELECT DISTINCT player_id, season_id
FROM premier_league_data
	/* There is a join on 'player_info', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN player_info
		ON (SUBSTRING(premier_league_data.`Player`, 1, LOCATE(' ', premier_league_data.`Player`)) = player_info.player_first_name
			AND
            SUBSTRING(premier_league_data.`Player`, LOCATE(' ', premier_league_data.`Player`) + 1, LENGTH(premier_league_data.`Player`)) = player_info.player_last_name
            AND
            premier_league_data.`Born` = player_info.born
            AND
            premier_league_data.`Nation` = player_info.nation)
	/* There is a join on 'season', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN season
		ON premier_league_data.`Season` = season.season;

/* The 'team_info' table contains the player's squad, position,
	and market value. */
INSERT INTO team_info (player_season_id, squad, position, market_value)
SELECT DISTINCT player_season_id, `Squad`, `Position`, `Market Value`
FROM premier_league_data
	/* There is a join on 'player_info', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN player_info
		ON (SUBSTRING(premier_league_data.`Player`, 1, LOCATE(' ', premier_league_data.`Player`)) = player_info.player_first_name
			AND
            SUBSTRING(premier_league_data.`Player`, LOCATE(' ', premier_league_data.`Player`) + 1, LENGTH(premier_league_data.`Player`)) = player_info.player_last_name
            AND
            premier_league_data.`Born` = player_info.born
            AND
            premier_league_data.`Nation` = player_info.nation)
	/* There is a join on 'season', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN season
		ON premier_league_data.`Season` = season.season
	/* There is a join on 'player_season', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN player_season
		USING (player_id, season_id);

/* The 'general_stats' table contains the player's appearances, 
	minutes played, and times subbed on/off. */
INSERT INTO general_stats (player_season_id, app, minutes, sub_on, sub_off)
SELECT DISTINCT player_season_id, `App`, `Minutes`, `SubOn`, `SubOff`
FROM premier_league_data
	/* There is a join on 'player_info', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN player_info
		ON (SUBSTRING(premier_league_data.`Player`, 1, LOCATE(' ', premier_league_data.`Player`)) = player_info.player_first_name
			AND
            SUBSTRING(premier_league_data.`Player`, LOCATE(' ', premier_league_data.`Player`) + 1, LENGTH(premier_league_data.`Player`)) = player_info.player_last_name
            AND
            premier_league_data.`Born` = player_info.born
            AND
            premier_league_data.`Nation` = player_info.nation)
	/* There is a join on 'season', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN season
		ON premier_league_data.`Season` = season.season
	/* There is a join on 'player_season', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN player_season
		USING (player_id, season_id);

/* The 'offensive_stats' table contains the player's
	goals, passes, assists, shots, shots on target, number of times
    they hit the post, header goals scored, PKs scored, free kicks 
    scored, through balls, misses, corners, and crosses. */
INSERT INTO offensive_stats (player_season_id, goals, passes, assists, shots, sot, hit_post, head_goal, pk_scored, fk_goal, thr_ball, misses, corners, crosses)
SELECT DISTINCT player_season_id, `Goals`, `Passes`, `Assists`, `Shots`, `SOT`, `HitPost`, `HeadGoal`, `PKScored`, `FKGoal`, `ThrBall`, `Misses`, `Corners`, `Crosses`
FROM premier_league_data
	/* There is a join on 'player_info', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN player_info
		ON (SUBSTRING(premier_league_data.`Player`, 1, LOCATE(' ', premier_league_data.`Player`)) = player_info.player_first_name
			AND
            SUBSTRING(premier_league_data.`Player`, LOCATE(' ', premier_league_data.`Player`) + 1, LENGTH(premier_league_data.`Player`)) = player_info.player_last_name
            AND
            premier_league_data.`Born` = player_info.born
            AND
            premier_league_data.`Nation` = player_info.nation)
	/* There is a join on 'season', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN season
		ON premier_league_data.`Season` = season.season
	/* There is a join on 'player_season', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN player_season
		USING (player_id, season_id);

/* The 'defensive_stats' table contains the player's
	number of header clearances, blocks, interceptions, last man
    saves, tackles, errors leading to goals, own goals, and clearances. */
INSERT INTO defensive_stats (player_season_id, head_clear, blocks, interceptions, last_man, tackles, elg, own_goal, clears)
SELECT DISTINCT player_season_id, `HeadClear`, `Blocks`, `Interceptions`, `Last man`, `Tackles`, `ELG`, `OwnGoal`, `Clears`
FROM premier_league_data
	/* There is a join on 'player_info', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN player_info
		ON (SUBSTRING(premier_league_data.`Player`, 1, LOCATE(' ', premier_league_data.`Player`)) = player_info.player_first_name
			AND
            SUBSTRING(premier_league_data.`Player`, LOCATE(' ', premier_league_data.`Player`) + 1, LENGTH(premier_league_data.`Player`)) = player_info.player_last_name
            AND
            premier_league_data.`Born` = player_info.born
            AND
            premier_league_data.`Nation` = player_info.nation)
	/* There is a join on 'season', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN season
		ON premier_league_data.`Season` = season.season
	/* There is a join on 'player_season', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN player_season
		USING (player_id, season_id);

/* The 'foul_stats' table contains the player's
	yellow cards, red cards, offsides, and fouls. */
INSERT INTO foul_stats (player_season_id, yellow, red, offsides, fouls)
SELECT DISTINCT player_season_id, `Yellow`, `Red`, `Offsides`, `Fouls`
FROM premier_league_data
	/* There is a join on 'player_info', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN player_info
		ON (SUBSTRING(premier_league_data.`Player`, 1, LOCATE(' ', premier_league_data.`Player`)) = player_info.player_first_name
			AND
            SUBSTRING(premier_league_data.`Player`, LOCATE(' ', premier_league_data.`Player`) + 1, LENGTH(premier_league_data.`Player`)) = player_info.player_last_name
            AND
            premier_league_data.`Born` = player_info.born
            AND
            premier_league_data.`Nation` = player_info.nation)
	/* There is a join on 'season', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN season
		ON premier_league_data.`Season` = season.season
	/* There is a join on 'player_season', using a superkey to
		ensure that the tables are correctly joined. */
	JOIN player_season
		USING (player_id, season_id);
