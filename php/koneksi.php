<?php
$dbserver = 'localhost';
$dbuser   = 'root';
$dbpass   = '';
$dbname   = 'ink_horde';

$connection = mysqli_connect($dbserver, $dbuser, $dbpass, $dbname);

if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

?>
