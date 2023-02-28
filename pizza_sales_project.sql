USE pizza_sales;

-- How Many customers do we have each day? 

SELECT 
    date, 
    COUNT(*) AS number_of_customers
FROM
    orders         
GROUP BY 1         -- grouping the dates and finding the corresponding counts of orders for each date
ORDER BY 2 DESC;

-- Are there any peak hours? 

SELECT 
    HOUR(time) AS hour, -- using hour function to extract the hour from time column
    COUNT(*) AS number_of_customers  -- trying to find the total count of the orders
FROM
    orders
GROUP BY 1                         
ORDER BY 2 DESC;   /*sorting by number_of_customers to determine the hour 
                    with the most customers*/

-- How many pizzas are in an order? 

SELECT 
    order_id, 
    sum(quantity) AS number_of_pizzas
FROM
    order_details
GROUP BY 1
ORDER BY 2 DESC;

-- Do we have best selling pizza types?

SELECT 
    pt.name AS pizza_type, SUM(od.quantity) AS sold_quantity
FROM
    pizza_types pt
        JOIN
    pizzas P ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 2 DESC;

-- Money made this year (2015)

SELECT 
    ROUND(
    SUM(p.price * od.quantity),
    2) AS Revenue -- Rounding the sum of product of prices and sold quantity to two decimal places
FROM
    pizzas p
JOIN order_details od
ON p.pizza_id = od.pizza_id;

    
    -- Are there seasonality in sales?
    -- Sales Differentials Per Quarter
    SELECT 
    QUARTER(o.date) AS quarter,
    ROUND(SUM(p.price * od.quantity), 2) AS Revenue
FROM
    orders o
        JOIN
    order_details od ON o.order_id = od.order_id
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
GROUP BY 1;

-- Sales Differentials Per Month
    SELECT 
    MONTH(o.date) AS month_num,
    ROUND(SUM(p.price * od.quantity), 2) AS Revenue
FROM
    orders o
        JOIN
    order_details od ON o.order_id = od.order_id
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 1;

/* Are there Pizza types that the restaurant should take off the menu? Are there advertisement
campaigns that the restaurant can leverage on? */

use pizza_sales;

WITH CTE AS (
SELECT
      p.pizza_id,
      pt.name,
      p.price,
      od.quantity
FROM pizza_types Pt
JOIN pizzas p
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details od
ON p.pizza_id = od.pizza_id
)
SELECT
      pizza_id,
      price*quantity AS total_sales
FROM CTE
GROUP BY 1
ORDER BY 2 DESC;




