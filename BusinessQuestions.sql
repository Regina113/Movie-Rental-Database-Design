-- Business Questions.
-- 1. Which movies are currently rented and have not yet been returned?
SELECT Movies.Title, Customers.FirstName, Customers.LastName, Rentals.RentalDate, Rentals.DueDate
FROM Rentals JOIN Inventory USING (InventoryID)
			 JOIN Movies USING (MovieID)
             JOIN Customers USING (CustomerID)
WHERE Rentals.Status = 'Rented';

-- 2. Which customers have overdue(late) rentals, and how many days overdue are they?
SELECT Customers.FirstName, Customers.LastName, Rentals.DueDate,
DATEDIFF(CURDATE(), Rentals.DueDate) AS DaysOverdue
FROM Rentals JOIN Customers USING (CustomerID)
WHERE Rentals.Status = 'Late';

-- 3. What is the total revenue collected per month?
SELECT DATE_FORMAT(PaymentDate, '%Y-%m') AS Month, 
SUM(Amount) AS TotalRevenue 
FROM Payments
GROUP BY Month
ORDER BY Month DESC;

-- 4. What are the top 5 most rented movies?
SELECT Movies.Title, COUNT(*) AS RentalCount
FROM Rentals JOIN Inventory USING (InventoryID)
             JOIN Movies USING (MovieID)
GROUP BY Movies.Title
ORDER BY RentalCount DESC
LIMIT 5;

-- 5. Which staff members have processed the most rentals?
SELECT Staff.FullName, COUNT(*) AS RentalsProcessed
FROM Rentals JOIN Staff USING (StaffID)
GROUP BY Staff.FullName
ORDER BY RentalsProcessed DESC;

-- 6. What is the average rating for each movie based on customer feedback?
SELECT Movies.Title, ROUND(AVG(Feedback.Rating), 2) AS AverageRating
FROM Feedback JOIN Movies USING (MovieID)
GROUP BY Movies.Title
ORDER BY AverageRating DESC;

-- 7. Which genres are the most popular based on rental frequency?
SELECT Genres.GenreName, COUNT(*) AS TotalRentals
FROM Rentals JOIN Inventory USING (InventoryID)
             JOIN Movies USING (MovieID)
             JOIN Genres USING (GenreID)
GROUP BY Genres.GenreName
ORDER BY TotalRentals DESC;

-- 8. What is the movie availability at each store location?
SELECT StoreLocation, Movies.Title, Stock
FROM Inventory JOIN Movies USING (MovieID)
ORDER BY StoreLocation, Movies.Title;

-- 9. Which customers are the highest spenders (total payments)?
SELECT Customers.FirstName, Customers.LastName, SUM(Payments.Amount) AS TotalSpent
FROM Payments JOIN Rentals USING (RentalID)
              JOIN Customers USING (CustomerID)
GROUP BY Customers.CustomerID
ORDER BY TotalSpent DESC;

-- 10. Which movies have not been rented at all?
SELECT Movies.Title
FROM Movies LEFT JOIN Inventory ON Movies.MovieID = Inventory.MovieID
LEFT JOIN Rentals ON Inventory.InventoryID = Rentals.InventoryID
WHERE Rentals.RentalID IS NULL;