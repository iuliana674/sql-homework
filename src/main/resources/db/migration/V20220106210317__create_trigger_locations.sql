ALTER TABLE LOCATIONS ADD department_amount NUMBER(3);

COMMENT ON COLUMN LOCATIONS.department_amount IS
    'Contains the amount of departments in the location';

CREATE OR REPLACE TRIGGER add_department
AFTER INSERT OR DELETE ON DEPARTMENTS
FOR EACH ROW
BEGIN
    IF DELETING THEN
        UPDATE LOCATIONS SET LOCATIONS.department_amount = LOCATIONS.department_amount - 1
            WHERE LOCATION_ID = :OLD.LOCATION_ID;
    END IF;
    IF INSERTING THEN
        UPDATE LOCATIONS SET LOCATIONS.department_amount = LOCATIONS.department_amount + 1
            WHERE LOCATION_ID = :NEW.LOCATION_ID;
    END IF;
END;
