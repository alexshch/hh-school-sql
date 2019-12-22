SELECT vb.name
FROM vacancy v LEFT JOIN response r ON v.vacancy_id = r.vacancy_id    
AND r.response_time BETWEEN v.creation_time AND v.creation_time + INTERVAL '1 week'	
JOIN vacancy_body vb ON vb.vacancy_body_id = v.vacancy_body_id
GROUP BY v.vacancy_id, vb.name
HAVING count(r.response_id) < 5
ORDER BY vb.name ASC;