<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$sqlloaditems = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
$result = $conn->query($sqlloaditems);

if (isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloaditems = "SELECT * FROM `tbl_items` WHERE item_name LIKE '%$search%'";
}else if (isset($_POST['option'])){
	$option = $_POST['option'];
	if($option == 1){
	    $sqlloaditems = "SELECT * FROM `tbl_items` ORDER BY item_name ASC";
	}else if($option == 2){
	    $sqlloaditems = "SELECT * FROM `tbl_items` ORDER BY item_name DESC ";
	}
	else if($option == 3){
	    $sqlloaditems = "SELECT * FROM `tbl_items` ORDER BY item_price ASC";
	}
	else if($option == 4){
	    $sqlloaditems = "SELECT * FROM `tbl_items` ORDER BY item_price DESC";
	}
}else{
	$sqlloaditems = "SELECT * FROM `tbl_items`";
}

$result = $conn->query($sqlloaditems);

if ($result->num_rows > 0) {
    $items["items"] = array();
	
while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['user_id'];
        $itemlist['item_name'] = $row['item_name'];
        $itemlist['item_type'] = $row['item_type'];
        $itemlist['item_desc'] = $row['item_desc'];
        $itemlist['item_price'] = $row['item_price'];
        $itemlist['item_quantity'] = $row['item_quantity'];
        $itemlist['item_lat'] = $row['item_lat'];
        $itemlist['item_long'] = $row['item_long'];
        $itemlist['item_state'] = $row['item_state'];
        $itemlist['item_locality'] = $row['item_locality'];
		$itemlist['item_date'] = $row['item_date'];
        array_push($items["items"],$itemlist);
    }
    $response = array('status' => 'success', 'data' => $items);
    sendJsonResponse($response);
}else{
     $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}