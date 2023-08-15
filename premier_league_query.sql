/* CS 61 - Final Project */
/* Database Systems */
/* Carter Kruse */

/* Query 1) Is there a relationship between a player's market value
	and their success, as determined by the number of goals and
    assists in a given season? */

SELECT CONCAT(player_first_name, player_last_name) AS `Player`,
	squad AS `Squad`, season AS `Season`, market_value AS `Market Value`,
    goals AS `Goals`, assists AS `Assists`, (goals + assists) AS `Combined`
FROM player_season
	JOIN player_info
		USING (player_id)
	JOIN season
		USING (season_id)
	JOIN team_info
		USING (player_season_id)
	JOIN offensive_stats
		USING (player_season_id)
WHERE position != "DF"
ORDER BY market_value DESC
LIMIT 20;

/* Query 2) Which players had the highest "on target" percentage,
	and which had the highest "scoring" percentage? */
    
SELECT CONCAT(player_first_name, player_last_name) AS `Player`,
	squad AS `Squad`, season AS `Season`, (sot / shots) AS `On Target %`,
    (goals / shots) AS `Scoring %`
FROM player_season
	JOIN player_info
		USING (player_id)
	JOIN season
		USING (season_id)
	JOIN team_info
		USING (player_season_id)
	JOIN offensive_stats
		USING (player_season_id)
ORDER BY (goals / shots) DESC
LIMIT 50;
    
/* Query 2) Which teams had the highest "on target" percentage,
	and which had the highest "scoring" percentage? */

SELECT squad AS `Squad`, season AS `Season`,
	AVG(sot / shots) AS `On Target %`, AVG(goals / shots) AS `Scoring %`
FROM player_season
	JOIN player_info
		USING (player_id)
	JOIN season
		USING (season_id)
	JOIN team_info
		USING (player_season_id)
	JOIN offensive_stats
		USING (player_season_id)
GROUP BY squad, season
ORDER BY AVG(goals / shots) DESC
LIMIT 20;

/* Query 3) Which teams were most successful on set pieces (free kicks,
	corners, penalty kicks, etc)? Does this reflect the impact of
	specific players? */

SELECT squad AS `Squad`, season AS `Season`,
	SUM(fk_goal) AS `Free Kick Goals`, SUM(pk_scored) AS `PK Goals`,
	SUM(corners) AS `Corner Goals`, SUM(fk_goal + pk_scored + corners) AS `Combined`
FROM player_season
	JOIN player_info
		USING (player_id)
	JOIN season
		USING (season_id)
	JOIN team_info
		USING (player_season_id)
	JOIN offensive_stats
		USING (player_season_id)
GROUP BY squad, season
ORDER BY AVG(fk_goal + pk_scored + corners) DESC
LIMIT 20;

/* Query 4) Is there a relationship between a player's age and
	their market value? Are there outliers with respect to "success"? */

SELECT CONCAT(player_first_name, player_last_name) AS `Player`,
	LEFT(season, 4) - born AS `Age`, squad AS `Squad`, season AS `Season`,
    market_value AS `Market Value`
FROM player_season
	JOIN player_info
		USING (player_id)
	JOIN season
		USING (season_id)
	JOIN team_info
		USING (player_season_id)
ORDER BY market_value DESC
LIMIT 20;

/* Query 5) Is there a relationship between a player's fouls
	(including yellow/red cards) and their position on the field? */

SELECT CONCAT(player_first_name, player_last_name) AS `Player`,
	squad AS `Squad`, season AS `Season`, position AS `Position`,
    yellow AS `Yellows`, red AS `Reds`, fouls AS `Fouls`
FROM player_season
	JOIN player_info
		USING (player_id)
	JOIN season
		USING (season_id)
	JOIN team_info
		USING (player_season_id)
	JOIN foul_stats
		USING (player_season_id)
ORDER BY fouls DESC
LIMIT 50;
