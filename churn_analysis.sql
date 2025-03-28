-- Identify at-risk users (inactive > 3 months, low activity)
SELECT u.user_id, u.signup_date, COUNT(a.login_date) as login_count, 
       MAX(a.login_date) as last_login
FROM users u
LEFT JOIN activity_log a ON u.user_id = a.user_id
WHERE u.status = 'active'
GROUP BY u.user_id, u.signup_date
HAVING last_login < DATEADD(month, -3, GETDATE())
   OR login_count < 10
ORDER BY last_login DESC;

-- Churn rate by month
SELECT YEAR(cancel_date) as year, MONTH(cancel_date) as month,
       COUNT(*) as churned_users,
       (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users)) as churn_rate
FROM users
WHERE cancel_date IS NOT NULL
GROUP BY YEAR(cancel_date), MONTH(cancel_date);