-- SPOTIFY DATA ANALYSIS PROJECT

CREATE TABLE IF NOT EXISTS spotify (
    artist VARCHAR(250),
    track VARCHAR(250),
    album VARCHAR(250),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(250),
    channel VARCHAR(250),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- Exploratory Data Analysis

SELECT COUNT(*) FROM spotify 

SELECT DISTINCT artist FROM spotify

SELECT DISTINCT likes,track, artist FROM spotify
ORDER BY likes DESC
LIMIT 25;

SELECT COUNT(DISTINCT album) FROM spotify

SELECT album_type, COUNT(*) AS genre_count
FROM spotify
GROUP BY album_type
ORDER BY genre_count DESC
LIMIT 10;

SELECT track, artist, stream
FROM spotify
ORDER BY stream DESC
LIMIT 10;

SELECT stream AS popularity, AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY stream
ORDER BY stream DESC
LIMIT 20;

SELECT
  ROUND(AVG(danceability)::numeric, 2) AS avg_danceability,
  ROUND(AVG(energy)::numeric, 2) AS avg_energy,
  ROUND(AVG(acousticness)::numeric, 2) AS avg_acousticness,
  ROUND(AVG(instrumentalness)::numeric, 2) AS avg_instrumentalness,
  ROUND(AVG(valence)::numeric, 2) AS avg_valence
FROM spotify;

SELECT
  CASE
    WHEN tempo < 60 THEN 'Slow (<60 BPM)'
    WHEN tempo BETWEEN 60 AND 90 THEN 'Moderate (60-90 BPM)'
    WHEN tempo BETWEEN 91 AND 120 THEN 'Upbeat (91-120 BPM)'
    WHEN tempo BETWEEN 121 AND 150 THEN 'Fast (121-150 BPM)'
    ELSE 'Very Fast (>150 BPM)'
  END AS tempo_range,
  COUNT(*) AS track_count
FROM spotify
GROUP BY tempo_range
ORDER BY track_count DESC;

-- SQL practice problems (easy)

-- 1. Retrieve the names of all tracks that have more than 1 billion streams
SELECT DISTINCT track, stream FROM spotify
WHERE stream > 1000000000
ORDER BY stream DESC;

-- 2. List all albums along with their respective artists
SELECT artist, album FROM spotify
WHERE album_type = 'album';

-- 3. Get the total number of comments for tracks where licensed = TRUE
SELECT COUNT(comments) FROM spotify
WHERE licensed = TRUE;

--4. Find all tracks that belong to the album type single
SELECT track, album_type FROM spotify
WHERE album_type = 'single';

--5. Count the total number of tracks by each artist.
SELECT artist, COUNT(track) AS total_tracks FROM spotify
GROUP BY artist
ORDER BY total_tracks;

--6. What are the average audio characteristics of viral tracks (Views > 100M)?
SELECT
  ROUND(AVG(Danceability)::numeric, 2) AS avg_danceability,
  ROUND(AVG(Energy)::numeric, 2) AS avg_energy,
  ROUND(AVG(Valence)::numeric, 2) AS avg_valence,
  ROUND(AVG(Speechiness)::numeric, 2) AS avg_speechiness
FROM spotify
WHERE Views > 100000000;

--7. What’s the engagement rate of the most streamed tracks?
SELECT Track, Artist,ROUND(((Likes::numeric / Views) * 100)::numeric, 2) AS like_rate_pct,ROUND(((Comments::numeric / Views) * 100)::numeric, 3) AS comment_rate_pct
FROM spotify
WHERE views > 1000000000
ORDER BY like_rate_pct DESC
LIMIT 25;

--8. Which artists have the highest total views across all their tracks?
SELECT artist,SUM(views) AS total_views,COUNT(*) AS num_tracks
FROM spotify
GROUP BY Artist
ORDER BY total_views DESC;

--9. Which music channel has published the most content?
SELECT channel, COUNT(*) AS total_tracks
FROM spotify
GROUP BY channel
ORDER BY total_tracks DESC;

--10. Compare the popularity of licensed vs non-licensed tracks
SELECT licensed,ROUND(AVG(Views)::numeric, 0) AS avg_views,ROUND(AVG(Stream)::numeric, 0) AS avg_streams
FROM spotify
GROUP BY licensed;

-- SQL practice problems (medium)

--1. Calculate the average danceability of tracks in each album
SELECT ROUND(AVG(danceability):: numeric, 2) AS avg_danceability, album FROM spotify
GROUP BY album;

--2. Find the top 10 tracks with the highest energy values
SELECT DISTINCT track, energy FROM spotify
ORDER BY energy DESC
LIMIT 10;

--3. List all tracks along with their views and likes where official_video = TRUE
SELECT DISTINCT track, SUM(views), SUM(likes) FROM spotify
WHERE official_video = TRUE
GROUP BY track
ORDER BY SUM(views) DESC;

--4. For each album, calculate the total views of all associated tracks
SELECT album,SUM(views) AS total_album_views FROM spotify
GROUP BY album
ORDER BY total_album_views DESC;

--5. Retrieve track names streamed more on Spotify than YouTube
SELECT track, artist, stream, views FROM spotify
WHERE stream > views
ORDER BY Stream - views DESC;

--6. Which artists has the highest average likes per track (min. 5 tracks)?
SELECT artist,ROUND(AVG(likes)::numeric, 0) AS avg_likes,COUNT(*) AS total_tracks
FROM spotify
GROUP BY artist
HAVING COUNT(*) >= 5
ORDER BY avg_likes DESC
LIMIT 10;

--7. Identify tracks where the loudness is above the average loudness of all tracks
SELECT track, artist, loudness FROM spotify
WHERE loudness > (SELECT AVG(loudness) FROM spotify);

--8. Show the top 10 tracks with the highest ratio of likes to views
SELECT track, artist, ROUND((Likes::numeric / Views)::numeric, 3) AS like_to_view_ratio FROM spotify
WHERE views > 0
ORDER BY like_to_view_ratio DESC
LIMIT 10;

-- SQL practice problems (advanced)

--1. Find the top 5 most-viewed tracks for each artist using window functions
WITH my_cte
AS
(
 SELECT artist,track, SUM(views) AS total_view, 
 DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
 FROM spotify
 GROUP BY 1,2 
 ORDER BY 1,3 DESC
)
SELECT * FROM my_cte
WHERE rank <= 3;

--2. Write a query to find tracks where the liveness score is above the average
SELECT track, artist, liveness FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

--3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album
WITH my_cte AS (
    SELECT album, MAX(energy) AS max_energy,MIN(energy) AS min_energy
    FROM spotify
    GROUP BY album
)
SELECT album, 
       max_energy - min_energy AS energy_difference
FROM my_cte
ORDER BY energy_difference DESC;

--4. Use a window function to calculate the running total of views for each track ordered by stream count
SELECT track, artist, stream, 
       SUM(views) OVER (PARTITION BY artist ORDER BY stream DESC) AS running_total_views
FROM spotify
ORDER BY artist, stream DESC;

--5. Write a CTE-based query to identify albums where the total views exceed the average total views of all albums
WITH album_views AS (
    SELECT album,
           SUM(views) AS total_views
    FROM spotify
    GROUP BY album
),
average_album_views AS (
    SELECT AVG(total_views) AS avg_views
    FROM album_views
)
SELECT a.album, a.total_views
FROM album_views a, average_album_views av
WHERE a.total_views > av.avg_views
ORDER BY a.total_views DESC;







