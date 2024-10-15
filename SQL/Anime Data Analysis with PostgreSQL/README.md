# Anime Data Analysis with PostgreSQL

## Project Overview
This project dives into Anime data using PostgreSQL, exploring various aspects such as genres, ratings, and popularity. The analysis includes creating and manipulating tables, executing complex queries, and utilizing advanced SQL features to gain insights from the data.

## Features
- **CTEs and Window Functions**: Efficiently organize and process data for analysis.
- **JOIN and CASE Statements**: Combine multiple tables and categorize data based on conditions.
- **Complex Data Aggregation and Analysis**: Perform various aggregate functions to derive meaningful insights.

## Database Structure
The project includes two main tables:
- **anime**: Contains details about different anime, including ID, name, genre, type, episodes, rating, and members.
- **rating**: Stores user ratings for anime, where each user can rate multiple anime.

## Queries Implemented
Below is a list of key SQL queries implemented in this project:

1. **Create Tables**: Creation of `anime` and `rating` tables.
2. **Top 20 Highest Ratings**: Query to fetch the top-rated anime in specific genres.
3. **Average Rating Per Genre**: Calculate the average rating for each genre.
4. **Top 3 Most Popular Anime**: Identify the top 3 anime based on member counts for each genre, along with their ratings.

## Getting Started
To run this project locally:
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Ken-Yamagishi/Data-Analysis-Projects.git
