<?php 
session_start();

if (isset($_SESSION['id']) && isset($_SESSION['username'])) { ?>

<!DOCTYPE html>
<html>

<head>
    <title>Dartmouth CS 61 - Database Systems</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>

<body class="home">
    <header>
        <h2>Dartmouth CS 61 - Database Systems</h2>
        <nav>
            <ul>
                <li><a href="#about">About</a></li>
                <li><a href="#visualizations">Visualizations</a></li>
                <li><a href="#contact">Contact</a></li>
                <li><a href="logout.php">Logout</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <div class="main_picture">
            <img src="images/premier_league.png" alt="premier_league" style="width:30%">
        </div>

        <section id="about">
            <h3>About</h3>
            <p>
                Dartmouth CS 61 - Database Systems
            <p>
            <p>
                Final Project - Premier League
            </p>
        </section>

        <section id="visualizations">
            <h3>Visualizations</h3>
            <h4>Query 1</h4>

            <div class="gallery">
                Is there a relationship between a player's market value and their success, as determined by the number of goals and assists in a given season?
                <br><br>
                The following demonstrates that players that are more successful, as determined by the number of goals and assists in a given season, tend to command higher market values. Further, many of the names of players are repeated, as they are high-performing players that continue to perform for their squads, across seasons. In this query, we exclude defenders, as they do not tend to score/assist many goals.

                <img src="visualization/bar_animation_1.gif" class="gallery_img" alt="bar_animation_1">
            </div>

            <h4>Query 2</h4>
            <div class="gallery">
                Which players had the highest "on target" percentage, and which had the highest "scoring" percentage?
                <br><br>
                The following demonstrates that the players with the highest "scoring" percentage tend to be those that have the highest "on target" percentage. This naturally makes sense, though we must consider the impact of players that did not see much playing time in the respective seasons, and thus have a "scoring" percentage of 100%. To do so, we implement the condition that the number of shots taken in a given season must be greater than 10.

                <img src="visualization/bar_animation_2_1.gif" class="gallery_img" alt="bar_animation_2">
            </div>

            <h4>Query 2</h4>
            <div class="gallery">
                Which teams had the highest "on target" percentage, and which had the highest "scoring" percentage?
                <br><br>
                The following demonstrates that the teams with the highest "scoring" percentage tend to be those that have the highest "on target" percentage. Given that we are using aggregate results (across a team for a given season), the impact of outliers is much less significant than in the previous query.
                
                <img src="visualization/bar_animation_2_2.gif" class="gallery_img" alt="bar_animation_2_2">
            </div>

            <h4>Query 3</h4>
            <div class="gallery">
                Which teams were most successful on set pieces (free kicks, corners, penalty kicks, etc)? Does this reflect the impact of specific players?
                <br><br>
                The following demonstrates that teams tend to score more often on corners than on free kicks or penalty kicks, at least according to the data. The results show the teams that tend to be consistently successful on set pieces across seasons. In this query, we use aggregate results (across a team for a given season) to provide a more general overview.
                
                <img src="visualization/bar_animation_3.gif" class="gallery_img" alt="bar_animation_3">
            </div>

            <h4>Query 4</h4>
            <div class="gallery">
                Is there a relationship between a player's age and their market value? Are there outliers with respect to "success"?
                <br><br>
                The following demonstrates that players between the age of 22 and 27 tend to command higher market values. Further, many of the names of players are repeated, as they are high-performing players that continue to perform for their squads, across seasons. In this query, we calculate the age of a player (a derived attribute) from the given season and a player's birth year.
                
                <img src="visualization/bar_animation_4.gif" class="gallery_img" alt="bar_animation_4">
            </div>

            <h4>Query 5</h4>
            <div class="gallery">
                Is there a relationship between a player's fouls (including yellow/red cards) and their position on the field?
                <br><br>
                The following demonstrates that players who have a lot of fouls tend to be in forward or midfield positions on the field. The results show the players that consistently foul more often, and it is particularly interesting to highlight the positive correlation between the number of yellow/red cards a player receives and the number of fouls they have.
                <img src="visualization/bar_animation_5.gif" class="gallery_img" alt="bar_animation_5">
            </div>
        </section>

        <section id="contact">
            <h3>Contact</h3>
            <p>Email: Carter.J.Kruse.25@Dartmouth.edu</p>
        </section>
    </main>

    <footer>
        <p>Copyright &copy; Carter Kruse 2023</p>
    </footer>

    <script src="script.js"></script>
</body>

</html> <?php 

} else {
    header("Location: index.php");
     exit();
}
