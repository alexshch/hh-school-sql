CREATE TABLE vacancy_body (
    vacancy_body_id serial PRIMARY KEY,
    company_name varchar(150) DEFAULT ''::varchar NOT NULL,
    name varchar(220) DEFAULT ''::varchar NOT NULL,
    text text,
    area_id integer,
    address_id integer,
    work_experience integer DEFAULT 0 NOT NULL,
    compensation_from bigint DEFAULT 0,
    compensation_to bigint DEFAULT 0,
    test_solution_required boolean DEFAULT false NOT NULL,
    work_schedule_type integer DEFAULT 0 NOT NULL,
    employment_type integer DEFAULT 0 NOT NULL,
    compensation_gross boolean,
    driver_license_types varchar(5)[],
    CONSTRAINT vacancy_body_employment_type_validate CHECK ((employment_type = ANY (ARRAY[0, 1, 2, 3, 4]))),
    CONSTRAINT vacancy_body_work_schedule_type_validate CHECK ((work_schedule_type = ANY (ARRAY[0, 1, 2, 3, 4])))
);

CREATE TABLE vacancy (
    vacancy_id serial PRIMARY KEY,
    creation_time timestamp NOT NULL,
    expire_time timestamp NOT NULL,
    employer_id integer DEFAULT 0 NOT NULL,    
    disabled boolean DEFAULT false NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    vacancy_body_id integer REFERENCES vacancy_body(vacancy_body_id) ON DELETE CASCADE,
    area_id integer
);

CREATE TABLE vacancy_body_specialization (
    vacancy_body_specialization_id integer NOT NULL,
    vacancy_body_id integer DEFAULT 0 NOT NULL,
    specialization_id integer DEFAULT 0 NOT NULL
);

CREATE TABLE employee(
    employee_id serial PRIMARY KEY,
    first_name varchar(150) DEFAULT ''::varchar NOT NULL,
    last_name varchar(150) DEFAULT ''::varchar NOT NULL,
    second_name varchar(150),
    gender integer DEFAULT 0 NOT NULL,
    date_of_birth timestamp NOT NULL,
    email varchar(150) DEFAULT ''::varchar NOT NULL,
    phone varchar(100) DEFAULT ''::varchar NOT NULL,
    CONSTRAINT cv_gender_validate CHECK ((gender = ANY (ARRAY[0, 1, 2])))
);

CREATE TABLE cv (
    cv_id serial PRIMARY KEY,
    employee_id integer REFERENCES employee(employee_id),
    title varchar(150) DEFAULT ''::varchar NOT NULL,
    text text,
    compensation bigint,
    first_job boolean DEFAULT false NOT NULL,
    work_schedule_type integer DEFAULT 0 NOT NULL,
    employment_type integer DEFAULT 0 NOT NULL,
    creation_time timestamp NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    CONSTRAINT vacancy_body_employment_type_validate CHECK ((employment_type = ANY (ARRAY[0, 1, 2, 3, 4]))),
    CONSTRAINT vacancy_body_work_schedule_type_validate CHECK ((work_schedule_type = ANY (ARRAY[0, 1, 2, 3, 4])))    
);

CREATE TABLE cv_specialization (
    cv_specialization_id integer NOT NULL,
    cv_id integer REFERENCES cv(cv_id),
    specialization_id integer DEFAULT 0 NOT NULL
);

CREATE TABLE specialization (
    specialization_id serial PRIMARY KEY,
    text varchar(100) DEFAULT ''::varchar NOT NULL
);

CREATE TABLE response (
    -- vacancy_id integer REFERENCES vacancy(vacancy_id),
    vacancy_id integer,
    -- cv_id integer REFERENCES cv(cv_id)
    cv_id integer
);