-- Welcome to my analysis of Amazon Delivery Dataset. I aim to uncover insights that can help improve delivery efficiency and improve customer 
-- experience. I analyzed data of over 43,739 deliveries and I was able to identify key factors influencing delivery time,agent performance,weather
--and traffic conditions including the mode of transportation used.
SELECT * FROM amazon_delivery;

-- What is the Average Delivery Time for each weather? and What is the total deliveries made in each weather?
SELECT weather,
COUNT(*) AS total_deliveries,
AVG(Delivery_Time) AS AvgDeliveryTime
FROM amazon_delivery GROUP BY weather;

-- What was the traffic condition like during deliveries and the Average Delivery Time for each traffic condition?
SELECT Traffic,
COUNT(*) AS total_deliveries,
AVG(Delivery_Time) AS AvgDeliveryTime
FROM amazon_delivery GROUP BY Traffic;

-- What is the mode of transportation used the most? and the average delivery time for each mode of transport.
SELECT Vehicle,
COUNT(*) AS total_deliveries,
AVG(Delivery_Time) AS AvgDeliveryTime
FROM amazon_delivery GROUP BY Vehicle;
 
-- What area has the highest orders? and the average delivery time to such areas.
SELECT Area,
COUNT(*) AS total_deliveries,
AVG(Delivery_Time) AS AvgDeliveryTime
FROM amazon_delivery GROUP BY Area;

-- What category of products is ordered the most? and the average delivery time for the category of products?
SELECT Category,
COUNT(*) AS total_deliveries,
AVG(Delivery_Time) AS AvgDeliveryTime
FROM amazon_delivery GROUP BY Category;

-- Average Agent Rating by Age and total number of ratings received for each age
SELECT Agent_Age, 
AVG(agent_rating) AS Average_Agent_Rating,
COUNT(*) AS number_of_ratings FROM amazon_delivery GROUP BY agent_age ORDER BY agent_age ASC;

-- Average Delivery Time for each Agent Age
SELECT Agent_Age, 
AVG(Delivery_Time) AS Average_Delivery_Time, 
COUNT(*) AS number_of_ratings FROM amazon_delivery GROUP BY agent_age ORDER BY agent_age ASC;

-- Average Delivery Time and Average Agent Rating
SELECT 
AVG(agent_rating) AS Average_Agent_Rating, avg(delivery_time) as average_delivery_time
--COUNT(*) AS number_of_ratings 
FROM amazon_delivery GROUP BY agent_age ORDER BY agent_age ASC;

-- How often are deliveries made on time?
SELECT 
COUNT(*) AS total_deliveries,
SUM(CASE WHEN delivery_time <= 60 THEN 1 END) AS on_time_deliveries,
SUM(CASE WHEN delivery_time BETWEEN 61 AND 180 THEN 1 END) AS late_deliveries,
SUM(CASE WHEN delivery_time > 180 THEN 1 END) AS very_late_deliveries
FROM amazon_delivery;

-- Distribution of Order by Month
SELECT DATEPART(YEAR, order_date) AS Order_Year, DATEPART(MONTH, order_date) AS Order_Month,
COUNT(*) AS Order_Count
FROM amazon_delivery
GROUP BY DATEPART(YEAR, order_date), DATEPART(MONTH, order_date)
ORDER BY Order_Year, Order_Month;

-- Distribution of Order Date by Day
SELECT DATENAME(WEEKDAY, order_date) AS DayOfWeek, COUNT(*) AS Order_Count
FROM amazon_delivery
GROUP BY DATENAME(WEEKDAY, order_date)
ORDER BY Order_Count DESC;








