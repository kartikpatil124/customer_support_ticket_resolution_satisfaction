create database customer_support_ticket;

use customer_support_ticket;

CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY,
    created_date VARCHAR(20),
    issue_category VARCHAR(50),
    priority VARCHAR(20),
    first_response_minutes INT,
    resolution_time_hours INT,
    agent_experience_years DECIMAL(4,1),
    reopened VARCHAR(10),
    channel VARCHAR(20),
    customer_satisfaction VARCHAR(20)
);


LOAD DATA LOCAL INFILE 'C:/Kartik/DataAnalysis/DataSets/Customer Support Ticket Satisfaction Analysis/customer_support_ticket_resolution_satisfaction.csv'
INTO TABLE support_tickets
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    ticket_id,
    created_date,
    issue_category,
    priority,
    first_response_minutes,
    resolution_time_hours,
    agent_experience_years,
    reopened,
    channel,
    customer_satisfaction
);


SELECT COUNT(*) AS total_tickets
FROM support_tickets;

SELECT *
FROM support_tickets
LIMIT 10;

select
	ticket_id,
	count(*) as duplicate_count
    from support_tickets
    group by ticket_id
    having count(*) > 1;
    
    SELECT
    SUM(ticket_id IS NULL) AS missing_ticket_id,
    SUM(created_date IS NULL) AS missing_created_date,
    SUM(issue_category IS NULL) AS missing_issue_category,
    SUM(priority IS NULL) AS missing_priority,
    SUM(first_response_minutes IS NULL) AS missing_first_response,
    SUM(resolution_time_hours IS NULL) AS missing_resolution_time,
    SUM(agent_experience_years IS NULL) AS missing_experience,
    SUM(reopened IS NULL) AS missing_reopened,
    SUM(channel IS NULL) AS missing_channel,
    SUM(customer_satisfaction IS NULL) AS missing_satisfaction
FROM support_tickets;


-- QUERY 1: Resolution Performance by Issue Category

SELECT
    issue_category,
    COUNT(*) AS total_tickets,
    ROUND(AVG(first_response_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(reopened = 'Yes') * 100, 2) AS reopen_rate_percent,
    ROUND(AVG(
        CASE
            WHEN customer_satisfaction = 'High' THEN 3
            WHEN customer_satisfaction = 'Medium' THEN 2
            WHEN customer_satisfaction = 'Low' THEN 1
        END
    ), 2) AS avg_satisfaction_score
FROM support_tickets
GROUP BY issue_category
ORDER BY avg_resolution_hours DESC;

-- QUERY 2: Service Quality by Channel

SELECT
    channel,
    COUNT(*) AS total_tickets,
    ROUND(AVG(first_response_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(reopened = 'Yes') * 100, 2) AS reopen_rate_percent,
    ROUND(AVG(
        CASE
            WHEN customer_satisfaction = 'High' THEN 3
            WHEN customer_satisfaction = 'Medium' THEN 2
            WHEN customer_satisfaction = 'Low' THEN 1
        END
    ), 2) AS avg_satisfaction_score
FROM support_tickets
GROUP BY channel
ORDER BY avg_resolution_hours DESC;

-- QUERY 3: Priority and Resolution Performance

SELECT
    priority,
    COUNT(*) AS total_tickets,
    ROUND(AVG(first_response_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(reopened = 'Yes') * 100, 2) AS reopen_rate_percent,
    ROUND(AVG(
        CASE
            WHEN customer_satisfaction = 'High' THEN 3
            WHEN customer_satisfaction = 'Medium' THEN 2
            WHEN customer_satisfaction = 'Low' THEN 1
        END
    ), 2) AS avg_satisfaction_score
FROM support_tickets
GROUP BY priority
ORDER BY
    CASE priority
        WHEN 'Urgent' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
    END;
    
    
    
