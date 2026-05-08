-- ============================================================
-- Project  : Digital Marketing Metrics & KPIs to Measure Analysis
-- Tool     : MySQL
-- Dataset  : Digital Marketing Metrics & KPIs to Measure (SQL) by SINDERPREET
-- Author   : Kajornpong Jee-in
-- Date     : May 2026
-- ============================================================

-- Part 1: Import Dataset
DROP TABLE IF EXISTS marketing_dataset;

CREATE TABLE marketing_dataset(
				id TEXT,
                c_date TEXT,
                campaign_name TEXT,
                category TEXT,
                campaign_id TEXT,
                impressions TEXT,
                mark_spent TEXT,
                clicks TEXT,
                leads TEXT,
                orders TEXT,
                revenue TEXT
                );

DESCRIBE marketing_dataset;

LOAD DATA LOCAL INFILE '/Users/kajornpongjee-in/Desktop/2026 your year Earth/Data Analyst/Project/Marketing/Marketing.csv'
INTO TABLE marketing_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(id,
c_date,	
campaign_name,
category,
campaign_id,
impressions,
mark_spent,
clicks,
leads,
orders,
revenue
);


DROP TABLE IF EXISTS marketing_dataset_clean;

CREATE TABLE marketing_dataset_clean(
				id VARCHAR(100),
                c_date DATE,
                campaign_name VARCHAR(100),
                category VARCHAR(100),
                campaign_id VARCHAR(100),
                impressions INT,
                mark_spent DECIMAL(10,2),
                clicks INT,
                leads INT,
                orders INT,
                revenue DECIMAL(10,2)
                );

INSERT INTO marketing_dataset_clean
SELECT
				id,
                STR_TO_DATE(NULLIF(c_date,''), '%Y-%m-%d'),
                NULLIF(campaign_name,''),
                NULLIF(category,''),
                NULLIF(campaign_id,''),
                CAST(NULLIF(impressions, '') AS UNSIGNED),
                CAST(NULLIF(mark_spent, '') AS DECIMAL(10,2)),
                CAST(NULLIF(clicks, '') AS UNSIGNED),
				CAST(NULLIF(leads, '') AS UNSIGNED),
                CAST(NULLIF(orders, '') AS UNSIGNED),
                CAST(NULLIF(revenue, '') AS  DECIMAL(10,2))
FROM marketing_dataset
WHERE c_date <> 'c_date';

-- Part 2: Data Validation
-- Structure
DESCRIBE marketing_dataset_clean;

-- Completeness
SELECT COUNT(*)
FROM marketing_dataset_clean;

SELECT COUNT(*)
FROM marketing_dataset;

SELECT *
FROM marketing_dataset
WHERE c_date = 'c_date';

SELECT *
FROM marketing_dataset_clean
WHERE id = 'id';


-- Check missing value
SELECT COUNT(id),
		COUNT(c_date),	
		COUNT(campaign_name),
		COUNT(category),
		COUNT(campaign_id),
		COUNT(impressions),
		COUNT(mark_spent),
		COUNT(clicks),
		COUNT(leads),
		COUNT(orders),
		COUNT(revenue)
FROM marketing_dataset_clean;

-- Check duplicate
SELECT id,
		c_date,
        COUNT(*)
FROM marketing_dataset_clean
GROUP BY id, c_date
HAVING COUNT(*) > 1;

-- Logic checking
SELECT COUNT(*)
FROM marketing_dataset_clean
WHERE clicks > impressions;

SELECT COUNT(*)
FROM marketing_dataset_clean
WHERE leads > clicks;

SELECT COUNT(*)
FROM marketing_dataset_clean
WHERE orders > leads;

-- Min and Max check
SELECT MIN(impressions),
		MAX(impressions),
        MIN(mark_spent),
		MAX(mark_spent),
        MIN(clicks),
        MAX(clicks),
        MIN(leads),
        MAX(leads),
        MIN(orders),
        MAX(orders),
        MIN(revenue),
		MAX(revenue)
FROM marketing_dataset_clean;

-- Check negative number
SELECT COUNT(*)
FROM marketing_dataset_clean
WHERE impressions < 0
	OR mark_spent < 0
	OR clicks < 0
    OR leads < 0
	OR orders < 0
	OR revenue < 0;
    
-- Check Distinct value

SELECT DISTINCT campaign_name
FROM marketing_dataset_clean;

SELECT DISTINCT category
FROM marketing_dataset_clean;

-- Part 3: Data Exploratory
-- Campaign overview
-- How many campaigns exist, and how long does each run?
SELECT DISTINCT campaign_name,
		MIN(DATE(c_date)) AS start_date,
        MAX(DATE(c_date)) AS end_date,
		DATEDIFF(MAX(DATE(c_date)),MIN(DATE(c_date))) AS  campaign_length
FROM marketing_dataset_clean
GROUP BY campaign_name;
-- Insight: They have 11 campaigns and every campaigns run from 2021-02-01 to 2021-02-28

-- How many categories exist?
SELECT DISTINCT category
FROM marketing_dataset_clean;
-- Insight: They have 4 categories

-- Funnel — volume at each stage
-- Which category has the most impressions?
SELECT  category,
        SUM(impressions) AS total_impressions
FROM marketing_dataset_clean
GROUP BY category
ORDER BY SUM(impressions)  DESC;
-- Insight: Media has the highestimpressions, followed by social, inflencer and search.

-- Which campaign has the most impressions?
SELECT  campaign_name,
		category,
        SUM(impressions) AS total_impressions
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY SUM(impressions)  DESC;
-- Insight: banner_partner has the highest impression, followed by instagram_tier2, instagram_tier1

-- Which category has the most clicks?
SELECT  category,
        SUM(clicks) AS total_clicks
FROM marketing_dataset_clean
GROUP BY category
ORDER BY SUM(clicks)  DESC;
-- Insight: Social has the highest clicks, followed by inflencer, media and search.

-- Which campaign has the most clicks?
SELECT  campaign_name,
		category,
        SUM(clicks) AS total_clicks
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY SUM(clicks)  DESC;
-- Insight: instagram_tier2 has the most clicks, followed by youtube_blogger, banner_partner.

-- Which category has the most leads?
SELECT  category,
        SUM(leads) AS total_leads
FROM marketing_dataset_clean
GROUP BY category
ORDER BY SUM(leads)  DESC;
-- Insight: Social has the highest leads, followed by inflencer, media and search.

-- Which campaign has the most leads?
SELECT  campaign_name,
		category,
        SUM(leads) AS total_leads
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY SUM(leads)  DESC;
-- Insight: instagram_tier2 has the most leads followed by banner_partner, youtube_blogger.

-- Which category has the most orders?
SELECT  category,
        SUM(orders) AS total_orders
FROM marketing_dataset_clean
GROUP BY category
ORDER BY SUM(orders)  DESC;
-- Insight: Influencer has the highest orders, followed by social, media and search.

-- Which campaign has the most orders?
SELECT  campaign_name,
		category,
        SUM(orders) AS total_orders
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY SUM(orders)  DESC;
-- Insight: youtube_blogger has the most orders followed by banner_partner and instagram_blogger.

-- Which category generates the most revenue?
SELECT  category,
        SUM(revenue) AS total_revenue
FROM marketing_dataset_clean
GROUP BY category
ORDER BY SUM(revenue)  DESC;
-- Insight: Influencer generates highest revenue, followed by social, media and search.

-- Which campaign generates the most revenue?
SELECT  campaign_name,
		category,
        SUM(revenue) AS total_revenue
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY SUM(revenue)  DESC;
-- Insight: youtube_blogger generate revenue the most followed by banner_partner and instagram_blogger.

-- Which category spend the most?
SELECT  category,
        SUM(mark_spent) AS total_spent
FROM marketing_dataset_clean
GROUP BY category
ORDER BY SUM(mark_spent)  DESC;
-- Insight: Social spent the most, followed by influencer, media and search.

-- Which campaign spends the most?
SELECT  campaign_name,
		category,
        SUM(mark_spent) AS total_spent
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY SUM(mark_spent)  DESC;
-- Insight: banner_partner spent the most followed by facebOOK_tier2, and instagram_blogger.

-- Funnel — efficiency at each stage

-- Which category has the best CTR? (clicks / impressions)
SELECT category,
        SUM(clicks) AS total_clicks,
        SUM(impressions) AS total_impressions,
        ROUND((SUM(clicks)*100)/NULLIF(SUM(impressions),'0'),2) AS  ctr
FROM marketing_dataset_clean
GROUP BY category
ORDER BY ROUND((SUM(clicks)*100)/NULLIF(SUM(impressions),'0'),2) DESC;
-- Insight: Influencer has the most CTR, followed by search, social and media.

-- Which campaign has the best CTR? (clicks / impressions)
SELECT campaign_name,
		category,
        SUM(clicks) AS total_clicks,
        SUM(impressions) AS total_impressions,
        ROUND((SUM(clicks)*100)/NULLIF(SUM(impressions),'0'),2) AS  ctr
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY ROUND((SUM(clicks)*100)/NULLIF(SUM(impressions),'0'),2) DESC;
-- Insight: facebook_retargeting has the most CTR, followed by google_hot, and youtube_blogger

-- Which campaign has the best click-to-lead rate? (leads / clicks)
SELECT category,
        SUM(leads) AS total_leads,
        SUM(clicks) AS total_clicks,
        ROUND((SUM(leads)*100)/NULLIF(SUM(clicks),'0'),2) AS  click_to_lead
FROM marketing_dataset_clean
GROUP BY category
ORDER BY ROUND((SUM(leads)*100)/NULLIF(SUM(clicks),'0'),2) DESC;
-- Insight: Media has the most clcik to lead rate followed by influencer, search and social.

-- Which campaign has the best click-to-lead rate? (leads / clicks)
SELECT campaign_name,
		category,
        SUM(leads) AS total_leads,
        SUM(clicks) AS total_clicks,
        ROUND((SUM(leads)*100)/NULLIF(SUM(clicks),'0'),2) AS  click_to_lead
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY ROUND((SUM(leads)*100)/NULLIF(SUM(clicks),'0'),2) DESC;
-- Insight: facebOOK_tier2 has the most clcik to lead rate followed by instagram_tier1, banner_partner

-- Which category has the best lead-to-order rate? (orders / leads)
SELECT category,
        SUM(orders) AS total_orders,
        SUM(leads) AS total_leads,
        ROUND((SUM(orders)*100)/NULLIF(SUM(leads),'0'),2) AS lead_to_order
FROM marketing_dataset_clean
GROUP BY category
ORDER BY ROUND((SUM(orders)*100)/NULLIF(SUM(leads),'0'),2) DESC;
-- Insight: Influencer has the highest lead to order rate followed by media, search and social.

-- Which campaign has the best lead-to-order rate? (orders / leads)
SELECT campaign_name,
		category,
        SUM(orders) AS total_orders,
        SUM(leads) AS total_leads,
        ROUND((SUM(orders)*100)/NULLIF(SUM(leads),'0'),2) AS lead_to_order
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY ROUND((SUM(orders)*100)/NULLIF(SUM(leads),'0'),2) DESC;
-- Insight: facebook_retargeting has the highest lead to order rate followed by youtube_bloger and instagram_blogger

-- Which category has the best overall conversion? (orders / impressions)
SELECT category,
        SUM(impressions) AS total_impressions,
        SUM(orders) AS total_orders,
        ROUND((SUM(orders)*100)/NULLIF(SUM(impressions),'0'),5) AS overall_conversion
FROM marketing_dataset_clean
GROUP BY category
ORDER BY ROUND((SUM(orders)*100)/NULLIF(SUM(impressions),'0'),5) DESC;
-- Insight: Influencer has the highest overall conversion rate followed by search, and social and media.

-- Which campaign has the best overall conversion? (orders / impressions)
SELECT campaign_name,
		category,
        SUM(impressions) AS total_impressions,
        SUM(orders) AS total_orders,
        ROUND((SUM(orders)*100)/NULLIF(SUM(impressions),'0'),5) AS overall_conversion
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY ROUND((SUM(orders)*100)/NULLIF(SUM(impressions),'0'),5) DESC;
-- Insight: facebook_retargeting has the highest overall conversion rate followed by google_hot, and youtube_blogger.

-- Return on investment
-- Which category has the best ROAS? (revenue / spend)
SELECT category,
        SUM(revenue) AS total_revenue,
        SUM(mark_spent) AS total_spent,
        ROUND(SUM(revenue)/NULLIF(SUM(mark_spent),'0'),2) AS ROAS
FROM marketing_dataset_clean
GROUP BY category
ORDER BY ROUND(SUM(revenue)/NULLIF(SUM(mark_spent),'0'),2) DESC;
-- Insight: Influencer has the highest ROAS followed by media, search and social.

-- Which campaign has the best ROAS? (revenue / spend)
SELECT campaign_name,
		category,
        SUM(revenue) AS total_revenue,
        SUM(mark_spent) AS total_spent,
        ROUND(SUM(revenue)/NULLIF(SUM(mark_spent),'0'),2) AS ROAS
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY ROUND(SUM(revenue)/NULLIF(SUM(mark_spent),'0'),2) DESC;
-- Insight: youtube_blogger has the highest ROAS followed by facebook_retargeting and google_hot.

-- Which category has the lowest cost per order? (spend / orders)
SELECT category,
        SUM(mark_spent) AS total_spent,
        SUM(orders) AS total_orders,
        ROUND(SUM(mark_spent)/NULLIF(SUM(orders),'0'),2) AS cost_per_order
FROM marketing_dataset_clean
GROUP BY category
ORDER BY  ROUND(SUM(mark_spent)/NULLIF(SUM(orders),'0'),2) ASC;
-- Insight: Influencer has the lowest cost per order, followed by media, search and social.


-- Which campaign has the lowest cost per order? (spend / orders)
SELECT campaign_name,
		category,
        SUM(mark_spent) AS total_spent,
        SUM(orders) AS total_orders,
        ROUND(SUM(mark_spent)/NULLIF(SUM(orders),'0'),2) AS cost_per_order
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY  ROUND(SUM(mark_spent)/NULLIF(SUM(orders),'0'),2) ASC;
-- Insight: youtube_blogger has the lowest cost per order, followed by facebook_retargeting and banner_partner.

-- Part 4: Data Analysis
-- How they allocate the cost for marketing in each platform?
WITH category_spent AS (
		SELECT 
				category,
                SUM(mark_spent) AS category_spent
        FROM marketing_dataset_clean
        GROUP BY category
        )
        
SELECT category,
		category_spent,
		SUM(category_spent) OVER () AS total_spent,
        ROUND(((category_spent*100)/NULLIF(SUM(category_spent) OVER (),0)),2) AS perc_category_spent
FROM category_spent
ORDER BY ROUND(((category_spent*100)/NULLIF(SUM(category_spent) OVER (),0)),2) DESC;

-- Insight: Social receives the largest budget share (45.1%) but delivers the worst ROAS at 0.86x — meaning it loses money on every dollar spent. 
-- Influencer receives 27.2% of budget but delivers a 2.54x ROAS and the lowest cost per order ($2,756). 
-- This suggests the current budget allocation may not be optimised for returns.

-- Which channel delivers the best return? (ROAS + cost per order side by side — one summary query)
SELECT category,
		SUM(revenue) AS total_revenue,
        SUM(mark_spent) AS total_spend,
        SUM(orders) AS total_orders,
        ROUND(SUM(revenue)/NULLIF(SUM(mark_spent),0),2) AS ROAS,
        ROUND(SUM(mark_spent)/NULLIF(SUM(orders),0),2) AS cost_per_order
FROM marketing_dataset_clean
GROUP BY category
ORDER BY SUM(revenue)/NULLIF(SUM(mark_spent),0) DESC;
-- Insight: Influencer delivers a 2.54x ROAS — more than double search (1.07x) and media (1.22x), 
-- and nearly 3x better than social (0.86x) which is the only channel actively losing money. 
-- Influencer also has the lowest cost per order at $2,756, compared to social's $5,237 
-- — meaning social costs nearly twice as much to acquire each customer.".

-- Where does the funnel break down by channel? (Which stage loses the most users?)
SELECT category,
		SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks,
        100 - ROUND((SUM(clicks)*100)/NULLIF(SUM(impressions),0),2) AS impression_dropout,
        SUM(leads) AS total_leads,
        100 - ROUND((SUM(leads)*100)/NULLIF(SUM(clicks),0),2) AS click_dropout,
        SUM(orders) AS total_orders,
        100 - ROUND((SUM(orders)*100)/NULLIF(SUM(leads),0),2) AS lead_dropout,
        100 - ROUND((SUM(orders)*100)/NULLIF(SUM(impressions),0),5) AS overall_dropout
FROM marketing_dataset_clean
GROUP BY category
ORDER BY 100-ROUND((SUM(orders)*100)/NULLIF(SUM(impressions),0),5) DESC;
-- Insight: Every channel loses 99%+ of users at the impression-to-click stage — this is normal for digital marketing. 
-- The critical difference is at the lead-to-order stage: social loses 91.6% of leads before converting to an order, 
-- nearly 10 percentage points worse than influencer (82.2%). Social's problem is not awareness — it generates the most leads 
-- but it fails to convert them into buyers.

-- Is the budget allocation justified by performance? (The "so what" question — compare spend % vs revenue %)
WITH category_overview AS (
		SELECT 
				category,
                SUM(mark_spent) AS category_spent,
                SUM(revenue) AS category_revenue
        FROM marketing_dataset_clean
        GROUP BY category
        )
        
SELECT category,
		category_spent,
		SUM(category_spent) OVER () AS total_spent,
        ROUND(((category_spent*100)/NULLIF(SUM(category_spent) OVER (),0)),2) AS perc_category_spent,
        category_revenue,
        SUM(category_revenue) OVER () AS total_revenue,
        ROUND(((category_revenue*100)/NULLIF(SUM(category_revenue) OVER (),0)),2) AS perc_category_revenue
FROM category_overview
ORDER BY ROUND(((category_revenue*100)/NULLIF(SUM(category_revenue) OVER (),0)),2) DESC;
-- Insight: The budget allocation is not justified by performance. Social receives 45.1% of total spend but generates only 27.8% of revenue — a 17.3 percentage point gap indicating significant overspending. 
-- Influencer receives just 27.2% of budget but delivers 49.2% of total revenue — a 22.1 point gap showing it is heavily underinvested. Reallocating budget from social toward influencer represents the single highest-impact action available to this marketing team.

 -- Which single campaign should get more budget, and why?
 SELECT campaign_name,
		category,
        SUM(revenue) AS total_revenue,
        SUM(mark_spent) AS total_spent,
        ROUND((SUM(revenue))/NULLIF(SUM(mark_spent),0),2) AS ROAS,
        SUM(orders) AS total_orders,
        ROUND(SUM(mark_spent)/NULLIF(SUM(orders),0),2) AS cost_per_order,
        SUM(impressions) AS total_impression,
        ROUND((SUM(orders)*100)/NULLIF(SUM(impressions),0),5) AS overall_conversion
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY ROAS DESC, cost_per_order DESC, overall_conversion DESC;

WITH campaign_overview AS (
		SELECT 
				campaign_name,
                category,
                SUM(mark_spent) AS campaign_spent,
                SUM(revenue) AS campaign_revenue
        FROM marketing_dataset_clean
        GROUP BY campaign_name, category
        )
        
SELECT  campaign_name,
		category,
		campaign_spent,
		SUM(campaign_spent) OVER () AS total_spent,
        ROUND(((campaign_spent*100)/NULLIF(SUM(campaign_spent) OVER (),0)),2) AS perc_campaign_spent,
        campaign_revenue,
        SUM(campaign_revenue) OVER () AS total_revenue,
        ROUND(((campaign_revenue*100)/NULLIF(SUM(campaign_revenue) OVER (),0)),2) AS perc_campaign_revenue
FROM campaign_overview
ORDER BY ROUND(((campaign_revenue*100)/NULLIF(SUM(campaign_revenue) OVER (),0)),2) DESC;

-- Insight: youtube_blogger is the single most underinvested campaign in the portfolio. It receives only 13.27% of total budget but generates 35.70% of total revenue — a +22.4 percentage point gap, the largest of any campaign. 
-- Its ROAS of 3.77x is 3x higher than banner_partner (1.22x), yet banner receives 16.43% of budget — more than youtube. Meanwhile facebook_lal is the most overspent campaign: it consumes 8.64% of budget but generates only 0.70% of revenue with a 0.11x ROAS — meaning it loses 89 cents on every dollar spent. The recommendation is clear: reallocate budget from facebook_lal and facebOOK_tier2 toward youtube_blogger and facebook_retargeting.

-- What is the overall return on marketing investment across the entire campaign period? (ROMI)
SELECT SUM(revenue) AS total_revenue,
		SUM(mark_spent) AS total_spend,
        SUM(revenue)-SUM(mark_spent) AS net_profit,
        ROUND(((SUM(revenue)-SUM(mark_spent))*100)/NULLIF(SUM(mark_spent),0),2) AS ROMI
FROM marketing_dataset_clean;
-- Insight: The overall campaign generated a 40.20% ROMI, producing $12.3M net profit on $30.6M in spend. 
-- However, this masks significant variation between campaigns — some are highly profitable while others actively destroy value.

-- Which campaigns generated a positive ROMI and which ones destroyed value? Rank all campaigns from highest to lowest ROMI.
SELECT 	campaign_name,
		category,
		SUM(revenue) AS total_revenue,
		SUM(mark_spent) AS total_spend,
        ROUND(((SUM(revenue)-SUM(mark_spent))*100)/NULLIF(SUM(mark_spent),0),2) AS ROMI
FROM marketing_dataset_clean
GROUP BY campaign_name, category
ORDER BY ROMI DESC;
-- Insight: 6 out of 11 campaigns generated positive ROMI, but the distribution is extreme. 
-- youtube_blogger leads at 277.32% ROMI while facebook_lal destroys 88.64% of every dollar invested. 
-- The 5 negative-ROMI campaigns collectively consumed significant budget that could have been reallocated to proven performers.

ALTER TABLE marketing_dataset_clean 
MODIFY COLUMN impressions BIGINT;
-- On which date did we spend the most on advertising?
-- On which date did we generate the highest revenue? 
-- When were overall conversion rates at their highest and lowest?
-- What was the average order value per day? 
SELECT c_date,
		SUM(mark_spent) AS total_spend,
        SUM(revenue) AS total_revenue,
        SUM(orders) AS total_orders,
        SUM(impressions) AS total_impressions,
        SUM(orders)*100/NULLIF(SUM(impressions),0) AS overall_conversion,
        ROUND(SUM(revenue)/NULLIF(SUM(orders),0),2) AS avg_order_value
FROM marketing_dataset_clean
GROUP BY c_date
ORDER BY total_revenue DESC;

-- Insight: Feb 20 was both the highest spend day ($3.5M) and highest revenue day ($5.3M), suggesting a strong positive relationship between spend and returns on that date. 
-- Feb 26 recorded the highest average order value at $6,283 per order. Conversion rates were highest around mid-February (~0.0014%), with Feb 13, Feb 15, and Feb 24 virtually tied at the top — too close to distinguish meaningfully. 
-- The lowest conversion was Feb 18 (0.00011%), though this is likely skewed by an anomalous impression spike. Excluding that anomaly, Feb 02 recorded the lowest reliable conversion at 0.00012% — a 13x gap versus the peak days.

-- Are buyers more active on weekdays or weekends? Compare average revenue, average orders, and average order value between weekdays and weekends.
SELECT
	CASE 
		WHEN DAYNAME(c_date) = 'Saturday' THEN 'weekend'
		WHEN DAYNAME(c_date) = 'Sunday' THEN 'weekend'
		ELSE 'weekday'
	END AS day_type,
    ROUND(AVG(revenue),2) AS avg_revenue,
	ROUND(AVG(orders),2) AS avg_orders,
    ROUND(SUM(revenue)/NULLIF(SUM(orders),0),2) AS avg_order_value
FROM marketing_dataset_clean
GROUP BY day_type;

SELECT DAYNAME(c_date) AS day,
		AVG(revenue) AS avg_revenue,
        AVG(orders) AS avg_orders,
        SUM(revenue)/NULLIF(SUM(orders),0) AS avg_order_value
FROM marketing_dataset_clean
GROUP BY DAYNAME(c_date)
ORDER BY avg_revenue DESC;

-- Insight: Weekdays outperform weekends across all metrics — generating 7% higher average daily revenue ($141,914 vs $132,594) and 6% higher AOV ($5,418 vs $5,118). 
-- Friday is the standout performer with the highest average daily revenue ($217,595) and most orders (38 avg), driven by end-of-week buying behaviour. 
-- Interestingly, Monday records the second highest AOV at $5,464 despite ranking 6th in volume — suggesting Monday buyers make fewer but higher-value purchases. 
-- Sunday is the weakest day across all metrics.

-- Based on campaign naming conventions, which geo tier performs better — tier 1 or tier 2 cities? Compare ROMI, ROAS, conversion rate, and cost per order between tiers. Note: since there is no explicit geo column in the dataset, infer tier from campaign names.
WITH geo_marketing_data AS (
	SELECT *
    FROM marketing_dataset_clean
    WHERE campaign_name LIKE '%tier%'
    )
    
SELECT
		CASE
			WHEN campaign_name LIKE '%tier1' THEN 'tier 1'
            ELSE 'tier 2'
            END AS tier_type,
		SUM(revenue) AS total_revenue,
        SUM(mark_spent) AS total_spent,
        ROUND((SUM(revenue))/NULLIF(SUM(mark_spent),0),2) AS ROAS,
        ROUND(((SUM(revenue)-SUM(mark_spent))*100)/NULLIF(SUM(mark_spent),0),2) AS ROMI,
        SUM(impressions) AS total_impressions,
        SUM(orders) AS total_orders,
        ROUND((SUM(orders)*100)/NULLIF(SUM(impressions),0),2) AS overall_conversion,
        ROUND(SUM(revenue)/NULLIF(SUM(orders),0),2) AS avg_order_value,
        ROUND(SUM(mark_spent)/NULLIF(SUM(orders),0), 2) AS cost_per_order
FROM geo_marketing_data
GROUP BY tier_type;

-- Insight: Tier 1 cities outperform tier 2 across every metric. Tier 1 delivers a 1.35x ROAS and +35.29% ROMI while tier 2 generates only 0.72x ROAS and a -28.23% ROMI — meaning tier 2 campaigns lose 28 cents on every dollar spent. 
-- Tier 1 also converts nearly twice as well (0.00089% vs 0.00048%) and costs $1,590 less per order. The recommendation is clear: reallocate tier 2 budget toward tier 1 targeting, or investigate why tier 2 audiences are not converting despite significant spend.
-- Note: Geo tier inferred from campaign names.
-- Only 4 campaigns included (Facebook + Instagram tiers).
-- Other channels (YouTube, Google, Banner) have no tier designation
-- so this analysis reflects social channel geo performance only
        
            