
CREATE DATABASE mart_assistant;
USE mart_assistant;

CREATE TABLE shoes (
    shoe_id INT AUTO_INCREMENT PRIMARY KEY,
    brand ENUM('Nike', 'Adidas', 'Puma', 'Reebok', 'Bata') NOT NULL,
    color ENUM('Black', 'White', 'Brown', 'Blue', 'Grey') NOT NULL,
    size ENUM('7', '8', '9', '10', '11') NOT NULL,
    price INT CHECK (price BETWEEN 50 AND 500), -
    stock_quantity INT NOT NULL,
    UNIQUE KEY brand_color_size (brand, color, size)
);


CREATE TABLE discounts (
    discount_id INT AUTO_INCREMENT PRIMARY KEY,
    shoe_id INT NOT NULL,
    pct_discount DECIMAL(5,2) CHECK (pct_discount BETWEEN 0 AND 100),
    FOREIGN KEY (shoe_id) REFERENCES shoes(shoe_id)
);


DELIMITER $$
CREATE PROCEDURE PopulateShoes()
BEGIN
    DECLARE counter INT DEFAULT 0;
    DECLARE max_records INT DEFAULT 500; 
    DECLARE brand ENUM('Nike', 'Adidas', 'Puma', 'Reebok', 'Bata');
    DECLARE color ENUM('Black', 'White', 'Brown', 'Blue', 'Grey');
    DECLARE size ENUM('7', '8', '9', '10', '11');
    DECLARE price INT;
    DECLARE stock INT;

    
    SET SESSION rand_seed1 = UNIX_TIMESTAMP();

    WHILE counter < max_records DO
        
        SET brand = ELT(FLOOR(1 + RAND() * 5), 'Nike', 'Adidas', 'Puma', 'Reebok', 'Bata');
        SET color = ELT(FLOOR(1 + RAND() * 5), 'Black', 'White', 'Brown', 'Blue', 'Grey');
        SET size = ELT(FLOOR(1 + RAND() * 5), '7', '8', '9', '10', '11');
        SET price = FLOOR(50 + RAND() * 451); 
        SET stock = FLOOR(10 + RAND() * 91);

        
        BEGIN
            DECLARE CONTINUE HANDLER FOR 1062 BEGIN END;  
            INSERT INTO shoes (brand, color, size, price, stock_quantity)
            VALUES (brand, color, size, price, stock);
            SET counter = counter + 1;
        END;
    END WHILE;
END$$
DELIMITER ;


CALL PopulateShoes();


INSERT INTO discounts (shoe_id, pct_discount)
VALUES
(1, 10.00),
(2, 15.00),
(3, 20.00),
(4, 5.00),
(5, 25.00),
(6, 10.00),
(7, 30.00),
(8, 35.00),
(9, 40.00),
(10, 45.00),
(11, 50.00),
(12, 10.00),
(15, 20.00),
(20, 15.00),
(25, 60.00);