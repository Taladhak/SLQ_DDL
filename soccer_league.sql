-- from the terminal run:
-- psql < soccer_league.sql

DROP DATABASE IF EXISTS soccer_league;

CREATE DATABASE soccer_league;

\c soccer_league

-- Teams table to store all teams in the league
CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    founded_date DATE,
    home_stadium VARCHAR(100)
);

-- Players table to store all players and their team affiliations
CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    team_id INTEGER REFERENCES teams(team_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    jersey_number INTEGER,
    position VARCHAR(30),
    date_of_birth DATE,
    CONSTRAINT fk_team FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

-- Referees table to store referee information
CREATE TABLE referees (
    referee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    certification_level VARCHAR(20)
);

-- Seasons table to store season information
CREATE TABLE seasons (
    season_id SERIAL PRIMARY KEY,
    season_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- Matches table to store game information
CREATE TABLE matches (
    match_id SERIAL PRIMARY KEY,
    season_id INTEGER REFERENCES seasons(season_id),
    home_team_id INTEGER REFERENCES teams(team_id),
    away_team_id INTEGER REFERENCES teams(team_id),
    match_date TIMESTAMP NOT NULL,
    home_team_score INTEGER DEFAULT 0,
    away_team_score INTEGER DEFAULT 0,
    main_referee_id INTEGER REFERENCES referees(referee_id),
    CONSTRAINT fk_season FOREIGN KEY (season_id) REFERENCES seasons(season_id),
    CONSTRAINT fk_home_team FOREIGN KEY (home_team_id) REFERENCES teams(team_id),
    CONSTRAINT fk_away_team FOREIGN KEY (away_team_id) REFERENCES teams(team_id),
    CONSTRAINT fk_referee FOREIGN KEY (main_referee_id) REFERENCES referees(referee_id)
);

-- Match referees table for additional referees (linesmen, fourth official, etc.)
CREATE TABLE match_referees (
    match_id INTEGER REFERENCES matches(match_id),
    referee_id INTEGER REFERENCES referees(referee_id),
    role VARCHAR(30),
    PRIMARY KEY (match_id, referee_id),
    CONSTRAINT fk_match FOREIGN KEY (match_id) REFERENCES matches(match_id),
    CONSTRAINT fk_referee FOREIGN KEY (referee_id) REFERENCES referees(referee_id)
);

-- Goals table to track all goals scored
CREATE TABLE goals (
    goal_id SERIAL PRIMARY KEY,
    match_id INTEGER REFERENCES matches(match_id),
    scoring_player_id INTEGER REFERENCES players(player_id),
    assisting_player_id INTEGER REFERENCES players(player_id),
    minute INTEGER,
    CONSTRAINT fk_match FOREIGN KEY (match_id) REFERENCES matches(match_id),
    CONSTRAINT fk_scorer FOREIGN KEY (scoring_player_id) REFERENCES players(player_id),
    CONSTRAINT fk_assist FOREIGN KEY (assisting_player_id) REFERENCES players(player_id)
);

-- View to calculate current standings
CREATE VIEW standings AS
SELECT 
    t.team_id,
    t.team_name,
    COUNT(m.match_id) as matches_played,
    SUM(CASE 
        WHEN (m.home_team_id = t.team_id AND m.home_team_score > m.away_team_score) OR 
             (m.away_team_id = t.team_id AND m.away_team_score > m.home_team_score) THEN 3
        WHEN m.home_team_score = m.away_team_score THEN 1
        ELSE 0
    END) as points,
    SUM(CASE WHEN m.home_team_id = t.team_id THEN m.home_team_score ELSE m.away_team_score END) as goals_for,
    SUM(CASE WHEN m.home_team_id = t.team_id THEN m.away_team_score ELSE m.home_team_score END) as goals_against
FROM teams t
LEFT JOIN matches m ON t.team_id = m.home_team_id OR t.team_id = m.away_team_id
GROUP BY t.team_id, t.team_name
ORDER BY points DESC, (goals_for - goals_against) DESC;
