<?php
  session_start();
  include "koneksi.php";

  $user_name_up = $_POST['user_name_up_in'];
  $password_up = $_POST['password_up_in'];
  $email_up = $_POST['email_up_in'];

  $query="call sp_update_profil($_SESSION["user_id"], $user_name_up, $password_up, $email_up)";

  if(mysqli_query($connection, $query))
  {
    header("Location:/ink_horde/dashboard.php");
  }

  else {
    echo "GAGAL!!!";
  }
?>
