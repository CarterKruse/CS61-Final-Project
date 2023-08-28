<!DOCTYPE html>
<html>

<head>
    <title>Login</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>

<body class="index">
     <form action="login.php" method="post">
        <label>Username</label>
        <input type="text" name="username" placeholder=""><br>

        <label>Password</label>
        <input type="password" name="password" placeholder=""><br>
        
        <button type="submit">Login</button>

        <?php if (isset($_GET['error'])) { ?>
            <p class="error"><?php echo $_GET['error']; ?></p>
        <?php } ?>
     </form>
</body>

</html>
