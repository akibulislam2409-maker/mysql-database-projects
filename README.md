# 🗄️ MySQL Database Projects

Two database projects from **COMP514 Fundamentals of Computer Databases** (Grade: A+).

## 1. Movie Lending Database: design and implementation
A full relational database for a community movie-lending service.

- **ER diagram** and **data dictionary**
- **13 tables**: Member, Staff, Contact_Method, Genre, Movie, Movie_Genre, Movie_Copy, Acquisition, Loan, Renewal, Fine, Payment, Sale
- Primary and foreign keys with `ON DELETE CASCADE` / `SET NULL` rules, plus cascade testing
- Sample data inserts and business queries, such as members' current loans, fines, and schema changes with `ALTER TABLE`

## 2. MySQL Administration for an IT Startup
Setting up and securing a multi-user MySQL server.

- MySQL Server and Workbench installation and configuration
- **Role-based access control**: users for Marketing Manager, Technical Manager, Sales Rep, Customer Support and a Read-only Analyst, using `GRANT` / `REVOKE`
- Table maintenance with Schema Inspector (analyze, optimize, check)
- Query analysis with `EXPLAIN` (full table scans and optimisation)
- **Backup and recovery** of the database

## 📁 Files
```
movie-lending-db/
  clh_movie_database.sql
  data_dictionary.csv
  er-diagram/
    clh-erd-diagram.html
    erd-sale-latest-diagram.mwb
    erd-sale-latest.png
  screenshots/
    (6 images)
mysql-administration/
  screenshots/
    (8 images)
```

## ▶️ How to run
1. Open MySQL Workbench
2. Open `movie-lending-db/clh_movie_database.sql`. It contains the CREATE TABLE, INSERT and query scripts in order
3. Open the `.mwb` file in `er-diagram/` to see the ER model

**Tools:** MySQL 8, MySQL Workbench
