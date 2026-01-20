/* ============================================================
   SQL INTERMEDIATE – JOINS (INNER, LEFT)
   Dataset: Chinook Database
   ============================================================ */

---------------------------------------------------------------
-- 1. INNER JOIN: Orders with Customer Details
---------------------------------------------------------------
SELECT
    i.InvoiceId,
    i.InvoiceDate,
    c.CustomerId,
    c.FirstName || ' ' || c.LastName AS customer_name,
    c.Country,
    i.Total
FROM Invoice i
INNER JOIN Customer c
    ON i.CustomerId = c.CustomerId;

---------------------------------------------------------------
-- 2. LEFT JOIN: Customers Who Never Placed Any Orders
---------------------------------------------------------------
SELECT
    c.CustomerId,
    c.FirstName,
    c.LastName,
    c.Email
FROM Customer c
LEFT JOIN Invoice i
    ON c.CustomerId = i.CustomerId
WHERE i.InvoiceId IS NULL;

---------------------------------------------------------------
-- 3. Revenue per Product (Track)
---------------------------------------------------------------
SELECT
    t.TrackId,
    t.Name AS product_name,
    SUM(il.UnitPrice * il.Quantity) AS total_revenue
FROM InvoiceLine il
INNER JOIN Track t
    ON il.TrackId = t.TrackId
GROUP BY t.TrackId, t.Name
ORDER BY total_revenue DESC;

---------------------------------------------------------------
-- 4. Category-wise Revenue (Genre)
---------------------------------------------------------------
SELECT
    g.Name AS category,
    SUM(il.UnitPrice * il.Quantity) AS category_revenue
FROM InvoiceLine il
INNER JOIN Track t
    ON il.TrackId = t.TrackId
INNER JOIN Genre g
    ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY category_revenue DESC;

---------------------------------------------------------------
-- 5. Business Question:
-- Sales in USA between 2012-01-01 and 2013-12-31
---------------------------------------------------------------
SELECT
    c.Country,
    SUM(i.Total) AS total_sales
FROM Invoice i
INNER JOIN Customer c
    ON i.CustomerId = c.CustomerId
WHERE c.Country = 'USA'
  AND i.InvoiceDate BETWEEN '2012-01-01' AND '2013-12-31'
GROUP BY c.Country;

---------------------------------------------------------------
-- 6. Export-ready Joined Dataset (for CSV)
---------------------------------------------------------------
SELECT
    i.InvoiceId,
    i.InvoiceDate,
    c.FirstName || ' ' || c.LastName AS customer_name,
    c.Country,
    t.Name AS product_name,
    g.Name AS category,
    il.Quantity,
    il.UnitPrice,
    (il.Quantity * il.UnitPrice) AS line_total
FROM Invoice i
INNER JOIN Customer c ON i.CustomerId = c.CustomerId
INNER JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
INNER JOIN Track t ON il.TrackId = t.TrackId
INNER JOIN Genre g ON t.GenreId = g.GenreId;
