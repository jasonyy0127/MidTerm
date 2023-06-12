<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
date_default_timezone_set("Asia/Kuala_Lumpur");

$name = $_POST['name'];
$email = $_POST['email'];
$password = sha1($_POST['password']);

$date = date("Y/m/d H:i:s");
$na = "na";

$sqlinsert = "INSERT INTO tbl_users (user_name,user_email,user_password,user_datareg) VALUES('$name','$email','$password','$date')";

$sqlselect = "SELECT * FROM tbl_users WHERE user_email = '$email'";
$result = mysqli_query($conn,$sqlselect);
$count = mysqli_num_rows($result);

if ($count >= 1){
    $response = array('status' => 'existed', 'data' => null);
    sendJsonResponse($response);
}else{
    if (mysqli_query($conn,$sqlinsert) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray){
    header('Content‐Type: application/json');
    echo json_encode($sentArray);
}
?>