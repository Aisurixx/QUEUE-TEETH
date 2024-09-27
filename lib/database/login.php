<?php
$servername = "localhost";
$username = "root"; // Default username for XAMPP
$password = ""; // Default password for XAMPP
$dbname = "user_login";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$email = $_POST['email'];
$password = $_POST['password'];

$sql = "SELECT * FROM users WHERE email = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    if (password_verify($password, $user['password'])) {
        echo json_encode(['success' => true, 'message' => 'Login successful!']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid password.']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Email not found.']);
}

$stmt->close();
$conn->close();
?>
