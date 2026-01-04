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

$sql = "SELECT c.company_id, c.description, c.email, j.summary, j.details, j.categories 
        FROM company c 
        JOIN job j ON c.company_id = j.company_id";

$result = $conn->query($sql);
$companies = [];

while ($row = $result->fetch_assoc()) {
    $companies[] = [
        "company_id" => $row["company_id"],
        "description" => $row["description"],
        "email" => $row["email"],
        "summary" => $row["summary"],
        "details" => $row["details"],
        "category" => $row["categories"]
    ];
}

echo json_encode(["companies" => $companies]);

$conn->close();
?>
