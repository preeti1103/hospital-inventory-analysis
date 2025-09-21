# Hospital Inventory Optimization System
A MySQL-based project for optimizing hospital inventory management using ABC analysis.

## Project Overview
This project addresses the critical business problem of inefficient inventory management in healthcare. By building a relational database from the ground up and performing advanced SQL analysis, this system identifies high-cost medical supplies to help hospitals reduce waste and prevent shortages.

## Tech Stack
- **Database:** MySQL, PostgreSQL
- **Analysis:** SQL (CTEs, Aggregations, Joins)
- **Reporting:** Excel

## Key Features
- **Relational Database Design:** Created a normalized schema with `supplies` and `inventory_transactions` tables linked by a foreign key.
- **ABC Analysis:** Implemented a SQL-based ABC analysis to categorize inventory based on financial consumption, revealing that 20% of items accounted for 80% of spending.
- **Actionable Reporting:** Exported results to Excel to generate a diagnostic report with data visualization for management.
  
## Insights
The analysis successfully identified high-priority 'A' items such as Insulin and Surgical Gloves, providing a clear roadmap for the hospital to focus its inventory control efforts and achieve significant cost savings.

<img width="1138" height="308" alt="image" src="https://github.com/user-attachments/assets/e81bf487-8f60-472e-a294-d20e354e6354" />
<img width="782" height="536" alt="image" src="https://github.com/user-attachments/assets/44976c21-a0e7-4306-8015-6d8c03bcb0e2" />
