CREATE TRIGGER pay_before_ship
BEFORE INSERT ON shipment
FOR EACH ROW
WHEN new.id NOT IN (
        SELECT id
        FROM payment_credit_card
        UNION
        SELECT id
        FROM payment_mb_way
)
BEGIN
        SELECT RAISE(ABORT, 'ERROR: Order must be payed before being shipped!');
END;

