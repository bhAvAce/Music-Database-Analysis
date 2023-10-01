/* Q1: Who is the senior most employee based on job title? */

SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1

/* Q2: Which country have the most invoices? */

SELECT COUNT(*) AS c, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY c DESC

/* Q3: What are the top three values of total invoice */

SELECT * FROM invoice
ORDER BY total DESC
LIMIT 3

/* Q4: Which city has best customers? We would like to throw a promotional music festival in city
we made the the most money. Write query that returns one city that has higest sum of invoice totals.
Return both city name & sum of all invoice totals. */

SELECT SUM(total) AS invoice_total, billing_city FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
LIMIT 1

/* Q5: Who is the best customer? The customer who has spent most money will be declared the best customer.
Write a query that returns the person who has spent most money. */

SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS TOTAL
FROM  customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC
LIMIT 1

/* Q6: Write query to return the email, first name & last name of all Rock Music listners,
Return your list ordered alphabetically by email starting with A. */

SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

/* Q7: Let's invite the artist who have written the most Rock Music in our dataset.
Write a query that returns the artist name and total track count of the top 10 rock bands. */

SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_song
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_song DESC
LIMIT 10;


/* Q8: Return all the track names that have a song length longer than average song length.
Return the name and millisecond for each track. Order by the song length with longest song listed first. */

SELECT name, milliseconds
FROM track
WHERE milliseconds >(
	SELECT AVG(milliseconds) AS avg_track_length FROM track
)
ORDER BY milliseconds DESC


/* Q9: Find how much amount spent by each customer on artists? Write query to return customer name,
artist name and total spent. */

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name,
	SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invOice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC 
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.invoice_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;


/* Q10: We want to find out the most popular music genre for each country.
(we determine the most popular genre with the highest amount amount of purchases) */

WITH popular_genre AS
(
	SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNO
	FROM invoice_line
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 3 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1 ;
