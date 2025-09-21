CREATE DATABASE HospitalInventory;
USE HospitalInventory;

CREATE TABLE supplies (
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    supply_name VARCHAR(255) NOT NULL,
    cost_per_unit DECIMAL(10, 2) NOT NULL
);

INSERT INTO supplies (supply_name, cost_per_unit) VALUES
('Insulin Vial (10ml)', 125.50),
('Saline Solution IV Bag (1000ml)', 8.75),
('Disposable Syringe (10-pack)', 4.99),
('Latex-Free Gloves (100-box)', 22.80),
('Paracetamol (500mg, 100-tablets)', 5.25),
('Antibiotic Ointment (50g)', 12.40),
('Face Mask (N95, 20-pack)', 45.00),
('Catheter', 18.30),
('Blood Pressure Cuff', 89.99),
('Chemotherapy Drug - Paclitaxel (per vial)', 350.00);

SELECT * FROM supplies;

CREATE TABLE inventory_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    supply_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    quantity_change INT NOT NULL,
    transaction_type ENUM('Restock', 'Usage') NOT NULL,
    FOREIGN KEY (supply_id) REFERENCES supplies(supply_id)
);

INSERT INTO inventory_transactions (supply_id, transaction_date, quantity_change, transaction_type) VALUES
-- Restock Events (Positive quantities)
(1, '2024-10-01', 50, 'Restock'),  -- Insulin
(2, '2024-10-01', 200, 'Restock'), -- Saline
(3, '2024-10-01', 100, 'Restock'), -- Syringes
(4, '2024-10-01', 50, 'Restock'),  -- Gloves
(8, '2024-10-05', 30, 'Restock'),  -- Catheters
(10, '2024-10-05', 10, 'Restock'), -- Chemo Drug (Very expensive, low quantity)

-- Usage Events (Negative quantities) - Simulating daily usage
-- High Usage Items (A Items)
(2, '2024-10-02', -15, 'Usage'), -- Saline used
(4, '2024-10-02', -8, 'Usage'),  -- Gloves used
(2, '2024-10-03', -20, 'Usage'), -- Saline used
(4, '2024-10-03', -10, 'Usage'), -- Gloves used
(2, '2024-10-07', -18, 'Usage'), -- Saline used
(4, '2024-10-07', -9, 'Usage'),  -- Gloves used
(1, '2024-10-10', -5, 'Usage'),  -- Insulin used

-- Medium/Low Usage Items (B & C Items)
(5, '2024-10-12', -2, 'Usage'),  -- Paracetamol used
(6, '2024-10-12', -1, 'Usage'),  -- Antibiotic Ointment used
(7, '2024-10-15', -3, 'Usage'),  -- Masks used
(3, '2024-10-15', -12, 'Usage'), -- Syringes used
(9, '2024-10-20', -1, 'Usage');  -- Blood Pressure Cuff used

SELECT * FROM inventory_transactions;

SELECT 
    s.supply_id,
    s.supply_name,
    SUM(t.quantity_change) AS current_stock
FROM supplies s
JOIN inventory_transactions t ON s.supply_id = t.supply_id
GROUP BY s.supply_id, s.supply_name
ORDER BY current_stock DESC;

WITH ItemSpending AS (
    SELECT 
        s.supply_id,
        s.supply_name,
        -- Calculate total units used: sum of absolute value of negative 'usage' transactions
        SUM(ABS(t.quantity_change)) AS total_units_used,
        s.cost_per_unit,
        -- Calculate total money spent on this item: units used * cost per unit
        SUM(ABS(t.quantity_change)) * s.cost_per_unit AS total_money_spent
    FROM supplies s
    JOIN inventory_transactions t ON s.supply_id = t.supply_id
    WHERE t.transaction_type = 'Usage' -- We only care about what was USED, not restocked
    GROUP BY s.supply_id, s.supply_name, s.cost_per_unit
),
SpendingWithCategory AS (
    SELECT *,
        -- Create the ABC Category based on spending
        CASE
            WHEN total_money_spent >= (SELECT MAX(total_money_spent) * 0.7 FROM ItemSpending) THEN 'A - High Value'
            WHEN total_money_spent >= (SELECT MAX(total_money_spent) * 0.2 FROM ItemSpending) THEN 'B - Medium Value'
            ELSE 'C - Low Value'
        END AS abc_category
    FROM ItemSpending
)
SELECT 
    supply_id,
    supply_name,
    total_units_used,
    cost_per_unit,
    total_money_spent,
    abc_category
FROM SpendingWithCategory
ORDER BY total_money_spent DESC;