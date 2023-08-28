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
            <img src="premier_league.png" alt="premier_league" style="width:30%">
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
            <div class="gallery">
                <img src="image_1.png" class="gallery_img" alt="image_1">
                <img src="image_2.png" class="gallery_img" alt="image_2">
                <img src="image_3.png" class="gallery_img" alt="image_3">
                <img src="image_4.png" class="gallery_img" alt="image_4">
                <img src="image_5.png" class="gallery_img" alt="image_5">
                <img src="image_6.png" class="gallery_img" alt="image_6">
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
