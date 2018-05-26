<?php
    include "koneksi.php";
    $user= $_POST['user_in'];
    $pass= $_POST['pass_in'];
    $email= $_POST['email_in'];

    $query="call sp_sign('$user', '$pass', '$email')";

    //$query = "select p_username from player where p_id=1";
    //$result = mysqli_query($connection,$query) or die('Error');


    if(mysqli_query($connection, $query))
    {
      header("Location:/ink_horde/login_after_sign.php");
    }

    else {
      echo "DAFTAR GAGAL";
    }
?>
