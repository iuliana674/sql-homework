CREATE TABLE pay(
    cardNr NUMBER(6) PRIMARY KEY,
    salary NUMBER(8, 2) NOT NULL,
    commission_pct NUMBER(2, 2)
);

CREATE SEQUENCE pay_seq INCREMENT BY 100 MAXVALUE 99990 START WITH 10000;

ALTER TABLE pay
    MODIFY cardNr DEFAULT pay_seq.nextval;

INSERT INTO pay (salary, commission_pct)
   SELECT SALARY, COMMISSION_PCT FROM EMPLOYEES;

COMMENT ON TABLE employees IS 'Pay table. It has columns transferred from employees table.';
COMMENT ON COLUMN pay.cardNr IS
    'Primary key of pay table.';
COMMENT ON COLUMN pay.salary IS
    'Contains the amount of money transferred to card. A not null column.';
COMMENT ON COLUMN pay.commission_pct IS
    'Contains the commission point of employee.';