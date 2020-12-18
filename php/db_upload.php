<?php
    $image = $_POST['image'];
    $name = $_POST['name'];
    header('Refresh: 60');
    echo $image . $name;

    $img = base64_decode($image);
    $image = $name;
    file_put_contents($image, $img);
?>
<img src="image.jpg" alt="image.jpg">