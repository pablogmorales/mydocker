<?php
// This is an example for displaying some data
// we should not connect as root, use another user instead.

// Some global variables - constants.
define("DB_HOST", "localhost"); 
define("DB_USER", "root");
define("DB_PASS", "password");
define("DB_NAME", "employees");

try {       // << using Try/Catch() to catch errors!

$dbc = new PDO("mysql:host=".DB_HOST.";dbname=".DB_NAME.";charset-utf8",DB_USER,DB_PASS);
}catch(PDOException $e){ echo $e->getMessage();}

if($dbc <> true){
    die("<p>There was an error</p>");
}

$print = ""; // assign an empty string 

// The Query String
$stmt = $dbc->query("select first_name, last_name, birth_date, hire_date, gender  from employees where gender='M' and birth_date='1965-02-01' and hire_date > '1990-01-01' order by first_name");
$stmt->setFetchMode(PDO::FETCH_OBJ);

if($stmt->execute() <> 0)
{
    // Some formatting

    $print .= '<table border="1px">';
    $print .= '<th>First Name</th>';
    $print .= '<th>Last Name</th>';
    $print .= '<th>Birth Date</th></th>';
    $print .= '<th>Hire Date</th></th>';
    $print .= '<th>Gender</th></th>';


    while($names = $stmt->fetch()) // loop and display data
    {

        $print .= '<tr>';
        $print .= "<td>{$names->first_name}</td>";
        $print .= "<td>{$names->last_name}</td>";
        $print .= "<td>{$names->birth_date}</td>";
        $print .= "<td>{$names->hire_date}</td>";
        $print .= "<td>{$names->gender}</td>";

        $print .= '</tr>';
    }

    $print .= "</table>";
    echo $print;
}
?>
