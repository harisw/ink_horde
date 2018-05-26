  <?php
  session_start();
  include "php/koneksi.php";

    $user = $_SESSION["user_id"];
    $query = "call sp_show_army($user);";

    $result = mysqli_query($connection,$query);
    $num_rows = mysqli_num_rows($result);
  	$data1 = array();
    $n=1;
    if($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){
      $data1[$n]["c_1"] = $row['c_1'];
      $data1[$n]["c_2"] = $row['c_2'];
      $data1[$n]["c_3"] = $row['c_3'];
      $data1[$n]["c_4"] = $row['c_4'];
      $data1[$n]["c_5"] = $row['c_5'];
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

      <title>Ink Horde - Home</title>

      <!-- Bootstrap Core CSS -->
      <link rel="stylesheet" href="css/bootstrap.css" type="text/css">

      <!-- Custom Fonts -->
      <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>
      <link href='http://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic' rel='stylesheet' type='text/css'>
      <link rel="stylesheet" href="font-awesome/css/font-awesome.min.css" type="text/css">

      <!-- Plugin CSS -->
      <link rel="stylesheet" href="css/animate.min.css" type="text/css">

      <!-- Custom CSS -->
      <link rel="stylesheet" href="css/creative.css" type="text/css">

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

                  <a class="navbar-brand page-scroll" href="#page-top">Ink Horde</a>
                  <?php if($_SESSION["user_money"]){ ?>
                  <a class="navbar-brand page-scroll" href="#page-top"><?php echo $_SESSION["user_money"]; ?>
                    <img id="money" src="img/coin.png" height="20px" width="20px" /> </a>
                  <?php } ?>
                  <?php if($_SESSION["user_energy"]){ ?>
                  <a class="navbar-brand page-scroll" href="#page-top"><?php echo $_SESSION["user_energy"]; ?>
                    <img id="energy" src="img/flash.PNG" height="20px" width="20px"/> </a>
                  <?php } ?>
              </div>

              <!-- Collect the nav links, forms, and other content for toggling -->
              <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                  <ul class="nav navbar-nav navbar-right">
                      <?php if($_SESSION["user_name"]){ ?>
                      <li>
                          <a class="page-scroll" href="dashboard.php">Welcome <?php echo $_SESSION["user_name"]; ?></a>
                      </li>
                      <?php } ?>
                      <li>
                          <a class="page-scroll" href="build.php">Build</a>
                      </li>
                      <li>
                          <a class="page-scroll" href="shop.php">Shop</a>
                      </li>
                      <li>
                          <a class="page-scroll" href="profile.php">Profile</a>
                      </li>
                      <li>
                          <a class="page-scroll" href="php/logout.php">Log Out</a>
                      </li>
                  </ul>
              </div>
              <!-- /.navbar-collapse -->
          </div>
          <!-- /.container-fluid -->
      </nav>

      <header>
          <div class="header-content">
              <div class="header-content-inner">
                <div class="row">
                  <div class="col-xs-6 col-md-3">
                    <a class="thumbnail">
                      <img src="<?php echo $data1[1]['c_1']; ?>">
                    </a>
                  </div>
                  <div class="col-xs-6 col-md-3">
                    <a class="thumbnail">
                      <img src="<?php echo $data1[1]['c_2']; ?>" alt="card2">
                    </a>
                  </div>
                  <div class="col-xs-6 col-md-3">
                    <a class="thumbnail">
                      <img src="<?php echo $data1[1]['c_3']; ?>" alt="card3">
                    </a>
                  </div>
                  <div class="col-xs-6 col-md-3">
                    <a class="thumbnail">
                      <img src="<?php echo $data1[1]['c_4']; ?>" alt="card4">
                    </a>
                  </div>
                  <div class="col-xs-6 col-md-3">
                    <a class="thumbnail">
                      <img src="<?php echo $data1[1]['c_5']; ?>" alt="card5">
                    </a>
                  </div>
                </div>
                  <a href="php/battle_process.php" class="btn btn-primary btn-xl page-scroll">Fight Now</a>
              </div>
          </div>
      </header>

      <section id="contact">
          <div class="container">
              <div class="row">
                  <div class="col-lg-8 col-lg-offset-2 text-center">
                      <h2 class="section-heading">Let's Get In Touch!</h2>
                      <hr class="primary">
                      <p>Any Suggestion for bug or new Card? Contact Us!</p>
                  </div>
                  <div class="col-lg-4 col-lg-offset-2 text-center">
                      <i class="fa fa-phone fa-3x wow bounceIn"></i>
                      <p>+62-857-3053-8455</p>
                  </div>
                  <div class="col-lg-4 text-center">
                      <i class="fa fa-envelope-o fa-3x wow bounceIn" data-wow-delay=".1s"></i>
                      <p><a href="mailto:your-email@your-domain.com">AmikSurabaya@gmail.com</a></p>
                  </div>
              </div>
          </div>
      </section>

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
