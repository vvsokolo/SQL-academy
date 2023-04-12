-- Задание 1. Вывести имена всех людей, которые есть в базе данных авиакомпаний.

SELECT name
FROM passenger;

-- Задание 2. Вывести названия всеx авиакомпаний.

SELECT name
FROM company;

-- Задание 3. Вывести все рейсы, совершенные из Москвы.

SELECT *
FROM trip
WHERE town_from = "Moscow";

-- Задание 4. Вывести имена людей, которые заканчиваются на "man".

SELECT name
FROM passenger
WHERE name LIKE "%man";

-- Задание 5. Вывести количество рейсов, совершенных на TU-134.

SELECT COUNT(*) as count
FROM trip
WHERE plane = 'TU-134';

-- Задание 6. Какие компании совершали перелеты на Boeing.

SELECT DISTINCT name
FROM Company
INNER JOIN Trip ON Company.id = Trip.company
WHERE plane = "Boeing";

-- Задание 7. Вывести все названия самолётов, на которых можно улететь в Москву (Moscow).

SELECT DISTINCT plane
FROM Trip
WHERE town_to = 'Moscow';

-- Задание 8. В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?

SELECT DISTINCT town_to,
TIMEDIFF (time_in, time_out) AS flight_time
FROM Trip
WHERE town_from = 'Paris';

-- Задание 9. Какие компании организуют перелеты из Владивостока (Vladivostok)?

SELECT DISTINCT Company.name
FROM Company
JOIN TRIP 
ON Company.id = Trip.company
WHERE town_from = 'Vladivostok';

-- Задание 10. Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г.

SELECT *	
FROM Trip
WHERE time_out BETWEEN '1900-01-01 10:00:00' AND '1900-01-01 14:00:00';

-- Задание 11. Вывести пассажиров с самым длинным именем.

SELECT name
FROM  Passenger
WHERE LENGTH(name) = (
		SELECT max(LENGTH(name))
		FROM Passenger);

-- Задание 12. Вывести id и количество пассажиров для всех прошедших полётов.

SELECT trip,
COUNT(passenger) as count
FROM Pass_in_trip
GROUP BY trip;

-- Задание 13. Вывести имена людей, у которых есть полный тёзка среди пассажиров.

SELECT name
FROM Passenger
GROUP BY name
HAVING COUNT(*) > 1;

-- Задание 14. В какие города летал Bruce Willis.

SELECT DISTINCT town_to
FROM trip
JOIN Pass_in_trip ON Trip.id = Pass_in_trip.trip
JOIN Passenger ON Pass_in_trip.passenger = Passenger.id
WHERE name = 'Bruce Willis';

-- Задание 15. Выведите дату и время прилёта пассажира Стив Мартин (Steve Martin) в Лондон (London).

SELECT time_in
FROM Trip
JOIN Pass_in_trip ON Trip.id = Pass_in_trip.trip
JOIN Passenger ON Pass_in_trip.passenger = Passenger.id
WHERE town_to = 'London' AND Passenger.name = 'Steve Martin';

-- Задание 16. Вывести отсортированный по количеству перелетов (по убыванию) и имени (по возрастанию) список пассажиров, совершивших хотя бы 1 полет.

SELECT name,
COUNT(trip) AS count
FROM Passenger
JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
GROUP BY name
HAVING COUNT(trip) > 0
ORDER BY COUNT(trip) DESC, name ASC;

-- Задание 17. Определить, сколько потратил в 2005 году каждый из членов семьи.

SELECT member_name, status, SUM(unit_price * amount) AS costs
FROM FamilyMembers
JOIN Payments ON FamilyMembers.member_id = Payments.family_member
WHERE date LIKE '2005-%'
GROUP BY member_name, status;

-- Задание 18. Узнать, кто старше всех в семьe.

SELECT member_name
FROM FamilyMembers
WHERE birthday = ALL (
		SELECT MIN(birthday)
		FROM FamilyMembers);

-- Задание 19. Определить, кто из членов семьи покупал картошку (potato).

SELECT DISTINCT status
FROM FamilyMembers
JOIN Payments ON FamilyMembers.member_id = Payments.family_member
JOIN Goods ON Payments.good = Goods.good_id
WHERE good_name = 'potato';

-- Задание 45. Какой(ие) кабинет(ы) пользуются самым большим спросом?

SELECT classroom
FROM Schedule
GROUP BY classroom
HAVING COUNT(classroom) =
(SELECT COUNT(classroom) 
FROM Schedule 
GROUP BY classroom
ORDER BY 1 DESC
LIMIT 1);

-- Задание 49. Какой процент обучающихся учится в 10 A классе ?

SELECT COUNT(*) * 100 /(SELECT COUNT(student) FROM Student_in_class)
AS percent
FROM Student
JOIN Student_in_class ON Student.id=Student_in_class.student 
WHERE Student_in_class.class=7;

-- Задание 50. Какой процент обучающихся родился в 2000 году? Результат округлить до целого в меньшую сторону.

SELECT FLOOR(COUNT(*) * 100 /(SELECT COUNT(student) 
FROM Student_in_class))
AS percent
FROM Student
JOIN Student_in_class ON Student.id=Student_in_class.student 
WHERE birthday LIKE '2000%' или WHERE YEAR(birthday) = 2000;
