<?php
  session_start();
  include "koneksi.php";

  $user = $_SESSION["user_id"];

  $query = "call sp_findmatch($user)";
  $result = mysqli_query($connection,$query);
  $row = mysqli_fetch_array($result);
  if($row['hasil'] > 0){
    $_SESSION["match_id"] = $row['hasil'];
    header("Location:/ink_horde/battle.php");
  }
  else {
    header("Location:/ink_horde/dashboard.php");
  }
?>
