<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept, Origin, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Method not allowed"]);
    exit();
}

// Read input (JSON or form-data)
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

$email    = trim($data['email'] ?? '');
$password = trim($data['password'] ?? '');

if ($email === "" || $password === "") {
    http_response_code(400);
    echo json_encode(["error" => "Missing email or password"]);
    exit();
}

// Connect to DB
$conn = new mysqli("fdb1032.awardspace.net", "4718184_wazifatidb", "@1b2c3d4e56666", "4718184_wazifatidb");
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "DB connection failed: " . $conn->connect_error]);
    exit();
}

// Check user
$stmt = $conn->prepare("SELECT id FROM users WHERE email = ? AND password = ?");
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    echo json_encode(["success" => "Login successful"]);
} else {
    http_response_code(401);
    echo json_encode(["error" => "Invalid email or password"]);
}

$stmt->close();
$conn->close();
?>
