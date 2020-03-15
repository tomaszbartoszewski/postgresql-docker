CREATE TABLE car (
    id serial PRIMARY KEY,
    make varchar(50),
    model varchar(50)
);

CREATE TABLE person_car (
    person_id integer
    CONSTRAINT person_car_person_id__fk
    REFERENCES person(id),
    car_id integer
    CONSTRAINT person_car_car_id__fk
    REFERENCES car(id)
);