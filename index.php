<?php
session_start();
echo session_id();

if ($_REQUEST['fullname']) {
    $_SESSION['fullname'] = $_REQUEST['fullname'];
}

echo "<h3> PHP List All Session Variables</h3>";
foreach ($_SESSION as $key=>$val)
echo $key." ".$val."<br/>";

?>

<html>
<form method=POST">
  Name: <input type="text" name="fullname"><br>
  <input type="submit" value="Submit">
</form>
</html>
