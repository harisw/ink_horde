<?php
  session_start();
  include "koneksi.php";

  $c_id_in = $_GET['id'];
  $p_id_in = $_SESSION['user_id'];
  $query = "CALL sp_buy_shop($p_id_in,$c_id_in)";

  if(mysqli_query($connection, $query)){
    header("Location:/ink_horde/shop.php");
  }

  else{
    header("Location:/ink_horde/index.php");
  }

?>
