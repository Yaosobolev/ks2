<html>
<head>
<title></title>
  <style type="text/css">
	.center {
	  text-align: center;
	}
  </style>
<body>
<?php
 include "connect.php";
	$db = db_connect();
  mysql_select_db("Fortest");
  

    echo "<form method=\"POST\" action=\"all.php\">\n";
    $query = "SELECT COUNT(Number) FROM Questions";
    $result = mysql_query($query) or trigger_error(mysql_error().$query);
	$row = mysql_fetch_row($result);
	$question_count = $row[0];
	$query = "SELECT TestingResult.Name, TestingResult.Surname, TestingResult.Fathername, TestingResult.TestingDate, TestingResult.mark, Groups.Name as GName
FROM TestingResult, Groups
WHERE    Groups.id= TestingResult.GroupID
	ORDER BY Surname ASC";
    $result = mysql_query($query);
	if ($result)
	{	
	 // $num_rows = mysql_num_rows($result);
	   $num_rows = mysql_num_rows($result);
	  if(isset($_GET["print"]))
	echo "<H3 style=\"margin-left: 5em;\"> ����� o ����������� ������������.</H3>";
	else	  
	  echo "<br><H4 align=left>���������� ������������.</H4>";
	  echo "<table cellpadding=5 border=2>\n";
	  echo "<tr><th width=50>�����</th><th width=100>�������</th><th width=100>���</th><th width=100>��������</th><th width=100>���� ������������</th><th width=100>������</th><th width=100>������</th></tr>\n";
	  for($i = 0; $i < $num_rows; $i++)
	  {
		$row = mysql_fetch_array($result); 
		echo "<tr><td class=\"center\">".($i+1)."</td><td>$row[Surname]</td><td>$row[Name]</td><td>$row[Fathername]</td><td class=\"center\">$row[TestingDate]</td><td class=\"center\">$row[mark]</td><td>$row[GName]</td></tr>\n";
	  }
	   echo "</table>";
	}
	else 
	{
	echo "���������� ���������� ��� �����������\n";
	}
	if(!isset($_GET["print"]))
	{  
		echo "<a style=\"float: left;\" href=\"teacher.php\"> ����� � ������ ��������</a>";
		echo "<a style=\"float: right;margin-right: 10px;\"  href=\"All.php\" target=blank> ������ ��� ������ </a>";	
	}
?>
</html>
</head>
</body>