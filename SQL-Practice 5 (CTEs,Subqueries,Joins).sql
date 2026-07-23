/* ============================================================
   PRACTICE FILE: SUBQUERIES, CTEs AND JOINS
   Scenario: Merchant Navy Operations
   Tables: Ships -> Sailors -> VoyageLogs
   ============================================================
   Ships      : the vessels operated by the shipping company
   Sailors    : crew members, each posted onone ship
   VoyageLogs : each sailor's logged duty record for a voyage

   Write the SQL query below each question.
   ============================================================ */


/* ------------------------------------------------------------
   TABLE 1: Ships (Parent table)
   ------------------------------------------------------------ */
use practice;
CREATE TABLE Ships (
    ship_id INT PRIMARY KEY,
    ship_name VARCHAR(50) NOT NULL UNIQUE,
    ship_type VARCHAR(30) NOT NULL,
    capacity_tons INT CHECK (capacity_tons > 0),
    built_year INT CHECK (built_year >= 1950)
);

INSERT INTO Ships VALUES
(1, 'MV Sagar Kanya', 'Cargo', 45000, 2005),
(2, 'MV Ratna Prabha', 'Tanker', 62000, 1998),
(3, 'MV Nilgiri Express', 'Container', 38000, 2012),
(4, 'MV Coromandel Star', 'Bulk Carrier', 55000, 2001),
(5, 'MV Konkan Voyager', 'Cargo', 30000, 2016);
select * from ships;

/* ------------------------------------------------------------
   TABLE 2: Sailors (Child of Ships)
   ------------------------------------------------------------ */

CREATE TABLE Sailors (
    sailor_id INT PRIMARY KEY,
    sailor_name VARCHAR(50) NOT NULL,
    rank_name VARCHAR(30) NOT NULL,
    ship_id INT,
    age INT CHECK (age >= 18),
    email VARCHAR(100) UNIQUE,
    FOREIGN KEY (ship_id) REFERENCES Ships(ship_id)
);

INSERT INTO Sailors VALUES
(101, 'Ravi Kumar', 'Captain', 1, 42, 'ravi.kumar@merchantnavy.com'),
(102, 'Aman Gupta', 'Deck Officer', 1, 29, 'aman.gupta@merchantnavy.com'),
(103, 'Priya Sharma', 'Engineer', 2, 35, 'priya.sharma@merchantnavy.com'),
(104, 'Karan Mehta', 'Captain', 2, 47, 'karan.mehta@merchantnavy.com'),
(105, 'Sneha Iyer', 'Deck Officer', 3, 27, 'sneha.iyer@merchantnavy.com'),
(106, 'Rohit Verma', 'Engineer', 3, 33, 'rohit.verma@merchantnavy.com'),
(107, 'Divya Nair', 'Captain', 4, 45, 'divya.nair@merchantnavy.com'),
(108, 'Anjali Singh', 'Deck Officer', 4, 26, 'anjali.singh@merchantnavy.com'),
(109, 'Vikram Rao', 'Engineer', 5, 31, 'vikram.rao@merchantnavy.com'),
(110, 'Neha Joshi', 'Captain', 5, 39, 'neha.joshi@merchantnavy.com');


/* ------------------------------------------------------------
   TABLE 3: VoyageLogs (Child of Sailors)
   ------------------------------------------------------------ */

CREATE TABLE VoyageLogs (
    log_id INT PRIMARY KEY,
    sailor_id INT,
    voyage_date DATE,
    distance_covered_nm INT CHECK (distance_covered_nm >= 0),
    hours_on_duty INT CHECK (hours_on_duty BETWEEN 0 AND 24),
    cargo_handled_tons DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (sailor_id) REFERENCES Sailors(sailor_id)
);

INSERT INTO VoyageLogs VALUES
(1, 101, '2026-05-01', 1200, 10, 500.00),
(2, 101, '2026-05-08', 950, 8, 300.00),
(3, 102, '2026-05-01', 1200, 12, 0.00),
(4, 102, '2026-05-08', 950, 9, 0.00),
(5, 103, '2026-05-02', 1600, 11, 800.00),
(6, 104, '2026-05-02', 1600, 14, 0.00),
(7, 104, '2026-05-09', 1100, 10, 0.00),
(8, 105, '2026-05-03', 700, 7, 200.00),
(9, 106, '2026-05-03', 700, 9, 650.00),
(10, 106, '2026-05-10', 900, 10, 400.00),
(11, 107, '2026-05-04', 1400, 13, 0.00),
(12, 108, '2026-05-04', 1400, 8, 0.00),
(13, 108, '2026-05-11', 1000, 6, 0.00),
(14, 109, '2026-05-05', 500, 6, 900.00),
(15, 110, '2026-05-05', 500, 12, 0.00),
(16, 110, '2026-05-12', 1300, 11, 0.00);

-- Note: Deck Officers and Captains have 0 cargo_handled_tons in most rows
-- since cargo handling is primarily logged for Engineers -- useful for
-- filtering and comparisonquestions.

select * from ships;
select * from sailors;
select * from VoyageLogs;
/* ============================================================
   SECTIonA: SUBQUERY IN where CLAUSE
   ============================================================ */

-- Q1. Find all sailors who work onthe ship 'MV Sagar Kanya'.
select sailor_id, sailor_name
from sailors
where ship_id = 
(select ship_id from ships where ship_name = 'MV Sagar Kanya');

-- Q2. Find the ship details where sailor 'Priya Sharma' is posted.
select *
from Ships
where ship_id = (select ship_id from Sailors where sailor_name = 'Priya Sharma');

-- Q3. Find all voyage logs of the sailor with the highest age.
select log_id, voyage_date, distance_covered_nm, hours_on_duty, cargo_handled_tons
from VoyageLogs
where sailor_id = (
select sailor_id from Sailors where age = (select MAX(age) from Sailors));

-- Q4. Find the ship that was built in the same year as 'MV Ratna Prabha'.
select *
from Ships
where built_year = (select built_year from Ships
where ship_name = 'MV Ratna Prabha'
);


-- Q5. Find all sailors whose age is greater than the age of 'Anjali Singh'.
select sailor_name, rank_name, age
from Sailors
where age > (select age from Sailors where sailor_name = 'Anjali Singh');

-- Q6. Find all voyage logs belonging to the sailor who has rank 'Captain'
--     and works onship_id 1.
select log_id, voyage_date, distance_covered_nm, hours_on_duty, cargo_handled_tons
from VoyageLogs
where sailor_id = (
select sailor_id from Sailors where rank_name = 'Captain' AND ship_id = 1
);

-- Q7. Find the sailor(s) who logged the maximum distance_covered_nm in a
--     single voyage (use a subquery with MAX).
select sailor_name, rank_name
from Sailors
where sailor_id IN (select sailor_id from VoyageLogs where distance_covered_nm = (select MAX(distance_covered_nm) from VoyageLogs));

-- Q8. Find all ships whose capacity_tons is greater than the capacity of
--     'MV Konkan Voyager'.
select ship_name, capacity_tons
from Ships
where capacity_tons > (
select capacity_tons from Ships where ship_name = 'MV Konkan Voyager');


-- Q9. Find the sailor with the lowest age onthe ship 'MV Nilgiri Express'.
select sailor_name, age
from Sailors
where age = (select MIN(age)
from Sailors
);

-- Q10. Find all voyage logs where hours_on_duty is greater than the average
--      hours_on_duty across all logs.

select *from VoyageLogs
where  hours_on_duty > (select avg(hours_on_duty) from VoyageLogs);

/* ============================================================
   SECTIonB: SUBQUERY with IN (MULTIPLE VALUES) 
   ============================================================ */

-- Q11. Find all sailors who work onships of type 'Cargo'.
select sailor_name,rank_name, ship_id
from Sailors
where ship_id IN (select ship_id from Ships where ship_type = 'Cargo');

-- Q12. Find all voyage logs of sailors whose rank is 'Engineer'.
select *
from VoyageLogs
where sailor_id IN (select sailor_id from Sailors where rank_name = 'Engineer');



-- Q13. Find all ships that have at least one sailor aged above 40.
select * from Ships
where ship_id in (select ship_id from Sailors where age > 40);

-- Q14. Find all sailors who have logged a voyage with hours_on_duty
--      greater than 12.
select sailor_name, rank_name
from Sailors
where sailor_id IN (select sailor_id from VoyageLogs where hours_on_duty > 12);

-- Q15. Find all sailors who belong to ships built after the year 2005.
select * from Sailors
where ship_id in (select  ship_id from Ships where built_year > 2005);

-- Q16. Find all voyage logs of sailors who work on'MV Ratna Prabha' or
--      'MV Coromandel Star'.
select log_id, sailor_id, voyage_date
from VoyageLogs
where sailor_id IN (select sailor_id from Sailors
where ship_id IN (select ship_id from Ships where ship_name IN ('MV Ratna Prabha', 'MV Coromandel Star'))
);

-- Q17. Find all ships that have at least one sailor with the rank
--      'Captain'.
select  *from Ships
where  ship_id in ( select ship_id from Sailors where rank_name = 'Captain');


-- Q18. Find all sailors who have logged at least one voyage with
--      cargo_handled_tons greater than 500.
select sailor_name, rank_name
from Sailors
where sailor_id IN (select sailor_id from VoyageLogs where cargo_handled_tons > 500);

-- Q19. Find all sailors whose ship_id is among the ships with
--      capacity_tons greater than 40000.
select sailor_name, ship_id
from Sailors
where ship_id IN (select ship_id from Ships where capacity_tons > 40000);



-- Q20. Find all voyage logs where the sailor_id belongs to sailors
--      younger than 30.
select log_id, sailor_id, voyage_date
from VoyageLogs
where sailor_id IN (select sailor_id from Sailors where age < 30);


/* ============================================================
   SECTIonC: BasIC CTE
   ============================================================ */

-- Q21. Using a CTE, find the total distance covered by each sailor
--      across all voyages.
with TotalDistance as (
select sailor_id, sum(distance_covered_nm) as total_distance 
from VoyageLogs
group by sailor_id
)
select s.sailor_id,
s.sailor_name,
td.total_distance
from Sailors s
inner join TotalDistance td
on s.sailor_id = td.sailor_id;


-- Q22. Using a CTE, find the total hours onduty logged by each sailor.
with SailorHours as
(select sailor_id, SUM(hours_on_duty) as Total_hours
from VoyageLogs
group by sailor_id)

select sailor_id, Total_hours from SailorHours;


-- Q23. Using a CTE, find sailors whose total cargo handled is greater
--      than 500 tons.
with SailorCargo as (select sailor_id, SUM(cargo_handled_tons) as Total_cargo
from VoyageLogs
group by  sailor_id)

select sailor_id, Total_cargo from SailorCargo where total_cargo > 500;

-- Q24. Using a CTE, find the average distance covered per voyage for
--      each sailor.
with SailorAvgDistance as
(select sailor_id, AVG(distance_covered_nm) as Avg_distance 
from VoyageLogs 
group by sailor_id)

select sailor_id, Avg_distance from SailorAvgDistance;

-- Q25. Using a CTE, find the number of voyage logs recorded for each
--      sailor.
with SailorLogCount as (
select sailor_id, COUNT(*) as log_count
from VoyageLogs
group by sailor_id
)
select sailor_id, log_count from SailorLogCount;

-- Q26. Using a CTE, find sailors whose average hours_on_duty is more
--      than 9.
with SailorAvgHours as 
(select sailor_id, AVG(hours_on_duty) as Avg_hours
from VoyageLogs
group by  sailor_id)

select  sailor_id, Avg_hours from SailorAvgHours where  avg_hours > 9;

-- Q27. Using a CTE, find the maximum distance covered in a single
--      voyage by each sailor.
with SailorMaxDistance as (
select sailor_id, MAX(distance_covered_nm) as max_distance
from VoyageLogs
group by sailor_id
)
select sailor_id, max_distance from SailorMaxDistance;

-- Q28. Using a CTE, find the total cargo handled per sailor, showing
--      only sailors with more than 0 tons handled.
with SailorCargo as (
select sailor_id, SUM(cargo_handled_tons) as total_cargo
from VoyageLogs
group by sailor_id
)
select sailor_id, total_cargo from SailorCargo where total_cargo > 0;

-- Q29. Using a CTE, find the minimum hours_on_duty logged by each
--      sailor.
with SailorMinHours as (
select sailor_id, MIN(hours_on_duty) as min_hours
from VoyageLogs
group by sailor_id
)
select sailor_id, min_hours from SailorMinHours;

-- Q30. Using a CTE, find the total number of voyages logged oneach
--      voyage_date.
with DateVoyageCount as (
select voyage_date, COUNT(*) as voyage_count
from VoyageLogs
group by voyage_date
)
select voyage_date, voyage_count from DateVoyageCount;


/* ============================================================
   SECTIonD: CTE with JOINS
   ============================================================ */

-- Q31. Using a CTE, find each sailor's name, ship name, and total
--      distance covered.
with SailorDistance as (select  sailor_id,
SUM(distance_covered_nm) as Total_distance
from VoyageLogs
group by sailor_id)

select  s.sailor_name, sh.ship_name, sd.total_distance
from SailorDistance sd
inner join  Sailors s
 on  s.sailor_id = sd.sailor_id
inner join Ships sh
 on sh.ship_id = s.ship_id;


-- Q32. Using a CTE, find each ship's name along with the total cargo
--      handled by all its sailors combined.
with ShipCargo as (
select s.ship_id, SUM(v.cargo_handled_tons) as Total_cargo
from Sailors s
inner join VoyageLogs v 
on v.sailor_id = s.sailor_id
group by s.ship_id)

select sh.ship_name, sc.total_cargo
from ShipCargo sc
inner join Ships sh 
on sh.ship_id = sc.ship_id;

-- Q33. Using a CTE, find each sailor's name, rank, and total hours on
--      duty, joined with their ship name.

with SailorHours as
(select sailor_id, SUM(hours_on_duty) as Total_hours
from VoyageLogs
group by  sailor_id)

select  s.sailor_name, s.rank_name, sh.ship_name, shr.Total_hours
from SailorHours shr
inner join Sailors s 
on s.sailor_id = shr.sailor_id
inner join Ships sh 
on sh.ship_id = s.ship_id;

-- Q34. Using a CTE, find ships whose combined total distance covered
--      (by all sailors) is greater than 2000 nautical miles.
with SailorAvgHours as (select sailor_id, AVG(hours_on_duty) as Avg_hours
from VoyageLogs
group by sailor_id)

select  s.sailor_name, sah.avg_hours, sh.ship_type
from  SailorAvgHours sah
inner join Sailors s 
on s.sailor_id = sah.sailor_id
inner join Ships sh
on sh.ship_id = s.ship_id;

-- Q35. Using a CTE, find each sailor's name and average hours onduty,
--      along with the ship type they work on.
with SailorAvgHours as (
select sailor_id, AVG(hours_on_duty) as avg_hours
from VoyageLogs
group by sailor_id
)
select s.sailor_name, sah.avg_hours, sh.ship_type
from SailorAvgHours sah
inner join Sailors s
on s.sailor_id = sah.sailor_id
inner join Ships sh
on sh.ship_id = s.ship_id;

-- Q36. Using a CTE, find each ship's name and the number of voyage
--      logs recorded by sailors onthat ship.
with ShipLogCount as (
select s.ship_id, COUNT(*) as log_count
from Sailors s
inner join VoyageLogs v 
on v.sailor_id = s.sailor_id
group by s.ship_id
)
select sh.ship_name, slc.log_count
from ShipLogCount slc
inner join Ships sh
on sh.ship_id = slc.ship_id;

-- Q37. Using a CTE, find sailors whose total distance covered is above
--      the average total distance across all sailors (join required
--      to show ship name too).
with SailorDistance as (
select sailor_id, SUM(distance_covered_nm) as total_distance
from VoyageLogs
group by sailor_id
)
select s.sailor_name, sh.ship_name, sd.total_distance
from SailorDistance sd
inner join Sailors s 
on s.sailor_id = sd.sailor_id
inner join Ships sh
on sh.ship_id = s.ship_id
where sd.total_distance > (select AVG(total_distance) from SailorDistance);

-- Q38. Using a CTE, find each rank (Captain, Deck Officer, Engineer)
--      along with the total cargo handled by sailors of that rank.
with RankCargo as (
select s.rank_name, SUM(v.cargo_handled_tons) as total_cargo
from Sailors s
inner join VoyageLogs v
on v.sailor_id = s.sailor_id
group by s.rank_name
)
select rank_name, total_cargo from RankCargo;

-- Q39. Using a CTE, find each ship's name and its youngest sailor's age.
with ShipYoungest as (
select ship_id, MIN(age) as youngest_age
from Sailors
group by ship_id
)
select sh.ship_name, sy.youngest_age
from ShipYoungest sy
inner join Ships sh 
on sh.ship_id = sy.ship_id;

-- Q40. Using a CTE, find each sailor's name, ship name, and total
--      contribution(distance_covered_nm + cargo_handled_tons).
with SailorContributionas as(
select sailor_id, SUM(distance_covered_nm + cargo_handled_tons) as total_contribution
from VoyageLogs
group by sailor_id
)
select s.sailor_name, sh.ship_name, sc.total_contribution
from SailorContributionsc
inner join Sailors s
on s.sailor_id = sc.sailor_id
inner join Ships sh 
on sh.ship_id = s.ship_id;



/* ============================================================
   SECTIonE: JOINS (with group by / HAVING)
   ============================================================ */

-- Q41. List every sailor along with the name of the ship they work on.
select  s.sailor_name, sh.ship_name
from  Sailors s
inner join  Ships sh 
on  sh.ship_id = s.ship_id;

-- Q42. Find the total number of sailors posted oneach ship.
select sh.ship_name, COUNT(s.sailor_id) as sailor_count
from Ships sh
inner join Sailors s
on s.ship_id = sh.ship_id
group by sh.ship_name;

-- Q43. Find ships that have more than 2 sailors.
select  sh.ship_name, COUNT(s.sailor_id) as sailor_count
from Ships sh
inner join Sailors s 
on s.ship_id = sh.ship_id
group by  sh.ship_name
having  COUNT(s.sailor_id) > 2;

-- Q44. Find the total distance covered by each ship (joining all three
--      tables).
select sh.ship_name, sum(v.distance_covered_nm) as Total_distance
from Ships sh
inner join Sailors s
on s.ship_id = sh.ship_id
inner join VoyageLogs v
on v.sailor_id = s.sailor_id
group by  sh.ship_name;

-- Q45. Find ships whose total distance covered is more than 2500
--      nautical miles.
select sh.ship_name, SUM(v.distance_covered_nm) as Total_distance
from  Ships sh
inner join Sailors s 
on s.ship_id = sh.ship_id
inner join VoyageLogs v 
on v.sailor_id = s.sailor_id
group by  sh.ship_name
having  SUM(v.distance_covered_nm) > 2500;

-- Q46. Find the total cargo handled by each rank across all ships.
select s.rank_name, SUM(v.cargo_handled_tons) as Total_cargo
from Sailors s
inner join VoyageLogs v 
on v.sailor_id = s.sailor_id
group by  s.rank_name;

-- Q47. Find ranks where the average hours_on_duty is greater than 9.
select  s.rank_name, avg(v.hours_on_duty) as Avg_hours
from Sailors s
inner join  VoyageLogs v 
on v.sailor_id = s.sailor_id
group by s.rank_name
having avg(v.hours_on_duty) > 9;


-- Q48. Find the number of voyage logs recorded for each ship.
select  sh.ship_name, COUNT(v.log_id) as log_count
from Ships sh
inner join Sailors s 
on s.ship_id = sh.ship_id
inner join VoyageLogs v 
on v.sailor_id = s.sailor_id
group by sh.ship_name;


-- Q49. Find ships where the average sailor age is above 35.
select  sh.ship_name, avg(s.age) as avg_age
from Ships sh
inner join Sailors s 
on s.ship_id = sh.ship_id
group by  sh.ship_name
having avg(s.age) > 35;

-- Q50. Find the ship with the highest total distance covered (join all
--      three tables, group by ship, sort, and limit to top 1).
select sh.ship_name, SUM(v.distance_covered_nm) as total_distance
from Ships sh
inner join Sailors s 
on s.ship_id = sh.ship_id
inner join VoyageLogs v 
on v.sailor_id = s.sailor_id
group by sh.ship_name
ORDER BY total_distance DESC
LIMIT 1;
