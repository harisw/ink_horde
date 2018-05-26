<?php
session_start();
include "php/koneksi.php";

$query = "select c_nama from card where c_id = 1;";
$query .= "select c_nama from card where c_id = 2;";

	$flag = 0;

	$data1 = array();
	$data2 = array();

	if (mysqli_multi_query($connection, $query)) {
    do {
		$flag++;
    echo $flag;
		$n=1;
        /* store first result set */
			if ($result = mysqli_store_result($connection)) {
				while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				$row_cnt = $result->num_rows;
        echo $flag;
        echo '++++++++++++++++';
        if ($flag == 1)
				{
					$data1[$n]["c_nama"]=$row['c_nama'];
          echo 'insert';
					$n++;
				}
				if($flag==2)
				{
					$data2[$n]["c_nama"]=$row['c_nama'];
          echo 'insert';
					$n++;
				}
            }
            mysqli_free_result($result);
        }
		else{
		}
        /* print divider */
        if (mysqli_more_results($connection)) {
          echo '-----------------------------------------------<br><br>';

        }


	} while (mysqli_next_result($connection));
	}

	$count_data1 = count($data1);
	$count_data2 = count($data2);
  echo $count_data1;
  echo $count_data2;

	for($n=1;$n<=$count_data1;$n++)
	{

    echo '-----------------------------------------------<br><br>';
		echo $data1[$n]['c_nama'].'<br>';
	}
	for($n=1;$n<=$count_data2;$n++)
	{
		echo $data2[$n]['c_nama'].'<br>';
		echo '-----------------------------------------------<br><br>';
	}
?>
