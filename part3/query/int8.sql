DROP VIEW IF EXISTS employee_orders_count;
CREATE VIEW employee_orders_count AS
        SELECT employee_id as emp_id, count(*) as total_orders FROM "order"
            WHERE employee_id NOT NULL
            GROUP BY employee_id;

DROP VIEW IF EXISTS employee_type_count;
CREATE VIEW employee_type_count AS
    SELECT employee_id, type, count(*) AS num_type FROM
        (SELECT employee_id, type FROM employee JOIN "order" JOIN shipment JOIN shipment_type
            ON employee.id="order".employee_id AND "order".id=shipment.id AND shipment.shipment_type_id=shipment_type.id)
        GROUP BY employee_id, type;


SELECT employee_id, name, hourly_salary, weekly_hours, total_orders, type, num_type FROM (
    SELECT employee_id, type, max(num_type) AS num_type FROM employee_type_count
        GROUP BY employee_id)
    JOIN
    (select * from employee JOIN employee_orders_count 
        ON employee.id=emp_id
        WHERE total_orders= (
            SELECT max(total_orders) from employee_orders_count
        ))
        JOIN person
        ON employee_id=emp_id AND emp_id=person.id;
