<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept, Origin, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$conn = new mysqli("fdb1032.awardspace.net", "4718184_wazifatidb", "@1b2c3d4e56666", "4718184_wazifatidb");
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "DB connection failed"]);
    exit();
}

$result = $conn->query("SELECT DISTINCT categories FROM job");
$categories = ["All"];
while ($row = $result->fetch_assoc()) {
    $categories[] = $row['categories'];
}

echo json_encode(["categories" => $categories]);

$conn->close();
?>
