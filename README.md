# SQL Practice Repository 🚀

Welcome to my SQL Practice Repository! This repository contains my SQL learning journey, where I solve real-world database problems and strengthen my SQL skills through hands-on practice.

## 📌 About

This repository includes SQL scripts covering everything from beginner to advanced concepts. Each script is written to improve my understanding of database design, querying, and data analysis.

## 📚 Topics Covered

- Database Creation
- Table Creation
- Data Insertion
- SELECT Statements
- WHERE Clause
- ORDER BY
- GROUP BY
- HAVING Clause
- Aggregate Functions
- String Functions
- Date Functions
- CASE Statements
- Joins
  - INNER JOIN
  - LEFT JOIN
  - RIGHT JOIN
  - FULL JOIN
- Subqueries
- Common Table Expressions (CTE)
- Views
- Constraints
  - PRIMARY KEY
  - FOREIGN KEY
  - UNIQUE
  - CHECK
  - DEFAULT
- Practice Questions
- Real-world SQL Scenarios

---

## 🗂 Repository Structure

```
SQL-Practice/
│
├── SQL-Practice.sql
└── README.md
```

---

## 🎯 Learning Goals

- Write efficient SQL queries
- Understand database relationships
- Solve business-related SQL problems
- Improve query optimization skills
- Prepare for Data Analyst interviews

---

## 💡 Sample SQL Concepts

✔ Aggregate Functions

```sql
SELECT department, AVG(salary)
FROM employees
GROUP BY department;
```

✔ INNER JOIN

```sql
SELECT p.player_name, t.team_name
FROM Players p
JOIN Teams t
ON p.team_id = t.team_id;
```

✔ Common Table Expression (CTE)

```sql
WITH HighSalary AS (
    SELECT *
    FROM Employees
    WHERE salary > 50000
)
SELECT * FROM HighSalary;
```

---

## 🛠 Tools Used

- MySQL
- SQL
- Git
- GitHub

---

## 📈 Repository Purpose

This repository serves as my personal SQL practice space where I regularly upload new problems, solutions, and mini projects as I continue learning Data Analytics.

---

## 🚀 Future Additions

- Window Functions
- Stored Procedures
- Triggers
- Indexes
- Query Optimization
- SQL Interview Questions
- Mini Database Projects

---

## 🤝 Connect With Me

**LinkedIn:** www.linkedin.com/in/rajangupta0099

**GitHub:** https://github.com/Rajangpt0099-hub

---

⭐ If you found this repository helpful, consider giving it a **Star**!
