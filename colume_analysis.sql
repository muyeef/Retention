/*measure the weekly
retention rate of users who adopted at least one of these new features within 7days of launch
and compare it to the retention rate of users who did not engage with these features*/

select * from features
where launch_date='2025-02-20'

---finding eligible users
CREATE VIEW retention_rate AS
with eligible_users as 
(select user_id from users
where sign_up_date<'2025-02-20' and (churn_date>'2025-02-20' or churn_date is null)),

---Findfing early adopters
adopters as (
select distinct user_id from activity_log where activity_type in ('task_reminder','voice_assistant','custom_theme')
and timestamp between '2025-02-20' and dateadd(day,7,'2025-02-20')
and user_id in (select user_id from eligible_users)),
--getting non_adopters
non_adopters as (
select eu.user_id  from eligible_users eu
left join adopters ad on eu.user_id = ad.user_id
where ad.user_id is null),


all_users as (
select eu.user_id as eligible_users,a.user_id as adopters,na.user_id as non_adopters from eligible_users eu
left join adopters a on eu.user_id=a.user_id
left join non_adopters na on na.user_id= eu.user_id),

Adopter_percentage as (
select round(count(case when adopters is not null then 1 end)* 100.0/ count(eligible_users),2) as adopters_count,
round(count(case when non_adopters is not null then 1 end)*100.0/count(eligible_users),2) as non_adopters_count
from all_users),



-- ============================================
-- STEP 4: WEEKLY RETENTION ANALYSIS
-- ============================================

-- Assign user group (adopter or non-adopter), calculate activity week, and assign row number per user per week
user_group AS (
    SELECT 
        eligible_users, 
        CASE WHEN adopters IS NOT NULL THEN 'adopter' ELSE 'non_adopter' END AS adopter_group,
        timestamp, 
        DATEDIFF(WEEK, '2025-02-20', timestamp) AS week_diff,
        ROW_NUMBER() OVER (
            PARTITION BY eligible_users, DATEDIFF(WEEK, '2025-02-20', timestamp)
            ORDER BY timestamp
        ) AS RowN
    FROM all_users 
    JOIN activity_log a ON a.user_id = all_users.eligible_users
    WHERE timestamp BETWEEN DATEADD(WEEK, -2, '2025-02-20') AND DATEADD(WEEK, 6, '2025-02-20')

	),
--Count total users per group (adopter vs non-adopter)
grouped AS (
    SELECT adopter_group, COUNT(DISTINCT eligible_users) AS all_users
    FROM user_group
    GROUP BY adopter_group
),

-- Count retained users per group per week
-- Retained means they were active at least once in that week (RowN = 1 ensures 1st appearance)
Weekly_retention AS (
    SELECT 
        adopter_group,
        week_diff, 
        COUNT(DISTINCT eligible_users) AS retained_users
    FROM user_group
    WHERE RowN = 1
    GROUP BY adopter_group, week_diff
	),

-- Final output: weekly retention rate for each group
retention_rate AS (
SELECT wr.adopter_group, week_diff, retained_users, all_users, 
round(CAST(retained_users * 100.0 AS FLOAT) / all_users,2) AS retention_rate
FROM Weekly_retention wr 
JOIN grouped g ON g.adopter_group = wr.adopter_group
), 

pivoted AS (
SELECT week_diff,
MAX(CASE WHEN adopter_group = 'adopter' THEN retention_rate END) AS 'Adopter',
MAX(CASE WHEN adopter_group = 'non_adopter' THEN retention_rate END) AS 'non_adopter'
FROM retention_rate
GROUP BY week_diff
)

SELECT week_diff, adopter, non_adopter, 
(adopter - non_adopter) AS percent_diff
FROM pivoted;






CREATE VIEW user_weekly AS
WITH eligible_users AS (
SELECT user_id 
FROM users
WHERE sign_up_date < '2025-02-20' AND (churn_date > '2025-02-20' OR churn_date IS NULL)
),

-- Identify users who engaged with new features in the first 7 days after launch
adopters AS (
SELECT DISTINCT user_id FROM activity_log
WHERE activity_type IN ('task_reminder','voice_assistant', 'custom_theme')
AND timestamp BETWEEN '2025-02-20' AND DATEADD(DAY, 7,'2025-02-20')
AND user_id IN (SELECT user_id FROM eligible_users)
),

Weeks AS (SELECT -2 AS wk
UNION ALL
SELECT -1 AS wk
UNION ALL
SELECT 0 AS wk
UNION ALL
SELECT 1 AS wk
UNION ALL
SELECT 2 AS wk
UNION ALL
SELECT 3 AS wk
UNION ALL
SELECT 4 AS wk
UNION ALL
SELECT 5 AS wk
UNION ALL
SELECT 6 AS wk),

user_weeks AS (SELECT eu.user_id,wk FROM eligible_users AS eu
CROSS JOIN Weeks)

SELECT uw.user_id,wk, CASE WHEN a.user_id IS NOT NULL THEN 'adopter' ELSE 'non_adopter' END AS adopter_group
,MAX(CASE WHEN al.user_id IS NOT NULL THEN 1 ELSE 0 END) AS active
FROM user_weeks uw
LEFT JOIN adopters a ON uw.user_id = a.user_id
LEFT JOIN activity_log al ON al.user_id = uw.user_id
AND DATEDIFF(WEEK,'2025-02-20',timestamp) = wk
GROUP BY uw.user_id,wk, a.user_id
--ORDER BY uw.user_id,wk;
SELECT * FROM user_weekly


-- UPGRADE STATUS
CREATE VIEW Plan_change AS 

WITH eligible_users AS (
SELECT user_id 
FROM users WHERE sign_up_date < '2025-02-20' 
AND (churn_date > '2025-02-20' OR churn_date IS NULL)
),

-- Identify users who engaged with new features in the first 7 days after launch
adopters AS (
SELECT DISTINCT user_id FROM activity_log
WHERE activity_type IN ('task_reminder','voice_assistant', 'custom_theme')
AND timestamp BETWEEN '2025-02-20' AND DATEADD(DAY, 7,'2025-02-20')
AND user_id IN (SELECT user_id FROM eligible_users)
),


first_billing AS 
(SELECT user_id,plan_type, MIN(billing_date) AS first_billing
FROM billing
WHERE billing_date BETWEEN DATEADD(DAY,-30,'2025-02-20') AND '2025-02-20'
GROUP BY user_id,plan_type),

second_billing AS 
(SELECT user_id,plan_type, MIN(billing_date) AS second_billing
FROM billing
WHERE billing_date BETWEEN '2025-02-20' AND DATEADD(DAY,30,'2025-02-20')
GROUP BY user_id,plan_type),


Billing_check AS 
(SELECT eu.user_id,
CASE WHEN a.user_id IS NOT NULL THEN 'adopter' ELSE 'non_adopter' END AS adopter_group,
f.first_billing AS first_billing_date,f.plan_type AS first_plan,
s.second_billing AS second_billing_date, s.plan_type AS second_plan
FROM eligible_users eu
LEFT JOIN adopters a ON eu.user_id = a.user_id
LEFT JOIN first_billing f ON f.user_id = eu.user_id
LEFT JOIN second_billing s ON s.user_id = eu.user_id
WHERE f.first_billing IS NOT NULL
AND f.plan_type <> 'Enterprise')


SELECT user_id,adopter_group,
CASE WHEN first_plan = second_plan THEN 'same_plan'
WHEN second_billing_date IS NULL AND second_plan IS NULL THEN 'No renewal'
WHEN first_plan IN ('Basic','Pro') AND  second_plan IN ('Pro', 'Enterprise') THEN 'Upgraded'
WHEN first_plan = 'Pro' AND   second_plan = 'Basic' THEN 'Down_graded' END AS plan_change
FROM Billing_check




SELECT * FROM retention_rate
SELECT * FROM Plan_change
SELECT * FROM adoption_rate

CREATE VIEW adoption_rate AS 
WITH eligible_users AS (
SELECT user_id FROM users WHERE sign_up_date < '2025-02-20' 
AND (churn_date > '2025-02-20' OR churn_date IS NULL)
),

-- Identify users who engaged with new features in the first 7 days after launch
adopters AS (
SELECT DISTINCT user_id 
FROM activity_log
WHERE activity_type IN ('task_reminder','voice_assistant', 'custom_theme')
AND timestamp BETWEEN '2025-02-20' AND DATEADD(DAY, 7,'2025-02-20')
AND user_id IN (SELECT user_id FROM eligible_users)
)


SELECT COUNT(eu.user_id) all_users,COUNT(a.user_id) adopter_cnt, 
COUNT(CASE WHEN a.user_id IS NULL THEN 1 END) AS non_adopter_cnt,
ROUND(CAST(COUNT(a.user_id) AS FLOAT) * 100.0/COUNT(eu.user_id),2) AS adoption_rate 
FROM eligible_users eu
LEFT JOIN adopters a ON a.user_id = eu.user_id;

SELECT * FROM Plan_change

CREATE VIEW weekly_login AS
WITH eligible_users AS (
SELECT user_id FROM users
WHERE sign_up_date < '2025-02-20' AND (churn_date > '2025-02-20' OR churn_date IS NULL)
),

-- Identify users who engaged with new features in the first 7 days after launch
adopters AS (
SELECT DISTINCT user_id FROM activity_log
WHERE activity_type IN ('task_reminder','voice_assistant', 'custom_theme')
AND timestamp BETWEEN '2025-02-20' AND DATEADD(DAY, 7,'2025-02-20')
AND user_id IN (SELECT user_id FROM eligible_users)
),
all_users AS (
SELECT eu.user_id as eligible_users, 
CASE WHEN a.user_id IS NOT NULL THEN 'adopter' ELSE 'non_adopter' END AS adopter_group
FROM eligible_users eu LEFT JOIN adopters a ON eu.user_id = a.user_id
),
activity_table AS (SELECT eligible_users, adopter_group,timestamp,DATEDIFF(WEEK, '2025-02-20',timestamp) AS week
FROM all_users al
JOIN activity_log a ON al.eligible_users = a.user_id
WHERE timestamp BETWEEN DATEADD(WEEK,-2,'2025-02-20') AND DATEADD(WEEK,6,'2025-02-20')),

user_weekly  AS (SELECT eligible_users,adopter_group,timestamp,week ,
ROW_NUMBER() OVER (PARTITION BY eligible_users, week ORDER BY timestamp) AS rn
FROM activity_table)

SELECT eligible_users,adopter_group,timestamp
FROM user_weekly 
WHERE rn = 1


select * from activity_log

CREATE INDEX act_timestamp ON activity_log (timestamp)