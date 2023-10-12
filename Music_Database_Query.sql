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


