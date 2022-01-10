CREATE TABLE employment_logs(
    employment_log_id NUMBER(6) PRIMARY KEY,
    first_name VARCHAR2(20),
    last_name VARCHAR2(25) NOT NULL,
    employment_action VARCHAR2(5) CHECK ( employment_action IN ('HIRED', 'FIRED') ),
    employment_status_updtd_tmstmp DATE NOT NULL
);

CREATE SEQUENCE empl_logs_seq START WITH 1;

ALTER TABLE employment_logs MODIFY employment_log_id DEFAULT empl_logs_seq.nextval;

CREATE OR REPLACE TRIGGER add_employee_data
AFTER INSERT OR DELETE ON EMPLOYEES
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        add_log(:NEW.FIRST_NAME, :NEW.LAST_NAME, 'HIRED');
    END IF;
    IF DELETING THEN
        add_log(:OLD.FIRST_NAME, :OLD.LAST_NAME, 'FIRED');
    END IF;
END;

CREATE OR REPLACE PROCEDURE add_log (first_n IN VARCHAR2, last_n IN VARCHAR2,
    e_action IN VARCHAR2)
IS
BEGIN
    INSERT INTO EMPLOYMENT_LOGS (first_name, last_name,
        employment_action, employment_status_updtd_tmstmp) VALUES
            (first_n, last_n, e_action, CURRENT_DATE);
END;