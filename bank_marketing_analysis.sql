CREATE DATABASE bank_marketing_project;
USE bank_marketing_project;
SHOW TABLES;
SELECT *
FROM bank_marketing
LIMIT 10;
DESCRIBE bank_marketing;
SELECT COUNT(*) AS total_customers
FROM bank_marketing;

# 1.How many customers subscribed to the term deposit?#
SELECT y,
COUNT(*) AS customer_count
FROM bank_marketing
GROUP BY y;

SELECT 
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS subscription_rate_percentage
FROM bank_marketing;
SELECT
    job,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS subscription_rate
FROM bank_marketing
GROUP BY job
ORDER BY subscription_rate DESC;
SELECT
    job,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS subscription_rate
FROM bank_marketing
GROUP BY job
ORDER BY subscription_rate DESC;

SELECT 
    MIN(age) AS youngest_customer,
    MAX(age) AS oldest_customer,
    ROUND(AVG(age), 2) AS average_age
FROM bank_marketing;

SELECT
    CASE
        WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers,

    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS subscription_rate

FROM bank_marketing

GROUP BY age_group

ORDER BY subscription_rate DESC;

#Housing Loan vs Subscription#
SELECT DISTINCT housing
FROM bank_marketing;
SELECT
    loan,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS subscription_rate
FROM bank_marketing
GROUP BY loan
ORDER BY subscription_rate DESC;

SELECT distinct contact
FROM bank_marketing;

SELECT
    contact,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS subscription_rate
FROM bank_marketing
GROUP BY contact
ORDER BY subscription_rate DESC;

#Month-wise Campaign Performance#
SELECT
    month,
    COUNT(*) AS total_contacts,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscriptions,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS subscription_rate
FROM bank_marketing
GROUP BY month
ORDER BY subscription_rate DESC;

SELECT
    month,
    COUNT(*) AS total_contacts,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscriptions,
    SUM(CASE WHEN y = 'no' THEN 1 ELSE 0 END) AS Not_subscriptions,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS subscription_rate
FROM bank_marketing
GROUP BY month
HAVING COUNT(*) >= 1000
ORDER BY subscription_rate DESC;

SELECT DISTINCT poutcome
FROM bank_marketing;
SELECT
    MIN(campaign) AS minimum_contacts,
    MAX(campaign) AS maximum_contacts,
    ROUND(AVG(campaign), 2) AS average_contacts
FROM bank_marketing;

SELECT
    CASE
        WHEN campaign = 1 THEN '1 Contact'
        WHEN campaign BETWEEN 2 AND 3 THEN '2-3 Contacts'
        WHEN campaign BETWEEN 4 AND 5 THEN '4-5 Contacts'
        ELSE '6+ Contacts'
    END AS contact_group,
    

    COUNT(*) AS total_customers,

    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS subscription_rate

FROM bank_marketing
GROUP BY contact_group
ORDER BY subscription_rate DESC;

SELECT
    month,
    day_of_week,
    COUNT(*) AS total_contacts,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS subscription_rate
FROM bank_marketing
GROUP BY month, day_of_week
ORDER BY subscription_rate DESC;

#CTE#
WITH job_summary AS (
    SELECT
        job,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers
    FROM bank_marketing
    GROUP BY job
)

SELECT
    job,
    total_customers,
    subscribed_customers,
    ROUND(
        subscribed_customers * 100.0 / total_customers,
        2
    ) AS subscription_rate
FROM job_summary
ORDER BY subscription_rate DESC;

WITH job_summary AS (
    SELECT
        job,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers
    FROM bank_marketing
    GROUP BY job
),

job_rates AS (
    SELECT
        job,
        total_customers,
        subscribed_customers,
        ROUND(
            subscribed_customers * 100.0 / total_customers,
            2
        ) AS subscription_rate
    FROM job_summary
)

SELECT
    job,
    total_customers,
    subscribed_customers,
    subscription_rate,
    RANK() OVER (
        ORDER BY subscription_rate DESC
    ) AS job_rank
FROM job_rates;

WITH job_summary AS (
    SELECT
        job,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers
    FROM bank_marketing
    GROUP BY job
),

job_rates AS (
    SELECT
        job,
        total_customers,
        subscribed_customers,
        ROUND(
            subscribed_customers * 100.0 / total_customers,
            2
        ) AS subscription_rate
    FROM job_summary
)

SELECT
    job,
    total_customers,
    subscribed_customers,
    subscription_rate,
    ROW_NUMBER() OVER (
        ORDER BY subscription_rate DESC
    ) AS job_rank
FROM job_rates;

WITH job_summary AS (
    SELECT
        job,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers
    FROM bank_marketing
    GROUP BY job
),

job_rates AS (
    SELECT
        job,
        total_customers,
        subscribed_customers,
        ROUND(
            subscribed_customers * 100.0 / total_customers,
            2
        ) AS subscription_rate
    FROM job_summary
)

SELECT
    job,
    total_customers,
    subscription_rate,
    ROUND(
        AVG(subscription_rate) OVER (),
        2
    ) AS overall_average_rate
FROM job_rates
ORDER BY subscription_rate DESC;

WITH job_summary AS (
    SELECT
        job,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers
    FROM bank_marketing
    GROUP BY job
),

job_rates AS (
    SELECT
        job,
        total_customers,
        subscribed_customers,
        ROUND(
            subscribed_customers * 100.0 / total_customers,
            2
        ) AS subscription_rate
    FROM job_summary
),

job_comparison AS (
    SELECT
        job,
        subscription_rate,
        AVG(subscription_rate) OVER () AS overall_average_rate
    FROM job_rates
)

SELECT
    job,
    subscription_rate,
    
    ROUND(overall_average_rate, 2) AS overall_average_rate,

    CASE
        WHEN subscription_rate > overall_average_rate
            THEN 'Above Average'
        WHEN subscription_rate < overall_average_rate
            THEN 'Below Average'
        ELSE 'Average'
    END AS performance

FROM job_comparison
ORDER BY subscription_rate DESC;

WITH job_education_summary AS (
    SELECT
        job,
        education,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers
    FROM bank_marketing
    GROUP BY job, education
),

job_education_rates AS (
    SELECT
        job,
        education,
        total_customers,
        subscribed_customers,
        ROUND(
            subscribed_customers * 100.0 / total_customers,
            2
        ) AS subscription_rate
    FROM job_education_summary
)

SELECT
    job,
    education,
    subscription_rate,

    RANK() OVER (
        PARTITION BY job
        ORDER BY subscription_rate DESC
    ) AS education_rank_within_job

FROM job_education_rates
ORDER BY job, education_rank_within_job;

#top 3 from each category#
WITH job_education_summary AS (
    SELECT
        job,
        education,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers
    FROM bank_marketing
    GROUP BY job, education
),

job_education_rates AS (
    SELECT
        job,
        education,
        total_customers,
        subscribed_customers,
        ROUND(
            subscribed_customers * 100.0 / total_customers,
            2
        ) AS subscription_rate
    FROM job_education_summary
),

ranked_data AS (
    SELECT
        job,
        education,
        total_customers,
        subscription_rate,

        RANK() OVER (
            PARTITION BY job
            ORDER BY subscription_rate DESC
        ) AS education_rank

    FROM job_education_rates
)

SELECT *
FROM ranked_data
WHERE education_rank <= 3
ORDER BY job, education_rank;

SELECT
    job,
    COUNT(*) AS total_customers,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS subscription_rate
FROM bank_marketing
GROUP BY job

HAVING
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)
    >
    (
        SELECT
            SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)
        FROM bank_marketing
    )

ORDER BY subscription_rate DESC;

CREATE VIEW job_subscription_summary AS

SELECT
    job,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed_customers,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS subscription_rate
FROM bank_marketing
GROUP BY job;
SELECT *
FROM job_subscription_summary;