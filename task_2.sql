INSERT INTO vacancy (creation_time, expire_time, employer_id, disabled, visible, area_id)
SELECT
    -- random in last 5 years
    now()-((3 +  random() * 5) * 365 * 24 * 3600) * '1 second'::interval AS creation_time,
    now()-(random() * 365 * 24 * 3600 * 3) * '1 second'::interval AS expire_time,
    (random() * 1000000)::int AS employer_id,
    (random() > 0.5) AS disabled,
    (random() > 0.5) AS visible,
    (random() * 1000)::int AS area_id
FROM generate_series(1, 10000) AS g(i);

INSERT INTO vacancy_body(
    company_name, name, text, area_id, address_id, work_experience, 
    compensation_from, compensation_to, test_solution_required,
    work_schedule_type, employment_type, compensation_gross
)
SELECT 
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 50 + i % 10)::integer)) AS company_name,

    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 50 + i % 10)::integer)) AS name,

    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 50 + i % 10)::integer)) AS text,

    (random() * 1000)::int AS area_id,
    (random() * 50000)::int AS address_id,
	(random() * 6)::int AS work_experience,    
    25000 + (random() * 150000)::int AS compensation_from,
    25000 + (random() * 150000)::int AS compensation_to,
    (random() > 0.5) AS test_solution_required,
    floor(random() * 5)::int AS work_schedule_type,
    floor(random() * 5)::int AS employment_type,
    (random() > 0.5) AS compensation_gross
FROM generate_series(1, 10000) AS g(i);


UPDATE vacancy SET vacancy_body_id=vacancy_id;

-- Delete invalid records
DELETE FROM vacancy_body WHERE vacancy_body_id IN (SELECT vacancy_body_id FROM vacancy WHERE expire_time <= creation_time);

INSERT INTO employee(
    first_name, last_name,
    gender, date_of_birth
)
SELECT
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 10 + i % 10)::integer)) AS first_name,
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 10 + i % 10)::integer)) AS last_name,
    floor(random() * 3)::int AS gender,
    -- random in last 38 years over 18
    now()-((18 + random()*20) * 365 * 24 * 3600) * '1 second'::interval AS date_of_birth    
FROM generate_series(1, 10000) AS g(i);

INSERT INTO cv(
    employee_id, title, text, compensation, first_job, work_schedule_type, employment_type, creation_time, visible
)
SELECT 
    (1 + random() * 9999)::int AS employee_id,
     (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 50 + i % 10)::integer)) AS title,    
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 50 + i % 10)::integer)) AS text,
    25000 + (random() * 150000)::int AS compensation,
     (random() > 0.5) AS first_job,
     floor(random() * 5)::int AS work_schedule_type,
     floor(random() * 5)::int AS employment_type,    
    now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS creation_time,
    (random() > 0.5) AS visible
FROM generate_series(1, 100000) AS g(i);

INSERT INTO response (vacancy_id, cv_id, response_time) 
SELECT
    ((1 + random() * 10000 + i % 10)) AS vacancy_id,
    (1 + random() * 100000 + i % 10)::int AS cv_id,
    now()-((3 +  random() * 5) * 365 * 24 * 3600) * '1 second'::interval AS response_time
FROM generate_series(1, 50000) AS g(i);

DELETE FROM response WHERE vacancy_id NOT IN (SELECT vacancy_id FROM vacancy);
-- DELETE FROM response WHERE vacancy_id IN (
--     SELECT vacancy_id FROM vacancy v JOIN response r ON v.vacancy_id = r.vacancy_id
-- WHERE r.response_time < v.creation_time);

INSERT INTO cv_specialization (
    cv_id, specialization_id
) SELECT 
    i % 100000 AS cv_id,
    floor(1 + random() * 20)::int AS specialization_id
FROM generate_series(1, 300000) AS g(i);

INSERT INTO vacancy_body_specialization (
    vacancy_body_id, specialization_id
) SELECT 
    i % 10000 AS vacancy_body_id,
    floor(1 + random() * 20)::int AS specialization_id
FROM generate_series(1, 30000) AS g(i);