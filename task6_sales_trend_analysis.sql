/* ============================================================
   TASK 6: Sales Trend Analysis Using Aggregations
   Dataset : Ecommerce
   Table   : orders
   Tools   : SQL Server / SSMS
   Author  : Ayush Baghel
   ============================================================ */


/* ============================================================
   0. CREATE DATABASE
   ============================================================ */

IF DB_ID('Ecommerce') IS NULL
BEGIN
    CREATE DATABASE Ecommercefirst;
END;
GO

USE Ecommercefirst;
GO


/* ============================================================
   1. CREATE ORDERS TABLE
   ============================================================ */

IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL
    DROP TABLE dbo.orders;
GO

CREATE TABLE dbo.orders
(
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2),
    product_id INT NOT NULL
);
GO


/* ============================================================
   2. INSERT SAMPLE DATA
   ============================================================ */

INSERT INTO dbo.orders (order_date, amount, product_id)
VALUES
('2024-01-05', 1200.00, 101),
('2024-01-10', 2500.00, 102),
('2024-01-15', 1800.00, 103),
('2024-02-03', 3200.00, 101),
('2024-02-12', 1500.00, 104),
('2024-02-20', 2700.00, 105),
('2024-03-05', 4500.00, 102),
('2024-03-15', 2100.00, 103),
('2024-03-25', 3300.00, 106),
('2024-04-08', 5000.00, 101),
('2024-04-18', 2200.00, 104),
('2024-05-02', 3500.00, 105),
('2024-05-15', 4200.00, 106),
('2024-06-10', 2800.00, 102),
('2024-06-25', 3900.00, 103),
('2024-07-05', 5200.00, 101),
('2024-07-20', 3100.00, 104),
('2024-08-12', 4600.00, 105),
('2024-08-25', 2900.00, 106),
('2024-09-07', 3700.00, 102),
('2024-09-21', 4100.00, 103),
('2024-10-05', 5500.00, 101),
('2024-10-18', 3200.00, 104),
('2024-11-03', 6000.00, 105),
('2024-11-15', 4500.00, 106),
('2024-12-05', 7500.00, 101),
('2024-12-20', 5200.00, 102),
('2024-12-28', NULL, 103);
GO


/* ============================================================
   3. QUICK DATA CHECK
   ============================================================ */

SELECT
    COUNT(*) AS total_orders,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM dbo.orders;


/* ============================================================
   4. MONTHLY REVENUE + ORDER VOLUME
   ============================================================ */

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,

    SUM(ISNULL(amount, 0)) AS monthly_revenue,

    COUNT(DISTINCT order_id) AS monthly_order_volume,

    ROUND(
        SUM(ISNULL(amount, 0)) * 1.0
        / COUNT(DISTINCT order_id),
        2
    ) AS avg_order_value

FROM dbo.orders

GROUP BY
    YEAR(order_date),
    MONTH(order_date)

ORDER BY
    order_year,
    order_month;


/* ============================================================
   5. TOP 3 MONTHS BY REVENUE
   ============================================================ */

SELECT TOP 3
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,

    SUM(ISNULL(amount, 0)) AS monthly_revenue,

    COUNT(DISTINCT order_id) AS monthly_order_volume

FROM dbo.orders

GROUP BY
    YEAR(order_date),
    MONTH(order_date)

ORDER BY
    monthly_revenue DESC;


/* ============================================================
   6. REVENUE FOR Q4 2024
   ============================================================ */

SELECT
    FORMAT(order_date, 'yyyy-MM') AS year_month,

    SUM(ISNULL(amount, 0)) AS revenue,

    COUNT(DISTINCT order_id) AS order_volume

FROM dbo.orders

WHERE order_date >= '2024-10-01'
  AND order_date < '2025-01-01'

GROUP BY
    FORMAT(order_date, 'yyyy-MM')

ORDER BY
    year_month;


/* ============================================================
   7. MONTH-OVER-MONTH GROWTH %
   ============================================================ */

WITH monthly AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(order_date),
            MONTH(order_date),
            1
        ) AS month_start,

        SUM(ISNULL(amount, 0)) AS revenue

    FROM dbo.orders

    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
),

monthly_growth AS
(
    SELECT
        month_start,
        revenue,

        LAG(revenue) OVER (
            ORDER BY month_start
        ) AS previous_month_revenue

    FROM monthly
)

SELECT
    FORMAT(month_start, 'yyyy-MM') AS year_month,

    revenue,

    previous_month_revenue,

    CASE
        WHEN previous_month_revenue IS NULL
             OR previous_month_revenue = 0
        THEN NULL

        ELSE ROUND(
            (revenue - previous_month_revenue)
            * 100.0
            / previous_month_revenue,
            2
        )
    END AS mom_growth_percent

FROM monthly_growth

ORDER BY
    month_start;


/* ============================================================
   8. NULL AMOUNT CHECK
   ============================================================ */

SELECT
    COUNT(*) AS orders_with_null_amount

FROM dbo.orders

WHERE amount IS NULL;


/* ============================================================
   9. COMPLETE DATA CHECK
   ============================================================ */

SELECT *
FROM dbo.orders
ORDER BY order_date;