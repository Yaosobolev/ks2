<?php
include "connect.php";
	$db = db_connect();
 mysql_select_db("Fortest");
 $Q=$_POST["quec1"];
  for($i = 0; $i < $Q; $i++) 
  $Numb[$i] = $_POST["que".$i];
  
  $query = "SELECT Number, Code, Glava FROM Questions";
  $result = mysql_query($query);
  $num_rows = mysql_num_rows($result);
  $true_answer = 0;
  echo "<form method=\"GET\">\n";
  $st="";
  for($i = 0; $i < $num_rows; $i++)
  { $row = mysql_fetch_array($result);   
	for($j = 0; $j < $Q; $j++)
    if (($row["Number"] == $Numb[$j]) && ($_POST["q" . $Numb[$j]] == $row["Code"])) {$true_answer++;} elseif(($row["Number"] == $Numb[$j]) && ($_POST["q" . $Numb[$j]] != $row["Code"])){$st .=$row["Glava"].",";} ;
 }
  $percent = ($true_answer / $Q) * 100;
  if ($percent < 55) { $degree = '�������������������';} elseif (($percent >= 55) && ($percent < 70)) {$degree = '�����������������';}
  elseif (($percent >= 70) && ($percent < 85)) {$degree = '������';} elseif ($percent >= 85) {$degree = '�������';}; 

  
  echo "��������� ". $_POST["Surname"]. " " . $_POST['Name']. " ". $_POST['Fathername']. ", �� ��������� �������� ��  "  . $true_answer. " �� ".$Q." �������� �����. ���� ������: $degree.<br />\n";
   
  
  if ($st!=""){
  $sr=explode (',',$st);
  $resss = array_unique($sr);
  $sts = implode(',',$resss);
  echo "��� ���������� ��������� �����: ".substr($sts, 0, strlen($sts)-1); };
  $gr = $_POST["Group"];
  $query88 = "INSERT INTO TestingResult(Surname, Name, Fathername, TestingDate, mark, GroupID) VALUES ('$_POST[Surname]', '$_POST[Name]', '$_POST[Fathername]', '" . date("Y-m-d") . "','$degree', $gr)";
  $result88 = mysql_query($query88);
  if ($result88 != 1) echo "���������� �������� ������ � ���� ������";
?>