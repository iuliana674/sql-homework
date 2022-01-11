CREATE TABLE projects(
    project_id NUMBER(12) PRIMARY KEY,
    project_description VARCHAR2(1024) NOT NULL,
    project_investments NUMBER(10),
    project_revenue NUMBER(10),
    CONSTRAINT project_description_length CHECK ( LENGTH(project_description) > 10 ),
    CONSTRAINT project_investments_min CHECK ( project_investments > 0)
);

CREATE SEQUENCE pr_seq START WITH 1 INCREMENT BY 3;

ALTER TABLE projects
    MODIFY project_id DEFAULT pr_seq.nextval;

UPDATE projects SET project_investments =
    CASE WHEN (project_investments < 500) THEN 0
         WHEN (project_investments >= 500 AND project_investments < 1500) THEN 1000
         WHEN (project_investments >= 1500 AND project_investments < 2500) THEN 2000
    END;

CREATE TABLE project_employee(
    project_id NUMBER(12),
    employee_id NUMBER(6),
    nr_of_hours NUMBER(3) NOT NULL,
    CONSTRAINT pr_em_pk PRIMARY KEY (project_id, employee_id)
);

ALTER TABLE project_employee
    ADD CONSTRAINT pr_fk FOREIGN KEY (project_id)
        REFERENCES projects (project_id);

ALTER TABLE project_employee
    ADD CONSTRAINT em_fk FOREIGN KEY (employee_id)
        REFERENCES EMPLOYEES (EMPLOYEE_ID);

COMMENT ON TABLE projects IS 'Projects table. Contains data about projects.';
COMMENT ON COLUMN projects.project_id IS
    'Primary key of employees table.';
COMMENT ON COLUMN projects.project_description IS
    'Contains the description of the project. Length must be greater than 10.';
COMMENT ON COLUMN projects.project_investments IS
    'Contains the amount of money invested. Must be greater than 0';
COMMENT ON COLUMN projects.project_investments IS
    'Contains the revenue from the project.';

COMMENT ON TABLE project_employee IS 'Project_employee  table.';
COMMENT ON COLUMN project_employee.project_id IS
    'Part of primary key of project_employee table. Referencing project table.';
COMMENT ON COLUMN project_employee.employee_id IS
    'Part of primary key of project_employee table. Referencing employee table';
COMMENT ON COLUMN project_employee.nr_of_hours IS
    'Number of hours worked by an employee to a project.';
