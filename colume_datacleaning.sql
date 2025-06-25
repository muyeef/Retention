
select count(*) from activity_log

select count(*) from billing

select count(*) from features

select count(*) from feedback

select count(*) from sessions

select count(*) from subscriptions

select count(*) from [support_tickets ]

select count(*) from system_metrics

select count(*) from [users ]









SELECT 
    SUM(CASE WHEN activity_id IS NULL THEN 1 ELSE 0 END) AS activity_id,
    SUM(CASE WHEN session_id IS NULL THEN 1 ELSE 0 END) AS session_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS user_id,
    SUM(CASE WHEN activity_type IS NULL THEN 1 ELSE 0 END) AS actitytype,
    SUM(CASE WHEN timestamp IS NULL THEN 1 ELSE 0 END) AS timestamp
FROM activity_log







SELECT 
    SUM(CASE WHEN billing_id IS NULL THEN 1 ELSE 0 END) AS billing_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS userid,
    SUM(CASE WHEN billing_date IS NULL THEN 1 ELSE 0 END) AS billingdate,
    SUM(CASE WHEN plan_type IS NULL THEN 1 ELSE 0 END) AS plan_type,
    SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS amount,
    SUM(CASE WHEN currency IS NULL THEN 1 ELSE 0 END) AS currency,
    SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS status,
	sum(case when payment_method is null then 1 else 0 end) as payment_method
FROM billing








SELECT 
    SUM(CASE WHEN feature_id IS NULL THEN 1 ELSE 0 END) AS feature_id,
    SUM(CASE WHEN feature_name IS NULL THEN 1 ELSE 0 END) AS featurename,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category,
    SUM(CASE WHEN launch_date IS NULL THEN 1 ELSE 0 END) AS launchdate,
    SUM(CASE WHEN available_plans IS NULL THEN 1 ELSE 0 END) AS availableplan
 
FROM features







SELECT 
    SUM(CASE WHEN feedback_id IS NULL THEN 1 ELSE 0 END) AS feedback_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS userid,
    SUM(CASE WHEN session_id IS NULL THEN 1 ELSE 0 END) AS session_id,
    SUM(CASE WHEN submission_timestamp IS NULL THEN 1 ELSE 0 END) AS submissiontime,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating,
    SUM(CASE WHEN comment_type IS NULL THEN 1 ELSE 0 END) AS commenttype,
    SUM(CASE WHEN comment IS NULL THEN 1 ELSE 0 END) AS comment,
	sum(case when feature_area is null then 1 else 0 end) as feature_area
FROM feedback






SELECT 
    SUM(CASE WHEN device_type IS NULL THEN 1 ELSE 0 END) as devicetype,
    SUM(CASE WHEN logout_time IS NULL THEN 1 ELSE 0 END) AS logout,
    SUM(CASE WHEN login_time IS NULL THEN 1 ELSE 0 END) AS login_time,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS user_id,
    SUM(CASE WHEN session_id IS NULL THEN 1 ELSE 0 END) AS session_id
FROM sessions




SELECT 
    SUM(CASE WHEN subscription_id IS NULL THEN 1 ELSE 0 END) AS subscription_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS userid,
    SUM(CASE WHEN [plan] IS NULL THEN 1 ELSE 0 END) AS planm,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration,
    SUM(CASE WHEN start_date IS NULL THEN 1 ELSE 0 END) AS start_date,
    SUM(CASE WHEN end_date IS NULL THEN 1 ELSE 0 END) AS enddate,
    SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS status
FROM subscriptions


select sum(case when ticket_id is null then 1 else 0 end) as ticket_id,
       sum(case when user_id is null then 1 else 0 end) as user_id,
	   sum(case when feature is null then 1 else 0 end) as feature,
	   sum(case when submitted_at is null then 1 else 0 end) as submitted_at,
	   sum(case when priority is null then 1 else 0 end ) as priority,
	   sum(case when resolved is null then 1 else 0 end ) as resolved,
	   sum(case when resolved_at is null then 1 else 0 end ) as resolved_at,
	   sum(case when status is null then 1 else 0 end ) as status
from support_tickets 



select sum( case when timestamp is null then 1 else 0 end ) as timestamp,
       sum( case when active_users is null then 1 else 0 end ) as active_users,
	   sum( case when request_count is null then 1 else 0 end ) as request_count,
	   sum( case when error_count  is null then 1 else 0 end ) as error_count,
	   sum( case when error_rate is null then 1 else 0 end ) as error_rate,
	   sum( case when cpu_usage is null then 1 else 0 end ) as cpu_usage,
	   sum( case when memory_usage is null then 1 else 0 end ) as memory_usage,
	   sum( case when response_time is null then 1 else 0 end ) as response_time
from system_metrics



SELECT sum(case when user_id is null then 1 else 0 end )as user_id,
       sum(case when Full_name is null then 1 else 0 end) as full_name ,
       sum(case when Email is null then 1 else 0 end) as email,
       sum(case when location is null then 1 else 0 end) as location,
       sum(case when age is null then 1 else 0 end) as age,
       sum(case when plan_type is null then 1 else 0 end) as plan_type,
       sum(case when sign_up_date is null then 1 else 0 end) as sign_up,
       sum(case when is_active is null then 1 else 0 end) as is_active,
       sum(case when churn_date is null then 1 else 0 end) as churn,
       sum(case when last_login_date is null then 1 else 0 end) as last_log
FROM users

-- Quantify the weekly retention rate of users who adopted the new features within 7days
--of launch
select * from activity_log
select * from features
where launch_date='2025-02-20'

--Compare retention rates of feature adopters versus non-adopters

select * from [users ]

--Analyze whether engaging with new features leads to increase user retention 
--sustain engagement over time 

select user_id, count(*) from subscriptions
group by user_id

select * from subscriptions where user_id ='2v8fcv'

--Data Cleaning 
---checking for percentage of nulls in each column
select count(*) as all_rows,count(user_id) as user_cnt,
(count(*)-count(user_id)) * 100.0 /count (*) 
from users

select * from [users ]

select 'user_id' as [column],
(count(*)-count(user_id)) * 100.0 /count (*) as percentage_of_null
from users

union all

select 'full_name',
(count(*)-count(full_name)) * 100.0 /count (*) as percentage_of_nul
from users


union all

select 'email',
(count(*)-count(email)) * 100.0 /count (*) as percentage_of_nul
from users


union all

select 'location',
(count(*)-count(location)) * 100.0 /count (*) as percentage_of_nul
from users

---checking for duplicate values
select * from clean_users
select user_id,count(*)as id from clean_users
group by user_id
having count(*)>1

drop table clean_user
with cte as (
select *,row_number() over (partition by user_id,full_name,email,location,age,
plan_type,sign_up_date,is_active,churn_date,last_login_date  order by (select null))rown
from users)

select user_id,full_name,email,location,age,
plan_type,sign_up_date,is_active,churn_date,last_login_date into clean_user
from cte 
where rown =1 and user_id is not null

with cte as (
select *,row_number() over (partition by user_id order by (select null))rowN
from clean_user)


select user_id,full_name,email,location,age,
plan_type,sign_up_date,is_active,churn_date,last_login_date into clean_users
from cte 
where rown =1 

select session_id,count(*)as id from session1
group by session_id
having count(*)>1

select * from sessions

with cte as (
select *,row_number() over (partition by session_id,user_id,login_time,logout_time,
device_type
order by (select null))rowN
from sessions)

select session_id,user_id,login_time,logout_time
device_type,rowN
into sessions
from cte 
where rowN =1

drop table clean_sessions


with cte as (
select *,row_number() over (partition by session_id
order by (select null))rowN2
from sessions)

select session_id,user_id,login_time,logout_time
device_type
INTO session1

from cte 
where rowN2 =1 

select * from subscriptions


select subscription_id,count(*)as id from subscriptions
group by subscription_id
having count(*)>1

select * from activity_log

select activity_id,count(*)as id from activity_log
group by activity_id
having count(*)>1

select * from [support_tickets ]


select ticket_id,count(*)as id from [support_tickets ]
group by ticket_id
having count(*)>1

select * from billing


select billing_id,count(*)as id from [billing ]
group by billing_id
having count(*)>1

--Checking data types
select column_name,data_type from INFORMATION_SCHEMA.COLUMNS
where table_name= 'session1'
drop table sessions

exec sp_rename 'session1','sessions'

exec sp_rename 'clean_users','users'

-- Adding primaery keys to tables

alter table users
add constraint pk_userid primary key (user_id)


select column_name,data_type,CHARACTER_MAXIMUM_LENGTH from INFORMATION_SCHEMA.COLUMNS
where table_name= 'users'

alter table users
alter column user_id nvarchar (255) not null


alter table  sessions
add constraint pk_sessionid primary key (session_id)

-- Checking trailing and leading spaces 
select * from users

select full_name,len(full_name),rtrim(ltrim(full_name))
from users
where len(full_name) != len(rtrim(ltrim(full_name)))

update users
set full_name = rtrim(ltrim(full_name))

-- Checking for invalid numbers 

select age from users
where age <16 or age >90

update users 
set age =null where age <16 or age >90

select * from users
where ISNUMERIC(age) =0

--checking for invalid date ranges

select * from users
where churn_date < sign_up_date and churn_date != sign_up_date 

update users set churn_date= sign_up_date
where churn_date < sign_up_date and churn_date != sign_up_date

select distinct status from subscriptions

select distinct [plan] from subscriptions

update subscriptions set [plan] =
 case when [plan] = 'basicc' then 'Basic'
when [plan]='Enterpris' then 'Enterprise'
else [plan] end from subscriptions



select * from billing
where plan_type = 'basic' and currency ='ngn' and amount <> 15000


update billing set amount=
case when plan_type = 'basic' and currency='ngn' then 15000
when plan_type ='pro' and currency ='ngn' then 55500
when plan_type = 'enterprise' and currency = 'ngn'  then 283500
else amount end

WITH CTE AS (SELECT user_id, plan_type, billing_date AS first_sub, 
LEAD(billing_date) OVER (PARTITION BY user_id ORDER BY billing_date) next
FROM billing),

DOUBLE_sub AS (
SELECT * FROM CTE
WHERE plan_type = 'Enterprise' AND next IS NOT NULL)

SELECT * FROM double_sub d
JOIN billing b ON b.user_id = d.user_id AND first_sub = billing_date

select plan_type,amount from [billing ]
where currency ='INR'

update billing
set plan_type='basic'
where billing_id ='b1ae7dcb-9c99-45ee-af42-87a15258dcdd'

SELECT * FROM BILLING
WHERE USER_ID ='cxlvpy'

select * from [billing ]
where plan_type='basic'

update billing
set plan_type='pro'
where user_id ='7r2fmf' 

update billing 
set amount = case when currency = 'NGN' then 55500 
                when currency = 'INR' then 2775
				when currency = 'EURO' THEN 34.0400009155273
				when currency = 'GBP'  then 27.5 
				when currency =  'USD' then 37  else amount  end 
	where user_id='7r2fmf'

update billing
set amount='7.5'
where billing_id ='b1ae7dcb-9c99-45ee-af42-87a15258dcdd'

select * from billing where amount <0


---removing negative signs
update billing
set amount=abs(amount)
where amount <0


-- Standardize 'amount' in 'billing' based on 'plan_type' and 'currency' (USD)
UPDATE billing SET amount =  CASE
    WHEN plan_type = 'Basic' AND currency = 'USD' THEN 10
    WHEN plan_type = 'Pro' AND currency = 'USD' THEN 37
    WHEN plan_type = 'Enterprise' AND currency = 'USD' THEN  189
    ELSE amount
END;

-- This seems to be an attempt to correct plan_type based on amount and currency,
-- but the condition `plan_type = 'USD'` is likely an error, should be `currency = 'USD'`
UPDATE billing SET plan_type = CASE
    WHEN currency = 'USD' AND amount <= 10 THEN 'Basic' -- Corrected: currency = 'USD'
    WHEN currency = 'USD' AND amount = 37 THEN 'Pro'    -- Corrected: currency = 'USD'
    WHEN currency = 'USD' AND amount = 189 THEN  'Enterprise' -- Corrected: currency = 'USD'
    ELSE plan_type
END;

-- Inspect 'billing' for 'Enterprise' plan in 'GBP'
SELECT * from billing
WHERE plan_type = 'Enterprise' AND currency = 'GBP';

-- Standardize 'amount' in 'billing' based on 'plan_type' and 'currency' (GBP)
-- Note: 'GPB' typo for 'GBP' in the Enterprise condition
UPDATE billing SET amount =  CASE
    WHEN plan_type = 'Basic' AND currency = 'GBP' THEN 7.5
    WHEN plan_type = 'Pro' AND currency = 'GBP' THEN 27.5
    WHEN plan_type = 'Enterprise' AND currency = 'GBP' THEN  141.75 -- Corrected typo from GPB to GBP
    ELSE amount
END;

-- Inspect 'billing' for 'Enterprise' plan in 'INR'
SELECT * from billing
WHERE plan_type = 'Enterprise' AND currency = 'INR';

-- Standardize 'amount' in 'billing' based on 'plan_type' and 'currency' (INR)
UPDATE billing SET amount =  CASE
    WHEN plan_type = 'Basic' AND currency = 'INR' THEN 750
    WHEN plan_type = 'Pro' AND currency = 'INR' THEN 2775
    WHEN plan_type = 'Enterprise' AND currency = 'INR' THEN 14175
    ELSE amount
END;

-- Inspect 'billing' for 'Enterprise' plan in 'EURO'
SELECT * FROM billing
WHERE currency = 'EURO' AND plan_type = 'Enterprise';

-- Standardize 'amount' in 'billing' based on 'plan_type' and 'currency' (EURO)
UPDATE billing SET amount = CASE
    WHEN plan_type = 'Basic' AND currency = 'EURO' THEN 9.20
    WHEN plan_type = 'Pro' AND currency = 'EURO' THEN 34.04
    WHEN plan_type = 'Enterprise' AND currency = 'EURO' THEN  173.89
    ELSE amount
END;


-- CLEANING CURRENCY COLUMN in 'billing' table

-- Show distinct currency values in the 'billing' table to identify inconsistencies
SELECT DISTINCT currency FROM billing;

-- Standardize 'currency' values in the 'billing' table
UPDATE billing SET currency =
CASE
    WHEN currency IN ('USS','XYZ') THEN 'USD' -- Consolidate variations to 'USD'
    WHEN currency IN ('EURo','EUR') THEN 'EURO' -- Consolidate variations to 'EURO'
    WHEN currency = 'NGNN' THEN 'NGN' -- Correct typo for 'NGN'
    WHEN currency IS NULL THEN 'Unknown' -- Replace NULL with 'Unknown'
    ELSE currency -- Keep other values as they are
END
FROM billing; -- Redundant FROM clause for UPDATE in some SQL dialects

-- Set 'amount' to NULL for Basic plan with paypal if amount is zero or negative.
-- This logic might need review for its specific business meaning.
UPDATE billing SET amount = CASE
    WHEN plan_type = 'Basic' AND payment_method = 'paypal' THEN NULL
    ELSE amount
END
WHERE amount <= 0; -- Condition applies to rows where amount is non-positive

-- Change the data type of the 'amount' column in 'billing' to FLOAT and allow NULLs
ALTER TABLE billing
ALTER COLUMN amount FLOAT NULL;

-- Check for records in 'billing' where amount is still less than or equal to 0 after cleaning
SELECT * FROM billing
WHERE amount <= 0;

-- Retrieve column names and data types for the 'billing' table
SELECT COLUMN_NAME, DATA_TYPE FROM
INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'billing';

-- CHECKING INVALID FOREIGN KEYS

-- Select user_ids from 'support_tickets' that do not exist in the 'users' table (potential orphaned records)
SELECT user_id FROM support_tickets WHERE user_id NOT IN (SELECT user_id FROM users);

-- Retrieve all users for inspection
SELECT * FROM users;

-- FEATURE ENGINEERING: SPLITTING 'full_name' into 'first_name' and 'last_name'

-- Add new columns 'first_name' and 'last_name' to the 'users' table
ALTER TABLE users ADD first_name VARCHAR(50), last_name VARCHAR(50);

-- CTE to find the position of the first space and the length of the full_name
WITH CTE AS (
    SELECT
        full_name,
        CHARINDEX(' ',full_name) -1 AS first_space_pos, -- Position of space minus 1 for first name length
        LEN(full_name) AS name_length
    FROM users
)
-- Select the full_name, extracted first_name, and extracted last_name
SELECT
    full_name,
    SUBSTRING(full_name,1,first_space_pos) AS first_name_extracted,
    SUBSTRING(full_name,first_space_pos + 2, name_length - (first_space_pos + 1)) AS last_name_extracted -- Corrected last_name extraction
FROM CTE
WHERE first_space_pos >= 0; -- Ensure there is a space; first_space_pos would be -1 if no space

-- Retrieve all users for inspection
SELECT * FROM users;

-- Update 'first_name' column:
-- If a space exists in 'full_name', take the substring before the first space
-- Otherwise (no space), 'first_name' becomes the entire 'full_name'.
UPDATE users SET first_name = CASE
    WHEN CHARINDEX(' ', full_name) > 0
    THEN SUBSTRING(full_name, 1, CHARINDEX(' ', full_name) -1)
    ELSE full_name
END;

-- Update 'last_name' column:
-- If a space exists in 'full_name', take the substring after the first space
-- Otherwise (no space), 'last_name' becomes NULL.
UPDATE users SET last_name = CASE
    WHEN CHARINDEX(' ', full_name) > 0
    THEN SUBSTRING(full_name,CHARINDEX(' ', full_name) + 1,LEN(full_name))
    ELSE NULL
END;

-- Remove the original 'full_name' column from the 'users' table
ALTER TABLE users
DROP COLUMN full_name;