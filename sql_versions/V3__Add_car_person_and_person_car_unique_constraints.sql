ALTER TABLE car ADD CONSTRAINT car_make_model_key UNIQUE (make, model);
ALTER TABLE person ADD CONSTRAINT person_first_name_last_name_key UNIQUE (first_name, last_name);
ALTER TABLE person_car ADD CONSTRAINT person_person_id_car_id_key UNIQUE (person_id, car_id);
