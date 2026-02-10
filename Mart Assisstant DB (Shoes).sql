-- Mart Assistant V2: Multi-Category Footwear System
CREATE DATABASE IF NOT EXISTS mart_assistant;
USE mart_assistant;

-- 1. Create the shoes table with Category and Gender for better analytics
-- Data Structure Insight: ENUM is used here to enforce 'Domain Integrity'. 
-- It acts like a 'Set' with fixed values, ensuring the LLM doesn't query brands that don't exist.
CREATE TABLE shoes (
    shoe_id INT AUTO_INCREMENT PRIMARY KEY,
    brand ENUM('Nike', 'Adidas', 'Puma', 'Reebok', 'Bata', 'Skechers') NOT NULL,
    category ENUM('Running', 'Formal', 'Casual', 'Sports') NOT NULL,
    gender ENUM('Men', 'Women', 'Unisex') NOT NULL,
    color ENUM('Black', 'White', 'Brown', 'Blue', 'Grey', 'Red') NOT NULL,
    size ENUM('6', '7', '8', '9', '10', '11', '12') NOT NULL,
    price INT CHECK (price BETWEEN 20 AND 1000), 
    stock_quantity INT NOT NULL,
    -- Unique constraint acts like a 'Hash Map' key, preventing duplicate product configurations.
    UNIQUE KEY product_identity (brand, category, gender, color, size)
);

-- 2. Create the discounts table
CREATE TABLE discounts (
    discount_id INT AUTO_INCREMENT PRIMARY KEY,
    shoe_id INT NOT NULL,
    pct_discount DECIMAL(5,2) CHECK (pct_discount BETWEEN 0 AND 100),
    FOREIGN KEY (shoe_id) REFERENCES shoes(shoe_id) ON DELETE CASCADE
);

-- 3. Stored Procedure for High-Volume Data (800 records)
DELIMITER $$
CREATE PROCEDURE PopulateMartInventory()
BEGIN
    DECLARE counter INT DEFAULT 0;
    DECLARE max_records INT DEFAULT 800; 
    
    SET SESSION rand_seed1 = UNIX_TIMESTAMP();

    WHILE counter < max_records DO
        BEGIN
            -- Handle duplicate key error (if random gen picks same combo)
            DECLARE CONTINUE HANDLER FOR 1062 BEGIN END; 

            INSERT INTO shoes (brand, category, gender, color, size, price, stock_quantity)
            VALUES (
                ELT(FLOOR(1 + RAND() * 6), 'Nike', 'Adidas', 'Puma', 'Reebok', 'Bata', 'Skechers'),
                ELT(FLOOR(1 + RAND() * 4), 'Running', 'Formal', 'Casual', 'Sports'),
                ELT(FLOOR(1 + RAND() * 3), 'Men', 'Women', 'Unisex'),
                ELT(FLOOR(1 + RAND() * 6), 'Black', 'White', 'Brown', 'Blue', 'Grey', 'Red'),
                ELT(FLOOR(1 + RAND() * 7), '6', '7', '8', '9', '10', '11', '12'),
                FLOOR(40 + RAND() * 900),
                FLOOR(5 + RAND() * 150)
            );
            SET counter = counter + 1;
        END;
    END WHILE;
END$$
DELIMITER ;

CALL PopulateMartInventory();

-- 4. Bulk Discount Strategy
-- Differentiator: Range-based logic instead of manual entry.
INSERT INTO discounts (shoe_id, pct_discount)
SELECT shoe_id, 20.00 FROM shoes WHERE brand = 'Nike' AND category = 'Running' LIMIT 20;

INSERT INTO discounts (shoe_id, pct_discount)
SELECT shoe_id, 15.00 FROM shoes WHERE price > 500 LIMIT 30;
