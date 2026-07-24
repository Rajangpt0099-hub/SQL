/* ============================================================
   PRACTICE FILE: CASE, UPDATE, ALTER, DELETE, GRANT, REVOKE,
   ROLLBACK, COMMIT, SAFE UPDATE MODE
   Scenario: Movies Dataset
   Note: Single table, no joins involved.
   Write the SQL query below each question.
   ============================================================ */


/* ------------------------------------------------------------
   TABLE: Movies
   ------------------------------------------------------------ */
use practice;
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    movie_title VARCHAR(100) NOT NULL,
    genre VARCHAR(30),
    release_year INT CHECK (release_year >= 1950),
    rating DECIMAL(3,1) CHECK (rating BETWEEN 0 AND 10),
    language_name VARCHAR(30),
    director VARCHAR(50),
    box_office_cr DECIMAL(10,2) DEFAULT 0.00
);

INSERT INTO Movies VALUES
(1, 'Shadows of Kanpur', 'Drama', 2018, 8.2, 'Hindi', 'Anil Rao', 85.50),
(2, 'The Last Monsoon', 'Romance', 2015, 7.4, 'Hindi', 'Meera Kapoor', 42.30),
(3, 'Steel City', 'Action', 2020, 6.8, 'Telugu', 'Suresh Babu', 210.75),
(4, 'Whispers in Silence', 'Thriller', 2019, 8.9, 'Tamil', 'Vignesh Kumar', 95.00),
(5, 'Coastal Winds', 'Drama', 2012, 7.1, 'Malayalam', 'Anil Rao', 30.20),
(6, 'Midnight Express Mumbai', 'Action', 2022, 5.9, 'Hindi', 'Rakesh Sinha', 180.60),
(7, 'The Forgotten Melody', 'Musical', 2016, 8.5, 'Bengali', 'Ritu Ghosh', 25.40),
(8, 'Desert Storm', 'Action', 2021, 6.2, 'Hindi', 'Rakesh Sinha', 150.90),
(9, 'Falling Leaves', 'Romance', 2014, 7.8, 'Marathi', 'Meera Kapoor', 18.00),
(10, 'Circuit Breaker', 'Sci-Fi', 2023, 9.1, 'Telugu', 'Suresh Babu', 265.30),
(11, 'Quiet Streets', 'Thriller', 2017, 6.5, 'Kannada', 'Vignesh Kumar', 38.75),
(12, 'The Wedding Season', 'Comedy', 2013, 6.9, 'Hindi', 'Anil Rao', 55.60);

select * from Movies;
/* ============================================================
   SECTION A: CASE STATEMENTS
   ============================================================ */

-- Q1. Display each movie's title and rating, with a label 'Blockbuster'
--     for box_office_cr above 150, 'Hit' for 50 to 150, and 'Average'
--     for below 50.
select movie_title, box_office_cr,
case
when box_office_cr > 150 then 'Blockbuster'
when box_office_cr between 50 and 150 then 'Hit'
else 'Average'
end as  performance
from Movies;

-- Q2. Display each movie's title and release_year with a label 'Recent'
--     for movies released after 2019, and 'Old' otherwise.
select movie_title,release_year,
case
when release_year>2019 then'recent'
else 'old'
end as movie_age
from Movies;

-- Q3. Display each movie's title and rating with a label 'Excellent'
--     for rating 8 or above, 'Good' for 6 to 7.9, and 'Below Average'
--     for anything less.
select movie_title, rating,
case
when  rating >= 8 then 'Excellent'
when rating between 6 and  7.9 then 'Good'
else 'Below Average'
end as  rating_label
from Movies;

-- Q4. Display each movie's genre, showing 'High Energy' for Action and
--     Sci-Fi genres, and 'Slow Paced' for all other genres.
select genre,
case
when genre in ('action','sci-fi') then 'High Energy'
else 'slow paced'
end as energy_type
from Movies;

-- Q5. Display each movie's title with a label showing whether the
--     movie is in 'Hindi' or 'Regional' language.
select movie_title,
case
when language_name = 'hindi'then 'hindi'
else 'regional'
end as language_type
from Movies;

-- Q6. Display each movie's title and director, labeling movies directed
--     by 'Anil Rao' or 'Meera Kapoor' as 'Veteran Director', and all
--     others as 'New Age Director'.
select  movie_title, director,
case
when director in ('Anil Rao', 'Meera Kapoor') then 'Veteran Director'
else 'New Age Director'
end as director_category
from Movies;


/* ============================================================
   SECTION B: UPDATE
   ============================================================ */

-- Q7. Update the rating of the movie 'Steel City' to 7.0.
set sql_safe_updates = 0;
update  Movies
set rating = 7.0
where movie_title = 'Steel City';

-- Q8. Increase the box_office_cr by 10 crore for all movies in the
--     'Action' genre.
update Movies 
set box_office_cr= box_office_cr +10
where genre = 'Action';

-- Q9. Update the genre of movie_id 7 to 'Drama'.
update Movies 
set genre = 'drama'
where movie_id =7;

-- Q10. Set the director of all movies currently directed by
--      'Rakesh Sinha' to 'Rakesh S. Sinha'.
update Movies
set director =  'Rakesh S. Sinha'
where director = 'Rakesh Sinha';
-- Q11. Update the language of the movie 'Falling Leaves' to 'Hindi'.
update Movies
set language_name ='Hindi'
where movie_title = 'Falling Leaves';

-- Q12. Reduce the rating by 0.5 for all movies released before 2015.
update Movies
set rating = rating - 0.5
where release_year < 2015;


/* ============================================================
   SECTION C: ALTER
   ============================================================ */

-- Q13. Add a new column called `ott_platform` of type VARCHAR(30) to
--      the Movies table.
alter table  Movies
add column  ott_platform 
varchar(30);

-- Q14. Modify the `movie_title` column to allow up to 150 characters.
alter table Movies 
modify column movie_title varchar(150);

-- Q15. Add a new column called `is_sequel` of type BOOLEAN with a
--      default value of FALSE.
alter table Movies
add column is_sequel boolean default false;

-- Q16. Rename the column `box_office_cr` to `collection_cr`.
alter table Movies
rename column box_office_cr to collection_cr;

-- Q17. Drop the column `ott_platform` from the Movies table.
alter table Movies
drop column ott_platform;

-- Q18. Modify the `rating` column to allow values with 2 decimal
--      places instead of 1.
alter table Movies 
modify column rating decimal(3,2);


/* ============================================================
   SECTION D: DELETE
   ============================================================ */

-- Q19. Delete the movie with movie_id 12.
delete from Movies
where  movie_id = 12;

-- Q20. Delete all movies with a rating below 6.5.
delete from Movies
where rating < 6.5;

-- Q21. Delete all movies belonging to the 'Musical' genre.
delete from Movies
where genre = 'musical';

-- Q22. Delete all movies released before the year 2013.
delete from Movies
where release_year < 2013;

-- Q23. Delete the movie titled 'The Wedding Season'.
delete from Movies
where movie_title = 'The Wedding Season';

-- Q24. Delete all movies where box_office_cr is 0 (if any exist after
--      other updates).
delete from Movies
where collection_cr = 0;


/* ============================================================
   SECTION E: GRANT AND REVOKE
   ============================================================ */

-- Q25. Create a new user named 'critic_user'@'localhost' with a
--      password of your choice.

create user 'critic_user'@'localhost' identified by 'CriticPass123!';

-- Q26. Grant SELECT privilege on the Movies table to 'critic_user'.
grant select on practice.Movies to 'critic_user'@'localhost' ;

-- Q27. Grant both SELECT and UPDATE privileges on the Movies table to
--      'critic_user'.
grant select ,update on practice.Movies to 'critic_user'@'localhost' ;

-- Q28. Revoke the UPDATE privilege from 'critic_user', keeping only
--      SELECT.
revoke update on practice.Movies from 'critic_user'@'localhost' ;

-- Q29. Grant ALL PRIVILEGES on the entire movies database to a user
--      named 'admin_user'@'localhost'.
grant all privileges on practice.* to 'admin_user'@'localhost';
create user 'admin_user'@'localhost' identified by  'AdminPass123!';
grant all privileges on movies_db.* to 'admin_user'@'localhost';
-- Q30. View all privileges currently granted to 'critic_user'.
show grants for 'critic_user'@'localhost' ;


/* ============================================================
   SECTION F: SAFE UPDATE MODE
   ============================================================ */

-- Q31. Check the current status of safe update mode.
show variables like  'sql_safe_updates';

-- Q32. Disable safe update mode, then update the genre to 'Drama' for
--      all movies directed by 'Anil Rao' (a non-key column).
set SQL_SAFE_UPDATES = 0;

update Movies
set  genre = 'Drama'
where director = 'Anil Rao';

-- Q33. Attempt to update the rating of all movies with language
--      'Hindi' without disabling safe update mode first, and note the
--      error received.
set sql_safe_updates = 1;

update Movies
set  rating = rating - 0.1
where language_name = 'Hindi';


-- Q34. Disable safe update mode, delete all movies with box_office_cr
--      below 30 (a non-key column condition).
-- Q31
show variables like 'sql_safe_updates';

-- Q32
set SQL_SAFE_UPDATES = 0;

update Movies
set genre = 'Drama'
where director = 'Anil Rao';

-- Q33 (this is meant to throw an error)
set SQL_SAFE_UPDATES = 1;

update Movies
set rating = rating - 0.1
where language_name = 'Hindi';
-- Expected error:
-- Error Code: 1175. You are using safe update mode and you tried to
-- update a table without a WHERE clause that uses a KEY column.

-- Q34
set  SQL_SAFE_UPDATES = 0;

delete from Movies
where collection_cr < 30;
