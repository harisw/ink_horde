<?php
  session_start();
  include "koneksi.php";

  $user = $_SESSION['user_id'];
  $card_out_up = $_POST['card_out'];
  $card_in_up = $_POST['card_in'];

  $query="call sp_build($user, $card_out_up, $card_in_up)";

  if(mysqli_query($connection, $query))
  {
    header("Location:../dashboard.php");
  }

  else {
    echo "GAGAL!!!";
  }
?>
