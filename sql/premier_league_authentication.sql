/* CS 61 - Final Project */
/* Database Systems */
/* Carter Kruse */

-- -----------------------------------------------------
-- Schema
-- -----------------------------------------------------

/* We use this command to specify the database we aim to use. */
USE premier_league;

-- -----------------------------------------------------
-- Tables
-- -----------------------------------------------------

/* Throughout this section, `DROP [TABLE]` commands are commented
	out, as they were used for troubleshooting throughout. */
    
-- DROP TABLE users;

CREATE TABLE IF NOT EXISTS users
(
	# User ID assigned to each user.
	id INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
    username VARCHAR(45) NOT NULL, # Username
    password VARCHAR(90) NOT NULL, # Password
    PRIMARY KEY (id)
);

/* By turning off SQL safe updates, rows may be deleted from
	tables as appropriate, to clear the database. */
SET SQL_SAFE_UPDATES = 0;

/* Inserting a row with the username and password for authentication. */
INSERT INTO users (username, password)
	VALUES ('username', 'password');
