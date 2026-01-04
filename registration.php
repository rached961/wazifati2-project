<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept, Origin, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// ✅ Handle preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// ✅ Only allow POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Method not allowed"]);
    exit();
}

// ✅ Read input (JSON or form-data)
$data = [];
$raw = file_get_contents("php://input");

if (!empty($raw)) {
    $decoded = json_decode($raw, true);
    if (is_array($decoded)) {
        $data = $decoded;
    }
}

if (empty($data)) {
    $data = $_POST;
}

// ✅ Extract fields safely
$full_name = trim($data['full_name'] ?? '');
$email     = trim($data['email'] ?? '');
$password  = trim($data['password'] ?? '');
$gender    = trim($data['gender'] ?? '');

// ✅ Validate
if ($full_name === "" || $email === "" || $password === "" || $gender === "") {
    http_response_code(400);
    echo json_encode(["error" => "Missing required fields"]);
    exit();
}

// ✅ Connect to DB
$conn = new mysqli("fdb1032.awardspace.net", "4718184_wazifatidb", "@1b2c3d4e56666", "4718184_wazifatidb");
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "DB connection failed: " . $conn->connect_error]);
    exit();
}

// ✅ Prepare statement with placeholders
$stmt = $conn->prepare("INSERT INTO users (full_name, email, password, gender) VALUES (?, ?, ?, ?)");
if (!$stmt) {
    http_response_code(500);
    echo json_encode(["error" => "Prepare failed: " . $conn->error]);
    exit();
}

// ✅ Bind parameters safely
$stmt->bind_param("ssss", $full_name, $email, $password, $gender);

// ✅ Execute
if ($stmt->execute()) {
    echo json_encode(["success" => "User created successfully"]);
} else {
    http_response_code(500);
    echo json_encode(["error" => "Insert failed: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
