<?php
  session_start();
  include "php/koneksi.php";

  if(isset($_GET['phase'])){
      $phase = $_GET['phase'];
    }

  else
    $phase=1;

    $user1 = $_SESSION["user_id"];
    $user2 = $_SESSION["user_id_2"];
    $match = $_SESSION["match_id"];

    $energy = "call sp_show_ap('$user1')";
    $result = mysqli_query($connection,$energy);
    $row = mysqli_fetch_array($result);
    $_SESSION["user_energy"]=$row['p_aksi'];
    mysqli_free_result($result);
    mysqli_next_result($connection);

    $skor = "call sp_getscore('$match',$phase)";
    $result = mysqli_query($connection,$skor);
    $row = mysqli_fetch_array($result);
    $_SESSION["skor_p1"]=$row['play1'];
    $_SESSION["skor_p2"]=$row['play2'];
    mysqli_free_result($result);
    mysqli_next_result($connection);

    $player2 = "call sp_show_name('$user2')";
    $result = mysqli_query($connection,$player2);
    $row = mysqli_fetch_array($result);
    $_SESSION["user_lawan"]=$row['p_username'];
    mysqli_free_result($result);
    mysqli_next_result($connection);


    $money = "call sp_show_money('$user1')";
    $result = mysqli_query($connection,$money);
    $row = mysqli_fetch_array($result);
    $_SESSION["user_money"]=$row['p_uang'];
    mysqli_free_result($result);
    mysqli_next_result($connection);

    $query = "call sp_show_army($user1);";
    $query .= "call sp_show_army($user2);";
    $query .= "select stat from match_record where match_id = $match;";
    if($phase==2)
      $query .= "select co2 from match_record where match_id = $match;";
    else if($phase==3)
        $query .= "select co3 from match_record where match_id = $match;";
    else if($phase==4)
        $query .= "select co4 from match_record where match_id = $match;";
    else if($phase==5)
        $query .= "select co5 from match_record where match_id = $match;";
    else
        $query .= "select co1 from match_record where match_id = $match;";
    $query .= "call sp_show_army($user2)";

    $data1 = array();
    $n=0;

    if (mysqli_multi_query($connection, $query)) {
      do {
        if ($result = mysqli_store_result($connection)){
          while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
            $row_cnt = $result->num_rows;
            if($n==0){
              $_SESSION["1c_1"] = $row['c_1'];
              $_SESSION["1c_2"] = $row['c_2'];
              $_SESSION["1c_3"] = $row['c_3'];
              $_SESSION["1c_4"] = $row['c_4'];
              $_SESSION["1c_5"] = $row['c_5'];
              $n++;
            }
            else if($n==1){
              $_SESSION["2c_1"] = $row['c_1'];
              $_SESSION["2c_2"] = $row['c_2'];
              $_SESSION["2c_3"] = $row['c_3'];
              $_SESSION["2c_4"] = $row['c_4'];
              $_SESSION["2c_5"] = $row['c_5'];
              $n++;
            }
            else if($n==2){
              echo $row['stat'];
              $_SESSION["m_result"] = $row['stat'];
              $n++;
            }
            else if($n==3){
              if($phase==2){
              $data1[0]["color"] = $row['co2'];
              }
              else if($phase==3){
              $data1[0]["color"] = $row['co3'];
              }
              else if($phase==4){
              $data1[0]["color"] = $row['co4'];
              }
              else if($phase==5){
              $data1[0]["color"] = $row['co5'];
              }
              else {
              $data1[0]["color"] = $row['co1'];
              }
              $n++;
          }
        }
        mysqli_free_result($result);
      }

    } while (mysqli_next_result($connection) && mysqli_more_results($connection));
  }

 ?>



<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Ink Horde - Battle phase</title>

    <!-- Bootstrap Core CSS -->
    <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">

    <!-- Custom Fonts -->
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="font-awesome/css/font-awesome.min.css" type="text/css">

    <!-- Plugin CSS -->
    <link rel="stylesheet" href="css/animate.min.css" type="text/css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/creative.css" type="text/css">
    <link rel="stylesheet" href="css/mystyle.css" type="text/css">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body id="page-top">

    <nav id="mainNav" class="navbar navbar-default navbar-fixed-top">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand page-scroll" href="#page-top">BATTLE PHASE</a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <!--<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li>
                        <a class="page-scroll" href="#about">About</a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#contact">Contact</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container-fluid -->
    </nav>

    <header>
      <div class="header-content">
        <div class="row">
          <div class="col-xs-6 col-md-4">
            <img id="player-left" src="<?php
            if($phase==1)
              echo $_SESSION["1c_1"];
            else if($phase==2)
              echo $_SESSION["1c_2"];
            else if($phase==3)
              echo $_SESSION["1c_3"];
            else if($phase==4)
              echo $_SESSION["1c_4"];
            else if($phase==5)
              echo $_SESSION["1c_5"];  ?>">
            <div class="name_tag"><?php echo $_SESSION['user_name']; ?> : <?php echo $_SESSION["skor_p1"]; ?></div>
          </div>
          <div class="col-xs-6 col-md-4">
            <h1><?php if($phase==1) echo "FIRST PHASE";
              else if($phase==2) echo "SECOND PHASE";
              else if($phase==3) echo "THIRD PHASE";
              else if($phase==4) echo "FOURTH PHASE";
              else if($phase==5) echo "LAST PHASE";
              $phase++; ?>
              </h1>
            <hr>
            <h1><div class="versus">VS</div></h1>
            <img id="roulette" src="<?php
            if($data1[0]["color"]==1)
              echo "red.png";
            else if($data1[0]["color"]==2)
              echo "blue.png";
            else if($data1[0]["color"]==3)
              echo "green.png";
            else if($data1[0]["color"]==4)
              echo "yellow.png";
            else if($data1[0]["color"]==5)
              echo "black.png";
            else if($data1[0]["color"]==6)
                echo "white.png";?>
            ">
            <?php if($phase!=6) {?> <a href="phase.php?phase=<?php echo $phase ?>" class="battle btn btn-primary btn-x2 page-scroll">Next Phase</a>
            <?php } ?>
            <?php
              if($phase==6) {
              if($_SESSION["m_result"]==1) {
            ?> <a href="win.php" class="battle btn btn-primary btn-x2 page-scroll">Result</a>
            <?php } ?>
            <?php if($_SESSION["m_result"]==-1) {
                ?> <a href="lose.php" class="battle btn btn-primary btn-x2 page-scroll">Result</a>
                <?php } ?>
            <?php if($_SESSION["m_result"]==0) {
                ?> <a href="draw.php" class="battle btn btn-primary btn-x2 page-scroll">Result</a>
                <?php } ?>
              <?php } ?>
        </div>
        <div class="col-xs-6 col-md-4">
          <img id="player-right" src="<?php if($phase==1)
            echo $_SESSION["2c_1"];
          else if($phase==2)
            echo $_SESSION["2c_2"];
          else if($phase==3)
            echo $_SESSION["2c_3"];
          else if($phase==4)
            echo $_SESSION["2c_4"];
          else if($phase==5)
            echo $_SESSION["2c_5"];  ?>">
          <div class="name_tag"><?php echo $_SESSION['user_name_2']; ?> : <?php echo $_SESSION["skor_p2"]; ?></div>
        </div>
      </div>
    </div>
    </header>

    <!-- jQuery -->
    <script src="js/jquery.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>

    <!-- Plugin JavaScript -->
    <script src="js/jquery.easing.min.js"></script>
    <script src="js/jquery.fittext.js"></script>
    <script src="js/wow.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="js/creative.js"></script>

</body>

</html>
