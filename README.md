# Bank Marketing Campaign Analysis Using MySQL

## Project Overview

This project analyzes a bank marketing campaign dataset using MySQL to identify customer characteristics and campaign factors associated with term-deposit subscriptions.

The analysis demonstrates practical SQL skills including data filtering, aggregation, conditional logic, CTEs, subqueries, views, and window functions.

The dataset contains more than 41,000 customer records with information related to customer demographics, loans, communication methods, previous marketing campaigns, and economic indicators.

---

## Dataset

Dataset: Bank Marketing Dataset

Main file used:

`bank-additional-full.csv`

The target variable is:

`y`

- `yes` = Customer subscribed to a term deposit
- `no` = Customer did not subscribe

Some important variables include:

- age
- job
- marital
- education
- housing
- loan
- contact
- month
- day_of_week
- campaign
- previous
- poutcome
- euribor3m
- nr.employed
- y

---

## Project Objectives

The main objectives of this project were to:

- Calculate the overall term-deposit subscription rate
- Identify customer segments with higher subscription rates
- Compare subscription behavior across job categories
- Analyze different age groups
- Compare customers with and without housing loans
- Compare personal loan groups
- Evaluate cellular and telephone contact methods
- Analyze campaign performance by month and weekday
- Examine previous campaign outcomes
- Analyze the relationship between the number of contacts and subscription behavior
- Rank customer segments using SQL window functions

---

## SQL Techniques Used

This project demonstrates the use of:

- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING
- DISTINCT
- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()
- ROUND()
- CASE WHEN
- Subqueries
- Common Table Expressions (CTEs)
- Views
- RANK()
- ROW_NUMBER()
- Window Functions
- PARTITION BY

---

## Example Analysis

### Overall Subscription Rate

```sql
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscriptions,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS subscription_rate
FROM bank_marketing;