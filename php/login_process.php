<?php
  session_start();
  $message="";
  if(count($_POST)>0) {
    $conn = mysql_connect("localhost", "root", "");
    mysql_select_db("ink_horde", $conn);
    $result = mysql_query("SELECT p_id, p_username, p_uang, p_aksi, p_email FROM player WHERE
      p_username='".$_POST["user_in"]."' AND p_password = MD5('".$_POST["pass_in"]."') ");
      $row = mysql_fetch_array($result);
      if(is_array($row)){
        $_SESSION["user_id"] = $row[p_id];
        $_SESSION["user_name"] = $row[p_username];
        $_SESSION["user_email"] = $row[p_email];
        $_SESSION["user_money"] = $row[p_uang];
        $_SESSION["user_energy"] = $row[p_aksi];
      }
      else {
        $message = "Invalid Username or Password!";
        header("Location:/ink_horde/login.php");
      }
  }
  if(isset($_SESSION["user_id"])) {
    header("Location:/ink_horde/dashboard.php");
  }
 ?>
