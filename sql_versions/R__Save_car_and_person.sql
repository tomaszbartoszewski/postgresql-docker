CREATE OR REPLACE FUNCTION save_car_and_person(p_first_name varchar(50),
                                               p_last_name varchar(50),
                                               p_car_make varchar(50),
                                               p_car_model varchar(50))
RETURNS void AS
$$
BEGIN
    -- This approach to inserting increases sequence value and can have other side effects,
    -- be careful, I'm using it for simplicity here
    -- https://stackoverflow.com/a/42217872/3620779
    INSERT INTO person(first_name, last_name)
    VALUES (p_first_name, p_last_name)
    ON CONFLICT DO NOTHING;

    INSERT INTO car(make, model)
    VALUES (p_car_make, p_car_model)
    ON CONFLICT DO NOTHING;

    INSERT INTO person_car(person_id, car_id)
    SELECT p.id, c.id
    FROM person p
    CROSS JOIN car c
    WHERE p.first_name = p_first_name 
        AND p.last_name = p_last_name 
        AND c.make = p_car_make 
        AND c.model = p_car_model
    ON CONFLICT DO NOTHING;
END
$$
LANGUAGE plpgsql;