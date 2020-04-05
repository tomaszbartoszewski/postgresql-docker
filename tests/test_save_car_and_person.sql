BEGIN;

SELECT plan(2);

-- ##################################################
-- Test save_car_and_person for a new person and a new car
-- ##################################################

\set first_name '\'Audrey\''
\set last_name '\'Jones\''
\set car_make '\'Mitsubishi\''
\set car_model '\'Outlander PHEV\''

SELECT save_car_and_person(:first_name::varchar(50),
                           :last_name::varchar(50),
                           :car_make::varchar(50),
                           :car_model::varchar(50));

PREPARE observed_values AS
    SELECT
        p.first_name,
        p.last_name,
        c.make,
        c.model
    FROM person p
    INNER JOIN person_car pc ON pc.person_id = p.id
    INNER JOIN car c ON c.id = pc.car_id
    WHERE p.first_name = :first_name AND p.last_name = :last_name;

PREPARE expected_values AS
    SELECT
        :first_name::varchar AS first_name,
        :last_name::varchar AS last_name,
        :car_make::varchar AS make,
        :car_model::varchar AS model;

SELECT results_eq(
    'observed_values',
    'expected_values',
    'A person and a car should be in a database'
);

DEALLOCATE observed_values;
DEALLOCATE expected_values;

-- ##################################################
-- Test save_car_and_person for an existing person
-- ##################################################

\set first_name_2 '\'Jack\''
\set last_name_2 '\'Smith\''
\set car_make_2 '\'Nissan\''
\set car_model_2 '\'Leaf\''

INSERT INTO person (first_name, last_name)
    VALUES (:first_name_2, :last_name_2);

SELECT save_car_and_person(:first_name_2::varchar(50),
                           :last_name_2::varchar(50),
                           :car_make_2::varchar(50),
                           :car_model_2::varchar(50));

PREPARE observed_values AS
    SELECT
        COUNT(*) AS people_count
    FROM person p
    WHERE p.first_name = :first_name AND p.last_name = :last_name;

PREPARE expected_values AS
    SELECT
        1::bigint AS people_count;

SELECT results_eq(
    'observed_values',
    'expected_values',
    'A person should be only once in a database'
);

DEALLOCATE observed_values;
DEALLOCATE expected_values;

SELECT *
FROM finish();

ROLLBACK;