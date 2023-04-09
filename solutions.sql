-- Задание 1. Вывести имена всех людей, которые есть в базе данных авиакомпаний.

SELECT name
from passenger;

-- Задание 2. Вывести названия всеx авиакомпаний.

SELECT name
from company;

-- Задание 3. Вывести все рейсы, совершенные из Москвы.

SELECT *
FROM trip
WHERE town_from = "Moscow";
