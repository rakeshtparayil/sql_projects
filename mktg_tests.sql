Common Table Expressions (CTEs) for marketing analytics

-- Create the marketing_campaigns table
CREATE TABLE marketing_campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100),
    channel VARCHAR(50),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10, 2),
    target_audience VARCHAR(50)
);

-- Create the marketing_metrics table
CREATE TABLE marketing_metrics (
    metric_id INT PRIMARY KEY,
    campaign_id INT,
    date DATE,
    impressions INT,
    clicks INT,
    conversions INT,
    cost DECIMAL(10, 2),
    revenue DECIMAL(10, 2),
    FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(campaign_id)
);

-- Insert sample data into marketing_campaigns table
INSERT INTO marketing_campaigns
    (campaign_id, campaign_name, channel, start_date, end_date, budget, target_audience)
VALUES
    (1, 'Summer Sale 2024', 'Email', '2024-06-01', '2024-06-30', 5000.00, 'Existing Customers'),
    (2, 'Back to School', 'Social Media', '2024-08-01', '2024-08-31', 7500.00, 'Parents'),
    (3, 'Holiday Special', 'Search', '2024-11-15', '2024-12-25', 10000.00, 'All'),
    (4, 'New Product Launch', 'Display', '2024-09-10', '2024-10-10', 8000.00, 'New Customers'),
    (5, 'Brand Awareness', 'Video', '2024-07-01', '2024-07-31', 6000.00, 'Prospects');

-- Insert sample data into marketing_metrics table
INSERT INTO marketing_metrics
    (metric_id, campaign_id, date, impressions, clicks, conversions, cost, revenue)
VALUES
    (1, 1, '2024-06-01', 5000, 350, 42, 500.00, 2100.00),
    (2, 1, '2024-06-08', 4800, 320, 38, 480.00, 1900.00),
    (3, 1, '2024-06-15', 5200, 370, 45, 520.00, 2250.00),
    (4, 1, '2024-06-22', 5500, 390, 47, 550.00, 2350.00),
    (5, 2, '2024-08-01', 10000, 520, 35, 750.00, 1750.00),
    (6, 2, '2024-08-08', 12000, 580, 42, 800.00, 2100.00),
    (7, 2, '2024-08-15', 15000, 650, 48, 850.00, 2400.00),
    (8, 2, '2024-08-22', 14000, 620, 45, 830.00, 2250.00),
    (9, 3, '2024-11-15', 8000, 480, 32, 900.00, 1600.00),
    (10, 3, '2024-11-22', 9500, 570, 38, 950.00, 1900.00),
    (11, 3, '2024-11-29', 12000, 720, 58, 1000.00, 2900.00),
    (12, 3, '2024-12-06', 15000, 900, 72, 1200.00, 3600.00),
    (13, 4, '2024-09-10', 7500, 450, 25, 700.00, 1250.00),
    (14, 4, '2024-09-17', 8000, 480, 28, 750.00, 1400.00),
    (15, 4, '2024-09-24', 8500, 510, 32, 800.00, 1600.00),
    (16, 4, '2024-10-01', 9000, 540, 36, 850.00, 1800.00),
    (17, 5, '2024-07-01', 20000, 380, 15, 600.00, 750.00),
    (18, 5, '2024-07-08', 22000, 420, 18, 650.00, 900.00),
    (19, 5, '2024-07-15', 25000, 475, 22, 700.00, 1100.00),
    (20, 5, '2024-07-22', 23000, 437, 20, 680.00, 1000.00);

-- Example CTE query 1: Calculate campaign performance metrics
WITH campaign_performance AS (
    SELECT 
        c.campaign_id,
        c.campaign_name,
        c.channel,
        SUM(m.impressions) AS total_impressions,
        SUM(m.clicks) AS total_clicks,
        SUM(m.conversions) AS total_conversions,
        SUM(m.cost) AS total_cost,
        SUM(m.revenue) AS total_revenue,
        (SUM(m.revenue) - SUM(m.cost)) AS profit,
        (SUM(m.revenue) / SUM(m.cost)) AS roi
    FROM marketing_campaigns c
    JOIN marketing_metrics m ON c.campaign_id = m.campaign_id
    GROUP BY c.campaign_id, c.campaign_name, c.channel
)
SELECT * FROM campaign_performance
ORDER BY roi DESC;

-- Example CTE query 2: Weekly performance trends with week-over-week comparison
WITH weekly_metrics AS (
    SELECT 
        c.campaign_id,
        c.campaign_name,
        DATE_TRUNC('week', m.date) AS week_start,
        SUM(m.impressions) AS impressions,
        SUM(m.clicks) AS clicks,
        SUM(m.conversions) AS conversions,
        SUM(m.cost) AS cost,
        SUM(m.revenue) AS revenue,
        (SUM(m.clicks) * 100.0 / SUM(m.impressions)) AS ctr,
        (SUM(m.conversions) * 100.0 / SUM(m.clicks)) AS conversion_rate
    FROM marketing_campaigns c
    JOIN marketing_metrics m ON c.campaign_id = m.campaign_id
    GROUP BY c.campaign_id, c.campaign_name, DATE_TRUNC('week', m.date)
),
weekly_comparison AS (
    SELECT 
        campaign_id,
        campaign_name,
        week_start,
        impressions,
        clicks,
        conversions,
        cost,
        revenue,
        ctr,
        conversion_rate,
        LAG(impressions) OVER (PARTITION BY campaign_id ORDER BY week_start) AS prev_impressions,
        LAG(clicks) OVER (PARTITION BY campaign_id ORDER BY week_start) AS prev_clicks,
        LAG(conversions) OVER (PARTITION BY campaign_id ORDER BY week_start) AS prev_conversions,
        LAG(revenue) OVER (PARTITION BY campaign_id ORDER BY week_start) AS prev_revenue
    FROM weekly_metrics
)
SELECT 
    campaign_id,
    campaign_name,
    week_start,
    impressions,
    clicks,
    conversions,
    cost,
    revenue,
    ctr,
    conversion_rate,
    CASE 
        WHEN prev_impressions IS NULL THEN NULL
        ELSE ((impressions - prev_impressions) * 100.0 / prev_impressions)
    END AS impressions_growth_pct,
    CASE 
        WHEN prev_revenue IS NULL THEN NULL
        ELSE ((revenue - prev_revenue) * 100.0 / prev_revenue)
    END AS revenue_growth_pct
FROM weekly_comparison
ORDER BY campaign_id, week_start;

-- Example CTE query 3: Channel performance comparison
WITH channel_metrics AS (
    SELECT 
        c.channel,
        COUNT(DISTINCT c.campaign_id) AS num_campaigns,
        SUM(m.impressions) AS total_impressions,
        SUM(m.clicks) AS total_clicks,
        SUM(m.conversions) AS total_conversions,
        SUM(m.cost) AS total_cost,
        SUM(m.revenue) AS total_revenue,
        (SUM(m.clicks) * 100.0 / SUM(m.impressions)) AS avg_ctr,
        (SUM(m.conversions) * 100.0 / SUM(m.clicks)) AS avg_conversion_rate,
        (SUM(m.revenue) - SUM(m.cost)) AS profit,
        (SUM(m.revenue) / SUM(m.cost)) AS roi
    FROM marketing_campaigns c
    JOIN marketing_metrics m ON c.campaign_id = m.campaign_id
    GROUP BY c.channel
)
SELECT * FROM channel_metrics
ORDER BY roi DESC;

-- Windows Functions for Marketing Analytics

-- Example 1: Ranking campaigns by conversion rate
SELECT 
    campaign_id,
    campaign_name,
    channel,
    SUM(conversions) AS total_conversions,
    SUM(clicks) AS total_clicks,
    (SUM(conversions) * 100.0 / SUM(clicks)) AS conversion_rate,
    RANK() OVER (ORDER BY (SUM(conversions) * 100.0 / SUM(clicks)) DESC) AS conversion_rate_rank
FROM marketing_campaigns c
JOIN marketing_metrics m ON c.campaign_id = m.campaign_id
GROUP BY campaign_id, campaign_name, channel
ORDER BY conversion_rate_rank;

-- Example 2: Running total of campaign spend over time
SELECT 
    c.campaign_id,
    c.campaign_name,
    m.date,
    m.cost AS daily_cost,
    SUM(m.cost) OVER (
        PARTITION BY c.campaign_id 
        ORDER BY m.date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_cost,
    c.budget AS total_budget,
    (SUM(m.cost) OVER (
        PARTITION BY c.campaign_id 
        ORDER BY m.date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) / c.budget * 100) AS budget_used_percentage
FROM marketing_campaigns c
JOIN marketing_metrics m ON c.campaign_id = m.campaign_id
ORDER BY c.campaign_id, m.date;

-- Example 3: Moving average of conversions (3-point)
SELECT 
    c.campaign_id,
    c.campaign_name,
    m.date,
    m.conversions,
    AVG(m.conversions) OVER (
        PARTITION BY c.campaign_id 
        ORDER BY m.date
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS three_point_avg_conversions
FROM marketing_campaigns c
JOIN marketing_metrics m ON c.campaign_id = m.campaign_id
ORDER BY c.campaign_id, m.date;

-- Example 4: Comparing each campaign's performance to channel average
WITH channel_averages AS (
    SELECT 
        c.channel,
        AVG(m.clicks) AS avg_channel_clicks,
        AVG(m.conversions) AS avg_channel_conversions,
        AVG(m.revenue) AS avg_channel_revenue
    FROM marketing_campaigns c
    JOIN marketing_metrics m ON c.campaign_id = m.campaign_id
    GROUP BY c.channel
)
SELECT 
    c.campaign_id,
    c.campaign_name,
    c.channel,
    SUM(m.clicks) AS total_clicks,
    SUM(m.conversions) AS total_conversions,
    SUM(m.revenue) AS total_revenue,
    ca.avg_channel_clicks,
    ca.avg_channel_conversions,
    ca.avg_channel_revenue,
    (SUM(m.clicks) - ca.avg_channel_clicks) / ca.avg_channel_clicks * 100 AS clicks_vs_channel_avg_pct,
    (SUM(m.conversions) - ca.avg_channel_conversions) / ca.avg_channel_conversions * 100 AS conversions_vs_channel_avg_pct,
    (SUM(m.revenue) - ca.avg_channel_revenue) / ca.avg_channel_revenue * 100 AS revenue_vs_channel_avg_pct
FROM marketing_campaigns c
JOIN marketing_metrics m ON c.campaign_id = m.campaign_id
JOIN channel_averages ca ON c.channel = ca.channel
GROUP BY c.campaign_id, c.campaign_name, c.channel, ca.avg_channel_clicks, ca.avg_channel_conversions, ca.avg_channel_revenue
ORDER BY c.channel, revenue_vs_channel_avg_pct DESC;

-- Example 5: Identifying best and worst performing days for each campaign
SELECT 
    campaign_id,
    campaign_name,
    date,
    conversions,
    revenue,
    FIRST_VALUE(date) OVER (
        PARTITION BY campaign_id 
        ORDER BY revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS best_revenue_date,
    MAX(revenue) OVER (
        PARTITION BY campaign_id
    ) AS best_revenue,
    FIRST_VALUE(date) OVER (
        PARTITION BY campaign_id 
        ORDER BY revenue ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS worst_revenue_date,
    MIN(revenue) OVER (
        PARTITION BY campaign_id
    ) AS worst_revenue
FROM marketing_campaigns c
JOIN marketing_metrics m ON c.campaign_id = m.campaign_id
ORDER BY campaign_id, date;

SELECT