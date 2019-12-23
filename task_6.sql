WITH T1 AS (SELECT cv.cv_id AS cv_id, array_agg(c.specialization_id) AS specs
FROM cv LEFT JOIN cv_specialization c ON cv.cv_id = c.cv_id
GROUP BY cv.cv_id)
SELECT cv_id, cv_spec, vac_specialization_id
  FROM (SELECT cv_id, cv_spec, vac_specialization_id, ROW_NUMBER() OVER (PARTITION BY cv_id ORDER BY freq DESC) AS rn
        FROM (SELECT T1.cv_id AS cv_id, T1.specs AS cv_spec, vbs.specialization_id AS vac_specialization_id, COUNT('x') AS freq
            FROM T1 LEFT JOIN response r ON T1.cv_id = r.cv_id
            LEFT JOIN vacancy v ON v.vacancy_id = r.vacancy_id
            LEFT JOIN vacancy_body vb ON vb.vacancy_body_id = v.vacancy_body_id
            LEFT JOIN vacancy_body_specialization vbs ON vbs.vacancy_body_id = vb.vacancy_body_id
    GROUP BY T1.cv_id, T1.specs, vbs.specialization_id) spec_freq) ranked_spec_freq WHERE rn = 1;