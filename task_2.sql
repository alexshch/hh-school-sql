INSERT INTO vacancy (creation_time, expire_time, employer_id, disabled, visible, area_id)
SELECT
    -- random in last 5 years
    now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS creation_time,
    now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS expire_time,
    (random() * 1000000)::int AS employer_id,
    (random() > 0.5) AS disabled,
    (random() > 0.5) AS visible,
    (random() * 1000)::int AS area_id
FROM generate_series(1, 100) AS g(i);

-- Delete invalid records
DELETE FROM vacancy WHERE expire_time <= creation_time;

INSERT INTO vacancy_body(
    company_name, name, text, area_id, address_id, work_experience, 
    compensation_from, test_solution_required,
    work_schedule_type, employment_type, compensation_gross
)
SELECT 
    generate_series(2,4)
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 150 + i % 10)::integer)) AS company_name,

    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 25 + i % 10)::integer)) AS name,

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
    (random() > 0.5) AS test_solution_required,
    floor(random() * 5)::int AS work_schedule_type,
    floor(random() * 6)::int AS employment_type,
    (random() > 0.5) AS compensation_gross
FROM generate_series(1, 100) AS g(i);
