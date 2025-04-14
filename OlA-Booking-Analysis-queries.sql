
-- Creating a Database - 
CREATE DATABASE OLA_Database ; 

USE OLA_Database ;

-- Creating a Table - 
CREATE TABLE ola_bookings (
    date DATE,
    time TIME,
    booking_id INT,
    booking_status VARCHAR(50),
    customer_id VARCHAR(60),
    vehicle_type VARCHAR(50),
    pickup_location VARCHAR(100),
    drop_location VARCHAR(100),
    v_tat INT NULL,
    c_tat INT NULL,
    canceled_rides_by_customer VARCHAR(100),
    canceled_rides_by_driver VARCHAR(100),
    incomplete_rides VARCHAR(50),
    incomplete_rides_reason VARCHAR(255),
    booking_value DECIMAL(10,2),
    payment_method VARCHAR(50),
    ride_distance DECIMAL(10,2),
    driver_ratings DECIMAL(3,2),
    customer_rating DECIMAL(3,2),
    vehicle_images VARCHAR(255)
);


-- Enabling LOAD DATA LOCAL INFILE - 
SET GLOBAL local_infile = 1;

-- Verifying (Enable or not) -
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- Checking the Directory path -
SHOW VARIABLES LIKE 'secure_file_priv';


-- Importing the Data in the 'ola_bookings' table - 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/OLA_Booking_Dataset.csv'
INTO TABLE ola_bookings
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date, time, booking_id, booking_status, customer_id, vehicle_type, pickup_location, drop_location, v_tat, c_tat, 
 canceled_rides_by_customer, canceled_rides_by_driver, incomplete_rides, incomplete_rides_reason, booking_value, 
 payment_method, ride_distance, driver_ratings, customer_rating, vehicle_images);
 
 -- Explanation for each column - 
 
-- Date	The date on which the booking was made.
-- Time	The exact time of the booking.
-- Booking_ID	A unique ID for each ride booking.
-- Booking_Status	The final status of the booking – e.g., Completed, Cancelled, etc.
-- Customer_ID	Unique identifier for each customer.
-- Vehicle_Type	Type of vehicle booked – e.g., Mini, Sedan, SUV, Auto.
-- Pickup_Location	Location where the customer was picked up.
-- Drop_Location	Destination or drop-off location.
-- V_TAT (Vehicle Turnaround Time)	Time the vehicle took to reach the customer after booking.
-- C_TAT (Customer Turnaround Time)	Time the customer took to board the vehicle after it arrived.
-- Canceled_Rides_by_Customer	Indicates if the ride was canceled by the customer (can be count or Yes/No).
-- Canceled_Rides_by_Driver	Indicates if the ride was canceled by the driver.
-- Incomplete_Rides	If a ride started but wasn’t completed (Yes/No).
-- Incomplete_Rides_Reason	Reason for the incomplete ride – e.g., Vehicle issue, Customer No-show, etc.
--  Booking_Value	Amount charged for the ride.
-- Payment_Method	How the customer paid – e.g., Cash, Card, UPI, Ola Money.
-- Ride_Distance	Distance of the ride in kilometers (or miles depending on system).
-- Driver_Ratings	Rating given to the driver by the customer (usually 1 to 5).
-- Customer_Rating	Rating given to the customer by the driver (if applicable).
-- Vehicle Images	Links or indicators showing images of the vehicle (can be for verification).



-- Displaying the Data - 
SELECT *
  FROM
    ola_bookings
LIMIT 50;

-- Basic Level (Foundational Queries)

-- 1.Total Bookings:
-- Determine the total number of bookings in the dataset.

SELECT 
    COUNT(booking_id) AS Total_Bookings
FROM
    ola_bookings;


-- 2.Completed vs. Canceled Rides:
-- Calculate the number of completed rides versus those canceled by customers or drivers.

SELECT 
    SUM(CASE WHEN incomplete_rides = 'No' THEN 1 ELSE 0 END) AS complete_rides,
    SUM(CASE WHEN incomplete_rides = 'Yes' THEN 1 ELSE 0 END) AS total_incomplete_rides,
    SUM(CASE WHEN canceled_rides_by_customer IS NOT NULL AND canceled_rides_by_customer <> 'null' THEN 1 ELSE 0 END) AS total_rides_canceled_by_customer,
    SUM(CASE WHEN canceled_rides_by_driver IS NOT NULL AND canceled_rides_by_driver <> 'null' THEN 1 ELSE 0 END) AS total_rides_canceled_by_driver
FROM 
    ola_bookings;
    
    
-- 3.Average Booking Value: 
-- Compute the average booking value for all rides.

SELECT 
    ROUND(AVG(booking_value), 2) AS avergae_booking_value
FROM
    ola_bookings;

-- 4.Top Pickup Locations:
-- Identify the top 5 pickup locations with the highest number of rides.

SELECT 
    pickup_location
FROM
    ola_bookings
GROUP BY pickup_location
ORDER BY COUNT(pickup_location) DESC
LIMIT 5;

-- 5.Payment Method Distribution:
-- Find the count of bookings for each payment method used.

SELECT 
    payment_method, COUNT(booking_id) AS cnt
FROM
    ola_bookings
WHERE
    payment_method <> 'null'
GROUP BY payment_method;

-- 6.Average Ride Distance by Vehicle Type:
-- Calculate the average ride distance for each vehicle type.

SELECT 
    vehicle_type,
    ROUND(AVG(ride_distance), 2) AS average_ride_distance
FROM
    ola_bookings
GROUP BY vehicle_type
ORDER BY average_ride_distance DESC;

-- 7.Monthly Booking Trends:
-- Analyze the number of bookings per month to identify trends.

SELECT 
    MONTH(date) AS month_, COUNT(*) AS cnt
FROM
    ola_bookings
GROUP BY month_;

-- 8.Driver Rating Statistics:
-- Determine the average, minimum, and maximum driver ratings.

SELECT 
    ROUND(AVG(driver_ratings), 2) AS average_Driver_rating,
    MIN(driver_ratings) AS minimum_driver_rating,
    MAX(driver_ratings) AS maximum_driver_rating
FROM
    ola_bookings;

-- 9.Customer Rating Distribution:
-- Count how many times each customer rating value was given.

SELECT DISTINCT
    customer_rating, COUNT(customer_rating) AS cnt
FROM
    ola_bookings
GROUP BY customer_rating;

-- 10.Incomplete Rides Reasons:
-- List the reasons for incomplete rides along with their respective counts.

SELECT 
    incomplete_rides_reason,
    COUNT(incomplete_rides_reason) AS cnt
FROM
    ola_bookings
WHERE
    incomplete_rides_reason <> 'null'
GROUP BY incomplete_rides_reason
ORDER BY cnt DESC;


-- Intermediate Level (Aggregations & Joins)

-- 11.Customer Cancellation Rate:
-- Calculate the percentage of rides canceled by each customer.

SELECT 
    customer_id, COUNT(canceled_rides_by_customer) AS cnt
FROM
    ola_bookings
WHERE
    canceled_rides_by_customer <> 'null'
GROUP BY customer_id
ORDER BY cnt DESC;

-- 12. Distribution of Ratings (how many 5s, 4s, etc.):

SELECT DISTINCT
    driver_ratings, COUNT(driver_ratings) AS cnt
FROM
    ola_bookings
WHERE
    driver_ratings > 0
GROUP BY driver_ratings
ORDER BY cnt DESC;


-- 13.Revenue by Vehicle Type:
-- Compute total revenue generated for each vehicle type.

SELECT 
    vehicle_type, ROUND(SUM(booking_value), 0) AS revenue
FROM
    ola_bookings
GROUP BY vehicle_type
ORDER BY revenue DESC;

-- 14.Peak Booking Hours:
-- Determine the hours of the day with the highest number of bookings.
SELECT 
    HOUR(time) AS hour_, COUNT(booking_id) AS cnt
FROM
    ola_bookings
GROUP BY hour_
ORDER BY cnt DESC;

-- 15.Top Customers:
-- Find customers who have spent the most on bookings.
SELECT 
    customer_id, ROUND(SUM(booking_value), 0) AS amount_spent
FROM
    ola_bookings
GROUP BY customer_id
ORDER BY amount_spent DESC
LIMIT 10;

-- 16.Ride Distance Distribution:
-- Analyze the distribution of ride distances (e.g., short, medium, long rides).

SELECT CASE WHEN ride_distance>1 AND ride_distance<=200 THEN 'short ride' 
WHEN ride_distance>200 AND ride_distance <=500 THEN 'medium ride'
WHEN ride_distance > 500 THEN 'long ride'
END AS distance_distribution,
COUNT(*) ride_count
FROM ola_bookings
GROUP BY distance_distribution
HAVING distance_distribution IS NOT NULL;

-- 17.Cancellation Impact:
-- Assess how cancellations affect average booking value and ride distance.

SELECT
  CASE 
    WHEN incomplete_rides = 'Yes' THEN 'Canceled'
    ELSE 'Completed'
  END AS ride_status,
  COUNT(*) AS total_rides,
  ROUND(AVG(booking_value), 2) AS avg_booking_value,
  ROUND(AVG(ride_distance), 2) AS avg_ride_distance
FROM ola_bookings
WHERE booking_value IS NOT NULL AND ride_distance IS NOT NULL
GROUP BY ride_status;

--  18.Payment Method Preferences by Location:
-- Identify preferred payment methods in different pickup locations.

SELECT pickup_location , payment_method, COUNT(payment_method) AS cnt , 
ROW_NUMBER() OVER(PARTITION BY pickup_location ORDER BY COUNT(payment_method) DESC) AS r
FROM ola_bookings
WHERE payment_method <> 'null'
GROUP BY pickup_location,payment_method;

-- 19.Incomplete Rides Analysis:
-- Examine patterns or common factors in incomplete rides.

SELECT DISTINCT incomplete_rides_reason , COUNT(incomplete_rides_reason) AS cnt 
FROM ola_bookings 
WHERE incomplete_rides_reason <> 'null' 
GROUP BY incomplete_rides_reason
ORDER BY cnt DESC ;

-- 20.Customer Loyalty:
-- Determine the number of repeat customers and their booking frequency. 
SELECT DISTINCT customer_id , COUNT(*)  AS booking_frequency 
FROM ola_bookings 
GROUP BY customer_id
ORDER BY booking_frequency DESC ;

























