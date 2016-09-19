<?php
session_start();
Echo session_id();

iF ($_REQUEST['fullname']) {
    $_SESSION['fullname'] = $_REQUEST['fullname'];
}
$cmd = 'cat /proc/self/cgroup | head -1 | cut -f 3 -d "/"';
$cgroup = exec($cmd);
echo "<h3> PHP List All Session Variables</h3>";
foreach ($_SESSION as $key=>$val)
echo $key." ".$val."<br/>";
echo "Cgroup: $cgroup";
?>

<html>
<form method=POST">
  Name: <input type="text" name="fullname"><br>
  <input type="submit" value="Submit">
</form>
</html>

