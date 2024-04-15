-- Table: players
CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    player_name TEXT,
    dob DATE,
    batting_hand TEXT,
    bowling_skill TEXT,
    country_name TEXT
);

-- Table: teams
CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY,
    name TEXT
);

-- Table: matches
CREATE TABLE matches (
    match_id SERIAL PRIMARY KEY,
    team_1 INTEGER REFERENCES teams(team_id),
    team_2 INTEGER REFERENCES teams(team_id),
    match_date DATE,
    season_id INTEGER,
    venue TEXT,
    toss_winner INTEGER REFERENCES teams(team_id),
    toss_decision TEXT,
    win_type TEXT,
    win_margin INTEGER,
    outcome_type TEXT,
    match_winner INTEGER REFERENCES teams(team_id),
    man_of_the_match INTEGER REFERENCES players(player_id)
);

-- Table: player_roles
CREATE TABLE player_roles (
    match_id INTEGER,
    player_id INTEGER REFERENCES players(player_id),
    role TEXT,
    team_id INTEGER REFERENCES teams(team_id),
    FOREIGN KEY (match_id) REFERENCES matches(match_id) -- Corrected foreign key constraint
);

-- Table: balls
CREATE TABLE balls (
    match_id INTEGER,
    over_id INTEGER,
    ball_id INTEGER,
    innings_no INTEGER,
    team_batting INTEGER,
    team_bowling INTEGER,
    striker_batting_position INTEGER,
    striker INTEGER,
    non_striker INTEGER,
    bowler INTEGER,
    FOREIGN KEY (match_id) REFERENCES matches (match_id),
    FOREIGN KEY (team_batting) REFERENCES teams (team_id),
    FOREIGN KEY (team_bowling) REFERENCES teams (team_id),
    FOREIGN KEY (striker) REFERENCES players (player_id),
    FOREIGN KEY (non_striker) REFERENCES players (player_id),
    FOREIGN KEY (bowler) REFERENCES players (player_id)
);

-- Table: runs_scored
CREATE TABLE runs_scored (
    match_id INTEGER,
    over_id INTEGER,
    ball_id INTEGER,
    runs_scored INTEGER,
    innings_no INTEGER,
    FOREIGN KEY (match_id) REFERENCES matches (match_id)
);

-- Table: balls_out
CREATE TABLE balls_out (
    match_id INTEGER,
    over_id INTEGER,
    ball_id INTEGER,
    player_out INTEGER,
    kind_out TEXT,
    innings_no INTEGER,
    FOREIGN KEY (match_id) REFERENCES matches (match_id),
    FOREIGN KEY (player_out) REFERENCES players (player_id)
);

-- Table: extras
CREATE TABLE extras (
    match_id INTEGER,
    over_id INTEGER,
    ball_id INTEGER,
    extra_type TEXT,
    extra_runs INTEGER,
    innings_no INTEGER,
    FOREIGN KEY (match_id) REFERENCES matches (match_id)
);

-- For players table
COPY players (player_name, dob, batting_hand, bowling_skill, country_name) FROM 'https://raw.githubusercontent.com/PDSThakur/2201CS53_CS260/main/tut09/player.csv?token=GHSAT0AAAAAACQH45QSP2MPTZMEJ7XWQJRWZQ5LAQA' DELIMITER ',' CSV HEADER;

-- For teams table
COPY teams (name) FROM 'https://raw.githubusercontent.com/PDSThakur/2201CS53_CS260/main/tut09/team.csv?token=GHSAT0AAAAAACQH45QSFR7UR5PJASEAPLQSZQ5LA7A' DELIMITER ',' CSV HEADER;

-- For matches table
COPY matches (team_1, team_2, match_date, season_id, venue, toss_winner, toss_decision, win_type, win_margin, outcome_type, match_winner, man_of_the_match) FROM 'https://raw.githubusercontent.com/PDSThakur/2201CS53_CS260/main/tut09/match.csv?token=GHSAT0AAAAAACQH45QS2WX2DC2RLDEFC6M2ZQ5LBOQ' DELIMITER ',' CSV HEADER;

-- For player_roles table
COPY player_roles (match_id, player_id, role, team_id) FROM 'https://raw.githubusercontent.com/PDSThakur/2201CS53_CS260/main/tut09/player_match.csv?token=GHSAT0AAAAAACQH45QSJNO5ILYCKE7SB2QYZQ5LCMQ' DELIMITER ',' CSV HEADER;

-- For balls table
COPY balls (match_id, over_id, ball_id, innings_no, team_batting, team_bowling, striker_batting_position, striker, non_striker, bowler) FROM 'https://raw.githubusercontent.com/PDSThakur/2201CS53_CS260/main/tut09/ball_by_ball.csv?token=GHSAT0AAAAAACQH45QTW4QHFH7KWSMZEHSQZQ5LDCA' DELIMITER ',' CSV HEADER;

-- For runs_scored table
COPY runs_scored (match_id, over_id, ball_id, runs_scored, innings_no) FROM 'https://raw.githubusercontent.com/PDSThakur/2201CS53_CS260/main/tut09/batsman_scored.csv?token=GHSAT0AAAAAACQH45QTICKSOEF6AVBD4E6CZQ5LFHQ' DELIMITER ',' CSV HEADER;

-- For balls_out table
COPY balls_out (match_id, over_id, ball_id, player_out, kind_out, innings_no) FROM 'https://raw.githubusercontent.com/PDSThakur/2201CS53_CS260/main/tut09/wicket_taken.csv?token=GHSAT0AAAAAACQH45QTUT2ZVW3XUXWVNEMOZQ5LERQ' DELIMITER ',' CSV HEADER;

-- For extras table
COPY extras (match_id, over_id, ball_id, extra_type, extra_runs, innings_no) FROM 'https://raw.githubusercontent.com/PDSThakur/2201CS53_CS260/main/tut09/extra_runs.csv?token=GHSAT0AAAAAACQH45QTX7YXVYWAFBRN7EF2ZQ5LD4Q' DELIMITER ',' CSV HEADER;

1. SELECT player_name FROM players WHERE batting_hand = 'left' AND country_name = 'England' ORDER BY player_name;

2. SELECT player_name, DATE_PART('year', '2018-12-02'::date) - DATE_PART('year', dob) AS player_age
   FROM players
   WHERE bowling_skill = 'Legbreak googly' AND DATE_PART('year', '2018-12-02'::date) - DATE_PART('year', dob) >= 28
   ORDER BY player_age DESC, player_name;

3. SELECT match_id, toss_winner 
   FROM matches 
   WHERE toss_decision = 'bat' 
   ORDER BY match_id;

4. SELECT over_id, SUM(runs_scored) AS runs_scored 
   FROM ball_by_ball 
   WHERE match_id = 335987 AND runs_scored <= 7 
   GROUP BY over_id 
   ORDER BY runs_scored DESC, over_id;

5. SELECT DISTINCT players.player_name 
   FROM players 
   INNER JOIN balls_out ON players.player_id = balls_out.player_out 
   WHERE balls_out.kind_out = 'bowled' 
   ORDER BY players.player_name;

6. SELECT matches.match_id, teams1.name AS team_1, teams2.name AS team_2, winning_team.name AS winning_team_name, win_margin 
   FROM matches 
   INNER JOIN teams AS teams1 ON matches.team_1 = teams1.team_id 
   INNER JOIN teams AS teams2 ON matches.team_2 = teams2.team_id 
   INNER JOIN teams AS winning_team ON matches.match_winner = winning_team.team_id 
   WHERE win_margin >= 60 
   ORDER BY win_margin, matches.match_id;

7. SELECT player_name 
   FROM players 
   WHERE batting_hand = 'left' AND DATE_PART('year', '2018-12-02'::date) - DATE_PART('year', dob) < 30 
   ORDER BY player_name;

8. SELECT match_id, SUM(runs_scored) AS total_runs 
   FROM runs_scored 
   GROUP BY match_id 
   ORDER BY match_id;

9. SELECT match_id, MAX(runs_scored) AS maximum_runs, players.player_name 
   FROM runs_scored 
   INNER JOIN balls ON runs_scored.match_id = balls.match_id AND runs_scored.over_id = balls.over_id 
   INNER JOIN players ON balls.bowler = players.player_id 
   GROUP BY match_id, players.player_name 
   ORDER BY match_id, maximum_runs, players.player_name;

10. SELECT players.player_name, COUNT(*) AS number 
    FROM balls_out 
    INNER JOIN players ON balls_out.player_out = players.player_id 
    WHERE kind_out = 'run out' 
    GROUP BY players.player_name 
    ORDER BY number DESC, players.player_name;

11. SELECT kind_out, COUNT(*) AS number 
    FROM balls_out 
    GROUP BY kind_out 
    ORDER BY number DESC, kind_out;

12. SELECT teams.name, COUNT(*) AS number 
    FROM players 
    INNER JOIN matches ON players.player_id = matches.man_of_the_match 
    INNER JOIN teams ON players.team_id = teams.team_id 
    GROUP BY teams.name 
    ORDER BY teams.name;

13. SELECT venue 
    FROM (SELECT venue, COUNT(*) AS wides_count 
          FROM ball_by_ball 
          WHERE extra_type = 'wide' 
          GROUP BY venue) AS venue_counts 
    ORDER BY wides_count DESC, venue 
    LIMIT 1;

14. SELECT venue 
    FROM (SELECT venue, COUNT(*) AS wins_count 
          FROM matches 
          WHERE team_batting = match_winner 
          GROUP BY venue) AS venue_wins 
    ORDER BY wins_count DESC, venue;

15. SELECT players.player_name 
    FROM balls 
    INNER JOIN players ON balls.bowler = players.player_id 
    GROUP BY players.player_name 
    ORDER BY SUM(runs_scored) / COUNT(CASE WHEN kind_out <> 'not out' THEN 1 END), players.player_name 
    LIMIT 1;

16. SELECT players.player_name, teams.name 
    FROM players 
    INNER JOIN matches ON players.player_id = matches.man_of_the_match AND players.team_id = matches.team_winner 
    INNER JOIN teams ON players.team_id = teams.team_id 
    WHERE role = 'CaptainKeeper' 
    ORDER BY players.player_name;

17. SELECT players.player_name, SUM(runs_scored) AS total_runs 
    FROM runs_scored 
    INNER JOIN players ON runs_scored.striker = players.player_id 
    GROUP BY players.player_name 
    HAVING SUM(runs_scored) >= 50 
    ORDER BY total_runs DESC, players.player_name;

18. SELECT players.player_name 
    FROM players 
    INNER JOIN balls_out ON players.player_id = balls_out.player_out 
    INNER JOIN matches ON balls_out.match_id = matches.match_id AND players.team_id <> matches.match_winner 
    GROUP BY players.player_name 
    HAVING SUM(runs_scored) >= 100 
    ORDER BY players.player_name;

19. SELECT match_id, venue 
    FROM matches 
    WHERE (team_1 = (SELECT team_id FROM teams WHERE name = 'KKR') OR team_2 = (SELECT team_id FROM teams WHERE name = 'KKR')) 
    AND match_winner <> (SELECT team_id FROM teams WHERE name = 'KKR') 
    ORDER BY match_id;

20. SELECT players.player_name 
    FROM players 
    INNER JOIN matches ON players.player_id = matches.man_of_the_match 
    INNER JOIN ball_by_ball ON matches.match_id = ball_by_ball.match_id AND players.player_id = ball_by_ball.striker 
    WHERE ball_by_ball.innings_no <= 2 AND ball_by_ball.match_id IN (SELECT match_id FROM matches WHERE season_id = 5) 
    GROUP BY players.player_name 
    ORDER BY SUM(runs_scored) / COUNT(DISTINCT matches.match_id), players.player_name 
    LIMIT 10;


