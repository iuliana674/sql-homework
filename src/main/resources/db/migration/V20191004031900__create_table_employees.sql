CREATE TABLE employees
(
    employee_id    NUMBER(6) PRIMARY KEY,
    first_name     VARCHAR2(20),
    last_name      VARCHAR2(25)        NOT NULL,
    email          VARCHAR2(25) UNIQUE NOT NULL,
    phone_number   VARCHAR2(20),
    hire_date      DATE                NOT NULL,
    job_id         VARCHAR2(10)        NOT NULL,
    salary         NUMBER(8, 2),
    commission_pct NUMBER(2, 2),
    manager_id     NUMBER(6),
    department_id  NUMBER(4)           NOT NULL,
    CONSTRAINT emp_salary_min CHECK (salary > 0)
);

CREATE SEQUENCE employees_seq NOCACHE;

ALTER TABLE employees
    MODIFY employee_id DEFAULT employees_seq.nextval;

CREATE INDEX emp_name_ix ON employees (last_name, first_name);

COMMENT ON TABLE employees IS 'employees table. Contains 107 rows. References with departments,
jobs, job_history tables. Contains a self reference.';
COMMENT ON COLUMN employees.employee_id IS 'Primary key of employees table.';
COMMENT ON COLUMN employees.first_name IS 'First name of the employee. A not null column.';
COMMENT ON COLUMN employees.last_name IS 'Last name of the employee. A not null column.';
COMMENT ON COLUMN employees.email IS 'Email id of the employee';
COMMENT ON COLUMN employees.phone_number IS 'Phone number of the employee; includes country code and area code';
COMMENT ON COLUMN employees.hire_date IS 'Date when the employee started on this job. A not null column.';
COMMENT ON COLUMN employees.job_id IS 'Current job of the employee; foreign key to job_id column of the
jobs table. A not null column.';
COMMENT ON COLUMN employees.salary IS 'Monthly salary of the employee. Must be greater
than zero (enforced by constraint emp_salary_min)';
COMMENT ON COLUMN employees.commission_pct IS 'Commission percentage of the employee; Only employees in sales
department eligible for commission percentage';
COMMENT ON COLUMN employees.manager_id IS 'Manager id of the employee; has same domain as manager_id in
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';
COMMENT ON COLUMN employees.department_id IS 'Department id where employee works; foreign key to department_id
column of the departments table';
