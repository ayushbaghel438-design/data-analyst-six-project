# data-analyst-six-project
# Task 6: Sales Trend Analysis Using Aggregations

**DataX Labs — Data Analyst Internship**
**Author:** Ayush Baghel

## Objective
Analyze monthly revenue and order volume for an online sales dataset using SQL aggregation functions, and identify peak-performing months.

## Files in this repo
| File | Description |
|---|---|
| `task6_sales_trend_analysis.sql` | Main SQL script — monthly revenue/volume, top 3 months, period filter, MoM growth |
| `online_sales_orders.csv` | Raw dataset (3,159 orders, Jan–Dec 2024) used for this analysis |
| `monthly_sales_trend_results.csv` | Output results table (monthly revenue, volume, avg order value) |
| `monthly_trend_chart.png` | Revenue + order volume trend chart |
| `Task6_Sales_Trend_Analysis_Report.pdf` | Full report — approach, results table, chart, insights, interview Q&A |
| `generate_data.py` | Script used to generate the sample `orders` dataset |

## Dataset
Table: `orders` (online_sales)
| Column | Type |
|---|---|
| order_id | INTEGER (PK) |
| order_date | DATE |
| amount | DECIMAL(10,2) — a few NULLs included to simulate real-world messy data |
| product_id | INTEGER |

## Approach
- `EXTRACT(MONTH FROM order_date)` / `strftime('%m', order_date)` to pull month
- `GROUP BY` year, month to bucket by calendar month
- `SUM(COALESCE(amount, 0))` for monthly revenue (NULL-safe)
- `COUNT(DISTINCT order_id)` for order volume
- `ORDER BY` for chronological trend / revenue ranking
- `LIMIT 3` for top-performing months; `WHERE ... BETWEEN` for specific period slicing

## Key Result
| Rank | Month | Revenue (Rs.) | Order Volume |
|---|---|---|---|
| 1 | Dec 2024 | 18,49,639.73 | 412 |
| 2 | Nov 2024 | 18,39,344.51 | 403 |
| 3 | Mar 2024 | 12,49,469.97 | 274 |

Nov–Dec 2024 (festive/year-end season) are the clear peak months, with revenue up ~67% from October to November, driven mainly by order volume rather than basket size.

## Outcome
Learned how to group data by time period and use aggregate functions (`SUM`, `COUNT DISTINCT`) to analyze sales trends, along with NULL-safe aggregation and ranking with `LIMIT`.
