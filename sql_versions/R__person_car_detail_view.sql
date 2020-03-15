CREATE OR REPLACE VIEW person_car_detail AS
SELECT p.first_name,
       p.last_name,
       c.make AS car_make,
       c.model AS car_model
FROM person p
INNER JOIN person_car pc ON pc.person_id = p.id
INNER JOIN car c ON c.id = pc.car_id;