SELECT v.area_id,         
    trunc(AVG(CASE  WHEN vb.compensation_from = 0 THEN NULL
        WHEN vb.compensation_gross THEN vb.compensation_from * 0.13
        ELSE vb.compensation_from            
    END), 2) AS avg_compensation_from,
    trunc(AVG(CASE  WHEN vb.compensation_to = 0 THEN NULL
        WHEN vb.compensation_gross THEN vb.compensation_to * 0.13
        ELSE vb.compensation_to            
    END), 2) AS avg_compensation_to,
    trunc(AVG(CASE WHEN vb.compensation_from = 0 OR vb.compensation_to = 0  THEN NULL
        WHEN vb.compensation_gross THEN (vb.compensation_to + vb.compensation_from) * 0.13
        ELSE vb.compensation_to + vb.compensation_from            
    END), 2) AS avg_compensation_med
FROM vacancy v JOIN vacancy_body vb ON v.vacancy_body_id=vb.vacancy_body_id
GROUP BY v.area_id;