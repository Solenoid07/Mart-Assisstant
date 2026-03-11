-- Mart Assistant V3: Final Review Edition
-- Theme: Sales Analytics & Business Intelligence
CREATE DATABASE IF NOT EXISTS mart_assistant;
USE mart_assistant;

-- 1. Upgraded Shoes Table
-- Added 'rating' and 'last_updated' for professional tracking
CREATE TABLE IF NOT EXISTS shoes (
    shoe_id INT AUTO_INCREMENT PRIMARY KEY,
    brand ENUM('Nike', 'Adidas', 'Puma', 'Reebok', 'Bata', 'Skechers') NOT NULL,
    category ENUM('Running', 'Formal', 'Casual', 'Sports') NOT NULL,
    gender ENUM('Men', 'Women', 'Unisex') NOT NULL,
    color ENUM('Black', 'White', 'Brown', 'Blue', 'Grey', 'Red') NOT NULL,
    size ENUM('6', '7', '8', '9', '10', '11', '12') NOT NULL,
    price INT CHECK (price BETWEEN 20 AND 1000), 
    rating DECIMAL(2,1) DEFAULT 4.0 CHECK (rating BETWEEN 1.0 AND 5.0),
    stock_quantity INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY product_identity (brand, category, gender, color, size)
);

-- 2. Sales Transactions Table (The Big Differentiator)
-- Data Structure: Transactional Log. Use this for "Trend Analysis"
CREATE TABLE IF NOT EXISTS sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    shoe_id INT NOT NULL,
    quantity_sold INT DEFAULT 1,
    sale_date DATE NOT NULL,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (shoe_id) REFERENCES shoes(shoe_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS discounts (
    discount_id INT AUTO_INCREMENT PRIMARY KEY,
    shoe_id INT NOT NULL,
    pct_discount DECIMAL(5,2) CHECK (pct_discount BETWEEN 0 AND 100),
    FOREIGN KEY (shoe_id) REFERENCES shoes(shoe_id) ON DELETE CASCADE
);

-- 3. The "Smart View" for the LLM
-- Intuition: This makes the LLM's job 100% easier. Instead of calculating, it just looks here.
CREATE OR REPLACE VIEW vw_store_analytics AS
SELECT 
    s.shoe_id, s.brand, s.category, s.price,
    COALESCE(d.pct_discount, 0) as discount,
    (s.price * (1 - COALESCE(d.pct_discount, 0)/100)) as final_price,
    s.stock_quantity, s.rating
FROM shoes s
LEFT JOIN discounts d ON s.shoe_id = d.shoe_id;

-- 4. Expanded Stored Procedure (1500 records)
DELIMITER $$
CREATE PROCEDURE FinalReviewPopulate()
BEGIN
    DECLARE counter INT DEFAULT 0;
    -- Scaled up for final review
    DECLARE max_records INT DEFAULT 1500; 
    
    WHILE counter < max_records DO
        BEGIN
            DECLARE CONTINUE HANDLER FOR 1062 BEGIN END; 

            INSERT INTO shoes (brand, category, gender, color, size, price, rating, stock_quantity)
            VALUES (
                ELT(FLOOR(1 + RAND() * 6), 'Nike', 'Adidas', 'Puma', 'Reebok', 'Bata', 'Skechers'),
                ELT(FLOOR(1 + RAND() * 4), 'Running', 'Formal', 'Casual', 'Sports'),
                ELT(FLOOR(1 + RAND() * 3), 'Men', 'Women', 'Unisex'),
                ELT(FLOOR(1 + RAND() * 6), 'Black', 'White', 'Brown', 'Blue', 'Grey', 'Red'),
                ELT(FLOOR(1 + RAND() * 7), '6', '7', '8', '9', '10', '11', '12'),
                FLOOR(40 + RAND() * 900),
                (1 + (RAND() * 4)), -- Random rating between 1 and 5
                FLOOR(5 + RAND() * 150)
            );
            SET counter = counter + 1;
        END;
    END WHILE;
    
    -- Simulate some random sales for the last 30 days
    INSERT INTO sales (shoe_id, quantity_sold, sale_date, total_amount)
    SELECT shoe_id, FLOOR(1+RAND()*5), DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*30) DAY), price
    FROM shoes ORDER BY RAND() LIMIT 200;

END$$
DELIMITER ;

CALL FinalReviewPopulate();
