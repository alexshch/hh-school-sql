SELECT cv.cv_id, array_agg(c.specialization_id)
FROM cv JOIN cv_specialization c ON cv.cv_id = c.cv_id
LEFT JOIN response r on cv.cv_id = r.cv_id
LEFT JOIN vacancy v on r.vacancy_id = v.vacancy_id
LEFT JOIN vacancy_body vb on v.vacancy_body_id = vb.vacancy_body_id
LEFT JOIN vacancy_body_specialization vbs on v.vacancy_body_id = vbs.vacancy_body_id
GROUP BY cv.cv_id;