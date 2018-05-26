<?php
	require 'conn.php';

	if(isset($_GET['page']))
	{
		$noPage = $_GET['page'];
	}
	else $noPage = 1;

	$dataPerPage = 8;
	$offset = ($noPage - 1) * $dataPerPage;

	if(isset($_GET['cat']))
	{
		$cat = $_GET['cat'];
	}
	else
	{
		$cat = 0;
	}

	$query = "call sp_select_product_limit($cat,$offset,$dataPerPage);";
	$query .= "call sp_select_product_limit_count($cat);";
	$flag = 0;

	$data1 = array();
	$data2 = array();

	if (mysqli_multi_query($conn, $query)) {
    do {
		$flag++;
		$n=1;
        /* store first result set */
			if ($result = mysqli_store_result($conn)) {
				while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				$row_cnt = $result->num_rows;
				if ($flag == 1)
				{
					$data1[$n]["produk_id"]=$row['produk_id'];
					$data1[$n]["produk_nama"]=$row['produk_nama'];
					$data1[$n]["produk_harga"]=$row['produk_harga'];
					$data1[$n]["produk_path"]=$row['produk_path'];
					$n++;
				}
				if($flag==3)
				{
					$data2[$n]['jumData']=$row['jumData'];
					$n++;
				}
            }
            mysqli_free_result($result);
        }
		else{
		}
        /* print divider */
        if (mysqli_more_results($conn)) {

        }


	} while (mysqli_next_result($conn));
	}
	
	$count_data1 = count($data1);
	$count_data2 = count($data2);
	/*for($n=1;$n<=$count_data1;$n++)
	{

		echo $data1[$n]['produk_id'].'<br>';
		echo $data1[$n]['produk_nama'].'<br>';
		echo $data1[$n]['produk_harga'].'<br>';
		echo $data1[$n]['produk_path'].'<br>';
		echo '-----------------------------------------------<br><br>';
	}
	for($n=1;$n<=$count_data2;$n++)
	{
		echo $data2[$n]['jumData'].'<br>';
		echo '-----------------------------------------------<br><br>';
	}*/
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">

  <title>Qubick</title>
  <meta name="description" content="The HTML5 Herald">
  <meta name="author" content="SitePoint">

  <link rel="stylesheet" href="css/styles.css?v=1.0">

  <!--[if lt IE 9]>
  <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
</head>

<body>

	<?php include ('navbar.php'); ?>

	<div class="header-2">
		<div class="header-text"> SHOP </div>
	</div>

	<div class="fluid-container">
	<div class="fluid-container-cat">
		<div class="cat-title">KATEGORI</div>
		<br>
		<b>FASHION</b><br>
		<a href="shop.php?cat=1">KAOS</a><br>
		<a href="shop.php?cat=2">TOTE BAG</a><br>
		<br>
		<b>STATIONERY</b><br>
		<a href="shop.php?cat=3">POSTER</a><br>
		<br>


	</div>
	<div class="fluid-container-prod">
			<div class="container-container">
				<div class="container-row">
				<?php
					for($n=1;$n<=$count_data1;$n++)
					{	echo "<div class='container-col3'>";
						echo "<a href='product.php?p=".$data1[$n]['produk_id']."'><img src=".$data1[$n]['produk_path']."></a>";
						echo "<a href='product.php?p=".$data1[$n]['produk_id']."'><div class='container-caption'>".$data1[$n]['produk_nama']."</a></div>";
						echo "<div class='container-caption2'>Rp ".$data1[$n]['produk_harga']."</div>";
						echo "</div>";
					}
				?>
				</div>
			</div>
			<div class="container-button2">
				<?php
		$jumData = $data2[1]['jumData'];
		$jumPage = ceil($jumData/$dataPerPage);

		echo "<a class='pagenav' href='".$_SERVER['PHP_SELF']."?page=1'>
			<span class='glyphicon glyphicon-fast-backward small-icon' aria-hidden='true'></span></a>";
		if ($noPage > 1) echo  "<a class='pagenav' href='".$_SERVER['PHP_SELF']."?page=".($noPage-1)."'>
			<span class='glyphicon glyphicon-chevron-left small-icon' aria-hidden='true'></span></a>";
		else echo  "<a class='pagenav'><span class='glyphicon glyphicon-chevron-left small-icon' aria-hidden='true'></span></a>";

		echo "&nbsp;";
		for($page = 1; $page <= $jumPage; $page++)
		{
			$flag = 0;
			if($page==$noPage)
			{
				echo " <a class='active pagenav'>".$noPage."</a> ";
			}

			else if($page== $noPage+1 || $page==$noPage+2 || $page==$noPage-1 || $page==$noPage-2)
			{
				echo " <a class='pagenav' href='".$_SERVER['PHP_SELF']."?page=".$page."'>".$page."</a> ";
			}
		}

		echo "&nbsp;";
		if ($noPage < $jumPage) echo "<a class='pagenav' href='".$_SERVER['PHP_SELF']."?page=".($noPage+1)."'><span class='glyphicon glyphicon-chevron-right small-icon' aria-hidden='true'></span></a>";
		else echo  "<a class='pagenav' ><span class='glyphicon glyphicon-chevron-right small-icon' aria-hidden='true'></span></a>";
		echo "<a class='pagenav' href='".$_SERVER['PHP_SELF']."?page=".$jumPage."'><span class='glyphicon glyphicon-fast-forward small-icon' aria-hidden='true'></span></a>";

	?>
			</div>
	</div>
	</div>


	<?php include ('footer.php'); ?>
</div>

  <script src="js/sliderscripts.js"></script>
  <script src="js/dropdown.js"></script>


</body>
</html>
