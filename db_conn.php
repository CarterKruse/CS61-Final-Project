<?php

$sname= "localhost";
$uname= "root";
$password = "password";
$db_name = "premier_league";

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conn = mysqli_connect($sname, $uname, $password, $db_name);
} catch (mysqli_sql_exception $e) {
    die ("Database Connection Error");
}

if (!$conn) {
    echo "Connection failed!";
}

?>