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

-- Задание 20. Сколько и кто из семьи потратил на развлечения (entertainment). Вывести статус в семье, имя, сумму.

SELECT status,
	member_name,
	SUM(unit_price * amount) AS costs
FROM FamilyMembers
	JOIN Payments ON FamilyMembers.member_id = Payments.family_member
	JOIN Goods ON Payments.good = Goods.good_id
	JOIN GoodTypes ON Goods.type = GoodTypes.good_type_id
WHERE good_type_name = ('entertainment')
GROUP BY status,
	member_name;

-- Задание 21. Определить товары, которые покупали более 1 раза.

SELECT good_name
FROM Goods
	JOIN Payments ON Goods.good_id = Payments.good
GROUP BY good_name
HAVING COUNT(good) > 1;

-- Задание 22. Найти имена всех матерей (mother).

SELECT DISTINCT member_name
FROM FamilyMembers
WHERE status IN ('mother');

-- Задание 23. Найдите самый дорогой деликатес (delicacies) и выведите его стоимость.

SELECT good_name,
	unit_price
FROM Goods
	JOIN Payments ON Goods.good_id = Payments.good
WHERE type = 3
LIMIT 1;

-- Или

SELECT good_name,
	unit_price
FROM Goods
	JOIN Payments ON Goods.good_id = Payments.good
WHERE unit_price = ALL (
		SELECT MAX(unit_price)
		FROM Payments
			JOIN Goods ON Goods.good_id = Payments.good
		WHERE type = 3);

-- Задание 24. Определить кто и сколько потратил в июне 2005.

SELECT DISTINCT member_name,
	(amount * unit_price) AS costs
FROM FamilyMembers
	JOIN Payments ON member_id = family_member
WHERE MONTH(date) = '06';

--  Задание 25. Определить, какие товары не покупались в 2005 году.

SELECT DISTINCT good_name
FROM Goods
WHERE good_id NOT IN (
		SELECT good
		FROM Payments
		WHERE YEAR(date) = 2005
	);

-- Задание 26. Определить группы товаров, которые не приобретались в 2005 году.

SELECT DISTINCT good_type_name
FROM GoodTypes
	JOIN Goods ON good_type_id = type
WHERE good_type_id NOT IN (
		SELECT type
		FROM Goods
			JOIN Payments ON good_id = good
		WHERE YEAR(date) = 2005
	);

-- Задание 27. Узнать, сколько потрачено на каждую из групп товаров в 2005 году. Вывести название группы и сумму.

SELECT good_type_name,
	SUM(amount * unit_price) AS costs
FROM GoodTypes
	JOIN Goods ON good_type_id = type
	JOIN Payments ON good_id = good
WHERE YEAR(date) = '2005'
GROUP BY good_type_name;

-- Задание 28. Сколько рейсов совершили авиакомпании из Ростова (Rostov) в Москву (Moscow) ?

SELECT COUNT(*) AS count
FROM Trip
WHERE town_from = 'Rostov'
	AND town_to = 'Moscow';

-- Задание 29. Выведите имена пассажиров улетевших в Москву (Moscow) на самолете TU-134.

SELECT DISTINCT name
FROM Passenger
	JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
	JOIN Trip ON Pass_in_trip.trip = Trip.id
WHERE town_to = 'Moscow'
	AND plane = 'TU-134';

-- Задание 30. Выведите нагруженность (число пассажиров) каждого рейса (trip). Результат вывести в отсортированном виде по убыванию нагруженности.

SELECT trip,
	COUNT(*) AS count
FROM Pass_in_trip
	JOIN Passenger ON Pass_in_trip.passenger = Passenger.id
GROUP BY trip
ORDER BY 2 DESC;

-- Задание 31. Вывести всех членов семьи с фамилией Quincey.

SELECT *
FROM FamilyMembers
WHERE member_name LIKE '% Quincey';

-- Задание 32. Вывести средний возраст людей (в годах), хранящихся в базе данных. Результат округлите до целого в меньшую сторону.

SELECT FLOOR(AVG(FLOOR(DATEDIFF(NOW(), birthday) / 365))) AS age
FROM FamilyMembers;

-- Или

SELECT FLOOR(AVG((YEAR(CURRENT_DATE) - YEAR(birthday)) -1)) AS age
FROM FamilyMembers;

-- Задание 33. Найдите среднюю стоимость икры. В базе данных хранятся данные о покупках красной (red caviar) и черной икры (black caviar).

SELECT AVG(unit_price) AS cost
FROM Payments
WHERE good IN (
		SELECT good_id
		FROM Goods
		WHERE good_name LIKE '%caviar');

-- Задание 34. Сколько всего 10-ых классов.

SELECT COUNT(*) AS count
FROM class
WHERE name LIKE '10%';

-- Задание 35. Сколько различных кабинетов школы использовались 2.09.2019 в образовательных целях ?

SELECT COUNT(classroom) AS count
FROM Schedule
WHERE date = '2019-09-02';

-- Задание 36. Выведите информацию об обучающихся живущих на улице Пушкина (ul. Pushkina)?

SELECT *
FROM Student
WHERE address LIKE 'ul. Pushkina%';

-- Задание 37. Сколько лет самому молодому обучающемуся ?

SELECT MIN((YEAR(CURRENT_DATE) - YEAR(birthday) -1)) AS year
FROM Student;

-- Задание 38. Сколько Анн (Anna) учится в школе ?

SELECT COUNT(first_name) AS count
FROM student
WHERE first_name LIKE 'Anna';

-- Задание 39. Сколько обучающихся в 10 B классе ?

SELECT COUNT(student) AS count
FROM Student_in_class
WHERE class = 6;

-- Задание 40. Выведите название предметов, которые преподает Ромашкин П.П. (Romashkin P.P.) ?

SELECT name AS subjects
FROM Subject
	JOIN Schedule ON Subject.id = Schedule.subject
	JOIN Teacher ON Schedule.teacher = Teacher.id
WHERE last_name LIKE 'Romashkin';

-- Задание 41. Во сколько начинается 4-ый учебный предмет по расписанию ?

SELECT start_pair
FROM Timepair
WHERE id = 4;

-- Задание 42. Сколько времени обучающийся будет находиться в школе, учась со 2-го по 4-ый уч. предмет ?

SELECT TIMEDIFF(
		(	SELECT end_pair
			FROM Timepair
			WHERE id = 4),
		(   SELECT start_pair
			FROM Timepair
			WHERE id = 2)) 
AS time
FROM Timepair
GROUP BY time;

-- Задание 43. Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). Отcортируйте преподавателей по фамилии.

SELECT last_name
FROM Teacher
	JOIN Schedule ON Teacher.id = Schedule.teacher
	JOIN subject ON Schedule.subject = Subject.id
WHERE Subject.name LIKE 'Physical Culture'
ORDER BY last_name;

-- Задание 44. Найдите максимальный возраст (колич. лет) среди обучающихся 10 классов ?

SELECT MAX(YEAR(CURRENT_DATE) - YEAR(birthday) -1) AS max_year
FROM Student;

-- Или

SELECT MAX(YEAR(CURRENT_DATE) - YEAR(birthday)) AS max_year
FROM Student
	JOIN Student_in_class ON Student.id = Student_in_class.student
	JOIN Class ON Student_in_class.class = Class.id
WHERE Class.name LIKE '10%';

-- Или

SELECT MAX(YEAR(CURRENT_DATE) - YEAR(birthday)) AS max_year
FROM Student
	JOIN Student_in_class ON Student.id = Student_in_class.student
	JOIN Class ON Student_in_class.class = Class.id
WHERE Class.id BETWEEN 6 AND 7;

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

-- Задание 46. В каких классах введет занятия преподаватель "Krauze" ?

SELECT DISTINCT name
FROM Class AS cl
	JOIN Schedule AS sch ON cl.id = sch.class
	JOIN teacher AS t ON sch.teacher = t.id
WHERE last_name LIKE 'Krauze';

-- Задание 47. Сколько занятий провел Krauze 30 августа 2019 г.?

SELECT COUNT(class) AS count
FROM Schedule
	JOIN Teacher ON Schedule.teacher = Teacher.id
WHERE last_name LIKE 'Krauze'
	AND Schedule.date LIKE '2019-08-30%';

-- Задание 48. Выведите заполненность классов в порядке убывания.

SELECT name,
	COUNT(Student_in_class.student) AS count
FROM Class
	JOIN Student_in_class ON Class.id = Student_in_class.class
GROUP BY Class.id
ORDER BY 2 DESC;

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

-- Задание 53. Измените имя "Andie Quincey" на новое "Andie Anthony".

UPDATE FamilyMembers
SET member_name = 'Andie Anthony'
WHERE member_id = 3;

--  Задание 65. Необходимо вывести рейтинг для комнат, которые хоть раз арендовали, как среднее значение рейтинга отзывов округленное до целого вниз.

SELECT room_id,
	FLOOR(AVG(rating)) AS rating
FROM Reservations AS r
	JOIN Reviews AS re ON r.id = re.reservation_id
GROUP BY room_id
ORDER BY 1;

-- Задание 66. Вывести список комнат со всеми удобствами (наличие ТВ, интернета, кухни и кондиционера), а также общее количество дней и сумму за все дни аренды каждой из таких комнат.

SELECT home_type,
	address,
	IFNULL(SUM(TIMESTAMPDIFF(day, start_date, end_date)), 0) AS days,
	IFNULL(SUM(total), 0) AS total_fee
FROM Rooms AS ro
	LEFT JOIN Reservations AS re 
	ON ro.id = re.room_id
WHERE has_tv = 1
	AND has_internet = 1
	AND has_kitchen = 1
	AND has_air_con = 1
GROUP BY ro.id;

-- Задание 72. Выведите среднюю стоимость бронирования для комнат, которых бронировали хотя бы один раз. Среднюю стоимость необходимо округлить до целого значения вверх.

SELECT room_id,
	CEILING(AVG(price)) AS avg_price
FROM Reservations
GROUP BY room_id
HAVING COUNT(room_id) >= 1;

-- Задание 73. Выведите id тех комнат, которые арендовали нечетное количество раз.

SELECT room_id,
	COUNT(room_id) AS count
FROM Reservations
GROUP BY room_id
HAVING MOD (COUNT(room_id), 2) = 1
ORDER BY room_id;
