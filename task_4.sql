SELECT * FROM 
(SELECT
  COUNT(vacancy_id) AS vacancy_max_count,
  to_char(to_timestamp (date_part('month', creation_time)::text, 'MM'), 'TMmon') AS vacancy_max_month
FROM vacancy
GROUP BY vacancy_max_month
ORDER BY vacancy_max_count DESC LIMIT 1) AS t1,
(SELECT  COUNT(cv_id) as cv_max_count,
  to_char(to_timestamp (date_part('month', creation_time)::text, 'MM'), 'TMmon') as cv_max_month
FROM cv group by cv_max_month
ORDER BY cv_max_count DESC LIMIT 1) AS t2;
