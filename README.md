
# OLA Booking Dataset Analysis

This project involves the analysis of OLA booking data using SQL. The dataset contains ride-level details and includes information about booking status, customer behavior, ride details, cancellations, and ratings.

## 🗂️ Dataset Description

| Column Name                  | Description |
|-----------------------------|-------------|
| `date`                      | Date of the booking |
| `time`                      | Time of the booking |
| `booking_id`                | Unique identifier for each booking |
| `booking_status`            | Status of the booking (e.g., completed, cancelled) |
| `customer_id`               | Unique ID of the customer |
| `vehicle_type`              | Type of vehicle booked (e.g., Mini, Sedan) |
| `pickup_location`           | Starting location of the ride |
| `drop_location`             | Ending location of the ride |
| `v_tat`                     | Vehicle Turnaround Time |
| `c_tat`                     | Customer Turnaround Time |
| `canceled_rides_by_customer`| Indicator if ride was cancelled by customer |
| `canceled_rides_by_driver`  | Indicator if ride was cancelled by driver |
| `incomplete_rides`          | Whether the ride was completed or not |
| `incomplete_rides_reason`   | Reason for incomplete ride if any |
| `booking_value`             | Cost of the ride |
| `payment_method`            | Method of payment used |
| `ride_distance`             | Distance traveled during the ride |
| `driver_ratings`            | Ratings given to the driver |
| `customer_rating`           | Ratings given to the customer |
| `vehicle_images`            | Path to the image of vehicle |

## 🛠️ SQL Tasks Included

- Creating database 
- Importing CSV data into MySQL
- Total completed rides and cancelled rides
- Cancellations by driver vs customer
- Ride distance and booking value insights
- Ratings analysis
- Payment preferences by pickup location
- Booking trends over time

## ✅ Query Validation

The queries in this project were reviewed and corrected for:
- NULL value handling
- Correct column data types (e.g., integers, decimals)
- Proper logical conditions using `IS NOT NULL` and `<> 'null'` where applicable

## ⚠️ Notes

- Ensure `local_infile` is enabled in your MySQL server (`SET GLOBAL local_infile = 1;`).
- Data must be in `.csv` format for successful import.
- Avoid using Excel (`.xlsx`) files directly in `LOAD DATA INFILE`.

## 📥 How to Import the Data in MySQL

1.  Convert the `.xlsx` file to `.csv`. (If necessary)
2.  Move the file to: Correct Directory
3. Create a empty table with all the column names.
4.  Run the following query in your MySQL client:
    ```sql
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
    ```
    **Note:** Ensure that the path to your CSV file is correct and that you have the necessary permissions to load data into the MySQL server.


## 📁 File Structure

- `OLA_Booking_Dataset.csv`: Dataset
- `OlA-Booking-Analysis-queries.sql`: Contains all SQL queries for analysis.


## 📊 Tools Used

- MySQL 8.0
- SQL Workbench / Command Line
- OLA Booking CSV dataset

## 🚀 How to Run

1. Open MySQL.
2. Run the script from `OlA-Booking-Analysis-queries.sql`.
3. Perform analysis using SELECT queries.

## 📬 Contributions

Feel free to fork this repo, suggest improvements, or use these queries for your own dataset analysis projects!

