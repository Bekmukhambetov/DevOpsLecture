# lesson_13
#SQL
# Створення бази даних для шкіл та дитячих садочків

## Опис
Створіть базу даних з назвою SchoolDB.
`CREATE DATABASE SchoolDB;`
`USE SchoolDB;`
`SHOW DATABASES;`

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| SchoolDB           |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)

## Структура таблиць: Створіть таблицю Institutions, яка зберігатиме інформацію про школи та дитячі садочки.

```sql
### Institutions

-- Створення таблиці Institutions
CREATE TABLE Institutions (
    institution_id INT AUTO_INCREMENT PRIMARY KEY,
    institution_name VARCHAR(255) NOT NULL,
    institution_type ENUM('School', 'Kindergarten') NOT NULL,
    address VARCHAR(255) NOT NULL
);
### Classes

-- Створення таблиці Classes
CREATE TABLE Classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(255) NOT NULL,
    institution_id INT,
    direction ENUM('Mathematics', 'Biology and Chemistry', 'Language Studies') NOT NULL,
    FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id) ON DELETE CASCADE
);

### Children

-- Створення таблиці Children
CREATE TABLE Children (
    child_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    year_of_entry YEAR NOT NULL,
    age INT NOT NULL,
    institution_id INT,
    class_id INT,
    FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES Classes(class_id) ON DELETE CASCADE
);

### Parents

-- Створення таблиці Parents
CREATE TABLE Parents (
    parent_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    child_id INT,
    tuition_fee DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (child_id) REFERENCES Children(child_id) ON DELETE CASCADE
);

mysql> SHOW TABLES;
+--------------------+
| Tables_in_SchoolDB |
+--------------------+
| Children           |
| Classes            |
| Institutions       |
| Parents            |
+--------------------+
4 rows in set (0.00 sec)
mysql> SHOW COLUMNS FROM Institutions;
+------------------+-------------------------------+------+-----+---------+----------------+
| Field            | Type                          | Null | Key | Default | Extra          |
+------------------+-------------------------------+------+-----+---------+----------------+
| institution_id   | int                           | NO   | PRI | NULL    | auto_increment |
| institution_name | varchar(255)                  | NO   |     | NULL    |                |
| institution_type | enum('School','Kindergarten') | NO   |     | NULL    |                |
| address          | varchar(255)                  | NO   |     | NULL    |                |
+------------------+-------------------------------+------+-----+---------+----------------+
4 rows in set (0.01 sec)

## Вставка даних

-- Вставка даних у таблицю Institutions
INSERT INTO Institutions (institution_name, institution_type, address)
VALUES
('School#1', 'School', 'Shevchenka 1'),
('Kindergarten #1', 'Kindergarten', 'Shevchenka 2'),
('School#2', 'School', 'Soborna 24'),
('Kindergarten #2', 'Kindergarten', 'Soborna 20'),
('School#3', 'School', 'Vesny 24');

mysql> SELECT * FROM Institutions;
+----------------+------------------+------------------+--------------+
| institution_id | institution_name | institution_type | address      |
+----------------+------------------+------------------+--------------+
|              1 | School#1         | School           | Shevchenka 1 |
|              2 | Kindergarten #1  | Kindergarten     | Shevchenka 2 |
|              3 | School#2         | School           | Soborna 24   |
|              4 | Kindergarten #2  | Kindergarten     | Soborna 20   |
|              5 | School#3         | School           | Vesny 24     |
+----------------+------------------+------------------+--------------+
5 rows in set (0.00 sec)
-- Вставка даних у таблицю Classes
INSERT INTO Classes (class_name, institution_id, direction)
VALUES
('1A', 1, 'Mathematics'),
('2A', 3, 'Mathematics'),
('Preschool', 2, 'Language Studies'),
('Preschool', 4, 'Language Studies'),
('3B', 5, 'Biology and Chemistry');

mysql> SELECT * FROM Classes;
+----------+------------+----------------+-----------------------+
| class_id | class_name | institution_id | direction             |
+----------+------------+----------------+-----------------------+
|        1 | 1A         |              1 | Mathematics           |
|        2 | 2A         |              3 | Mathematics           |
|        3 | Preschool  |              2 | Language Studies      |
|        4 | Preschool  |              4 | Language Studies      |
|        5 | 3B         |              5 | Biology and Chemistry |
+----------+------------+----------------+-----------------------+
5 rows in set (0.00 sec)

-- Вставка даних у таблицю Children
INSERT INTO Children (first_name, last_name, birth_date, year_of_entry, age, institution_id, class_id)
VALUES
('Ivan', 'Lybistok', '2018-05-01', 2024, 6, 1, 1),
('Sasha', 'Grey', '2017-03-12', 2023, 7, 3, 2),
('Mark', 'Gavryluk', '2016-09-15', 2022, 8, 5, 5),
('Lesyk', 'Ivasyk', '2020-05-01', 2024, 4, 2, 3),
('Yaroslav', 'Halushka', '2019-03-12', 2023, 5, 4, 4);

mysql> SELECT * FROM Children;
+----------+------------+-----------+------------+---------------+-----+----------------+----------+
| child_id | first_name | last_name | birth_date | year_of_entry | age | institution_id | class_id |
+----------+------------+-----------+------------+---------------+-----+----------------+----------+
|        1 | Ivan       | Lybistok  | 2018-05-01 |          2024 |   6 |              1 |        1 |
|        2 | Sasha      | Grey      | 2017-03-12 |          2023 |   7 |              3 |        2 |
|        3 | Mark       | Gavryluk  | 2016-09-15 |          2022 |   8 |              5 |        5 |
|        4 | Lesyk      | Ivasyk    | 2020-05-01 |          2024 |   4 |              2 |        3 |
|        5 | Yaroslav   | Halushka  | 2019-03-12 |          2023 |   5 |              4 |        4 |
+----------+------------+-----------+------------+---------------+-----+----------------+----------+
5 rows in set (0.00 sec)

-- Вставка даних у таблицю Parents
INSERT INTO Parents (first_name, last_name, child_id, tuition_fee)
VALUES
('Petro', 'Lybistok', 1, 200.00),
('Dasha', 'Grey', 2, 200.00),
('Sophia', 'Gavryluk', 3, 200.00),
('Vitaliy', 'Ivasyk', 4, 100.00),
('Yuriy', 'Halushka', 5, 100.00);

mysql> SELECT * FROM Parents;
+-----------+------------+-----------+----------+-------------+
| parent_id | first_name | last_name | child_id | tuition_fee |
+-----------+------------+-----------+----------+-------------+
|         1 | Petro      | Lybistok  |        1 |      200.00 |
|         2 | Dasha      | Grey      |        2 |      200.00 |
|         3 | Sophia     | Gavryluk  |        3 |      200.00 |
|         4 | Vitaliy    | Ivasyk    |        4 |      100.00 |
|         5 | Yuriy      | Halushka  |        5 |      100.00 |
+-----------+------------+-----------+----------+-------------+
5 rows in set (0.00 sec)

## Виконання запитів

-- Отримання списку дітей із закладом і напрямом навчання

mysql> SELECT c.first_name, c.last_name, i.institution_name, cl.direction
    -> FROM Children c
    -> JOIN Institutions i ON c.institution_id = i.institution_id
    -> JOIN Classes cl ON c.class_id = cl.class_id;
+------------+-----------+------------------+-----------------------+
| first_name | last_name | institution_name | direction             |
+------------+-----------+------------------+-----------------------+
| Ivan       | Lybistok  | School#1         | Mathematics           |
| Sasha      | Grey      | School#2         | Mathematics           |
| Mark       | Gavryluk  | School#3         | Biology and Chemistry |
| Lesyk      | Ivasyk    | Kindergarten #1  | Language Studies      |
| Yaroslav   | Halushka  | Kindergarten #2  | Language Studies      |
+------------+-----------+------------------+-----------------------+
5 rows in set (0.00 sec)

-- Інформація про батьків і дітей із вартістю навчання

mysql> SELECT p.first_name AS parent_first_name, p.last_name AS parent_last_name, 
    ->        ch.first_name AS child_first_name, ch.last_name AS child_last_name, p.tuition_fee
    -> FROM Parents p
    -> JOIN Children ch ON p.child_id = ch.child_id;
+-------------------+------------------+------------------+-----------------+-------------+
| parent_first_name | parent_last_name | child_first_name | child_last_name | tuition_fee |
+-------------------+------------------+------------------+-----------------+-------------+
| Petro             | Lybistok         | Ivan             | Lybistok        |      200.00 |
| Dasha             | Grey             | Sasha            | Grey            |      200.00 |
| Sophia            | Gavryluk         | Mark             | Gavryluk        |      200.00 |
| Vitaliy           | Ivasyk           | Lesyk            | Ivasyk          |      100.00 |
| Yuriy             | Halushka         | Yaroslav         | Halushka        |      100.00 |
+-------------------+------------------+------------------+-----------------+-------------+
5 rows in set (0.00 sec)

-- Список всіх закладів із кількістю дітей

mysql> SELECT i.institution_name, i.address, COUNT(c.child_id) AS number_of_children
    -> FROM Institutions i
    -> LEFT JOIN Children c ON i.institution_id = c.institution_id
    -> GROUP BY i.institution_name, i.address;
+------------------+--------------+--------------------+
| institution_name | address      | number_of_children |
+------------------+--------------+--------------------+
| School#1         | Shevchenka 1 |                  1 |
| Kindergarten #1  | Shevchenka 2 |                  1 |
| School#2         | Soborna 24   |                  1 |
| Kindergarten #2  | Soborna 20   |                  1 |
| School#3         | Vesny 24     |                  1 |
+------------------+--------------+--------------------+
5 rows in set (0.01 sec)

## Бекап бази даних
-- Для створення бекапу бази даних використовуємо команду в MySQL:
mysqldump -u root -p SchoolDB > SchoolDB_backup.sql

mysql> CREATE DATABASE NewSchoolDB;
Query OK, 1 row affected (0.04 sec)

mysql> exit

-- Щоб застосувати бекап на новій базі даних:
mysql -u root -p NewSchoolDB < SchoolDB_backup.sql

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| NewSchoolDB        |
| SchoolDB           |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
6 rows in set (0.00 sec)

mysql> USE NewSchoolDB;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+-----------------------+
| Tables_in_NewSchoolDB |
+-----------------------+
| Children              |
| Classes               |
| Institutions          |
| Parents               |
+-----------------------+
4 rows in set (0.01 sec)

## Додаткове завдання: Анонімізація даних

-- Анонімізація таблиці Children
UPDATE Children
SET first_name = 'Child', last_name = 'Anonymous';

mysql> SELECT * FROM Children;
+----------+------------+-----------+------------+---------------+-----+----------------+----------+
| child_id | first_name | last_name | birth_date | year_of_entry | age | institution_id | class_id |
+----------+------------+-----------+------------+---------------+-----+----------------+----------+
|        1 | Child      | Anonymous | 2018-05-01 |          2024 |   6 |              1 |        1 |
|        2 | Child      | Anonymous | 2017-03-12 |          2023 |   7 |              3 |        2 |
|        3 | Child      | Anonymous | 2016-09-15 |          2022 |   8 |              5 |        5 |
|        4 | Child      | Anonymous | 2020-05-01 |          2024 |   4 |              2 |        3 |
|        5 | Child      | Anonymous | 2019-03-12 |          2023 |   5 |              4 |        4 |
+----------+------------+-----------+------------+---------------+-----+----------------+----------+
5 rows in set (0.00 sec)

-- Анонімізація таблиці Parents
UPDATE Parents
SET first_name = CONCAT('Parent', parent_id), last_name = 'Anonymous';
mysql> SELECT * FROM Parents;
+-----------+------------+-----------+----------+-------------+
| parent_id | first_name | last_name | child_id | tuition_fee |
+-----------+------------+-----------+----------+-------------+
|         1 | Parent1    | Anonymous |        1 |      200.00 |
|         2 | Parent2    | Anonymous |        2 |      200.00 |
|         3 | Parent3    | Anonymous |        3 |      200.00 |
|         4 | Parent4    | Anonymous |        4 |      100.00 |
|         5 | Parent5    | Anonymous |        5 |      100.00 |
+-----------+------------+-----------+----------+-------------+
5 rows in set (0.01 sec)

-- Анонімізація таблиці Institutions
UPDATE Institutions
SET institution_name = CONCAT('Institution', institution_id);

mysql> SELECT * FROM Institutions;
+----------------+------------------+------------------+--------------+
| institution_id | institution_name | institution_type | address      |
+----------------+------------------+------------------+--------------+
|              1 | Institution1     | School           | Shevchenka 1 |
|              2 | Institution2     | Kindergarten     | Shevchenka 2 |
|              3 | Institution3     | School           | Soborna 24   |
|              4 | Institution4     | Kindergarten     | Soborna 20   |
|              5 | Institution5     | School           | Vesny 24     |
+----------------+------------------+------------------+--------------+
5 rows in set (0.00 sec)

-- Анонімізація фінансових даних
UPDATE Parents
SET tuition_fee = ROUND(RAND() * (100 - 200) + 200, 2);

mysql> SELECT * FROM Parents;
+-----------+------------+-----------+----------+-------------+
| parent_id | first_name | last_name | child_id | tuition_fee |
+-----------+------------+-----------+----------+-------------+
|         1 | Parent1    | Anonymous |        1 |      150.29 |
|         2 | Parent2    | Anonymous |        2 |      109.08 |
|         3 | Parent3    | Anonymous |        3 |      194.50 |
|         4 | Parent4    | Anonymous |        4 |      145.25 |
|         5 | Parent5    | Anonymous |        5 |      142.76 |
+-----------+------------+-----------+----------+-------------+
5 rows in set (0.00 sec)




