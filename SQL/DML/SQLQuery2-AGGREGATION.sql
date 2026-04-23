--SQLQuery2-AGGREGATION.sql
--COUNT - количество записей;
--SUM   - сумма значений в разных записях;
--AVG   - среднее-арифметическое значений;
--MIN   - минимальное значение;
--MAX   - максимальное значение;
--SELECT
USE P_421_Import;

--SELECT COUNT(*) FROM Directions;

--SELECT
--		[Направление обучения]	=	direction_name,
--		[Количество групп]		=	COUNT(group_id)
--FROM	Groups,Directions
--WHERE	direction=direction_id
--GROUP BY direction_name
--;

--SELECT
--		[Группа]				=	group_name,
--		[Количество студентов]	=	COUNT(stud_id)
--FROM	Students,Groups
--WHERE	[group]=group_id
--GROUP BY group_name
--;

--SELECT 
--		[Студент]	=	FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name),
--		[Возраст]	=	DATEDIFF(HOUR, birth_date, GETDATE())/8766
--		--DATEDIFF(HOUR, birth_date, GETDATE())/8766 AS N'Возраст'
--FROM	Students
--WHERE	DATEDIFF(HOUR, birth_date, GETDATE())/8766 BETWEEN 20 AND 40
--ORDER BY [Возраст]

SELECT
		[Группа]				=	group_name,
		[Количество студентов]	=	(SELECT COUNT(stud_id) FROM Students WHERE [group]=group_id)
FROM	Groups
WHERE	(SELECT COUNT(stud_id) FROM Students WHERE [group]=group_id)=0
;
--(SELECT COUNT(stud_id) FROM Students, Groups WHERE [group]=group_id)