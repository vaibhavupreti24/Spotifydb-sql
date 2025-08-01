# Spotifydb-sql
# 🎵 Spotify Data Analysis using SQL

This project dives deep into Spotify’s music dataset using **SQL** to perform **Exploratory Data Analysis (EDA)** and solve a wide range of real-world queries—ranging from identifying top-performing artists to comparing audio features of viral hits.

## 📊 Project Overview

- **Dataset**: Simulated Spotify dataset with artist, track, album, views, streams, audio features (danceability, energy, etc.), and engagement metrics (likes, comments).
- **Goal**: Gain business insights by writing SQL queries at easy, medium, and advanced levels.

---

## 🗃️ Table Schema

```sql
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
