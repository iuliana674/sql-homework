-- Write a query to display:
-- 1. the first name, last name, salary, and job grade for all employees.
SELECT FIRST_NAME, LAST_NAME, SALARY, JOB_TITLE FROM employees JOIN jobs USING (JOB_ID);
-- 2. the first and last name, department, city, and state province for each employee.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_NAME, CITY, STATE_PROVINCE FROM EMPLOYEES
    JOIN DEPARTMENTS USING(DEPARTMENT_ID) JOIN LOCATIONS USING(LOCATION_ID);
-- 3. the first name, last name, department number and department name, for all employees for departments 80 or 40.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_ID, DEPARTMENT_NAME FROM  EMPLOYEES
    JOIN DEPARTMENTS USING(DEPARTMENT_ID) WHERE DEPARTMENT_ID IN (80, 40);
-- 4. those employees who contain a letter z to their first name and also display their last name, department, city, and state province.
SELECT FIRST_NAME, LAST_NAME, D.DEPARTMENT_NAME, CITY, STATE_PROVINCE c FROM EMPLOYEES
    JOIN DEPARTMENTS D on EMPLOYEES.DEPARTMENT_ID = D.DEPARTMENT_ID
        JOIN LOCATIONS L on D.LOCATION_ID = L.LOCATION_ID WHERE FIRST_NAME LIKE '%z%';
-- 5. the first and last name and salary for those employees who earn less than the employee earn whose number is 182.
SELECT FIRST_NAME, LAST_NAME, SALARY FROM EMPLOYEES
    WHERE SALARY < (SELECT SALARY FROM EMPLOYEES WHERE EMPLOYEE_ID = 182);
-- 6. the first name of all employees including the first name of their manager.
SELECT E.FIRST_NAME, M.FIRST_NAME FROM EMPLOYEES E JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID;
-- 7. the first name of all employees and the first name of their manager including those who does not working under any manager.
SELECT E.FIRST_NAME, M.FIRST_NAME FROM EMPLOYEES E LEFT JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID;
-- 8. the details of employees who manage a department.
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID IN (SELECT MANAGER_ID FROM EMPLOYEES);
-- 9. the first name, last name, and department number for those employees who works in the same department as the employee who holds the last name as Taylor.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_ID FROM EMPLOYEES WHERE DEPARTMENT_ID
    IN (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE LAST_NAME = 'Taylor');
--10. the department name and number of employees in each of the department.
SELECT DEPARTMENT_NAME, COUNT(*) FROM EMPLOYEES
    JOIN DEPARTMENTS USING (DEPARTMENT_ID) GROUP BY DEPARTMENT_NAME;
--11. the name of the department, average salary and number of employees working in that department who got commission.
SELECT DEPARTMENT_ID, ROUND(AVG(SALARY), 2), COUNT(*) FROM EMPLOYEES
    JOIN DEPARTMENTS USING (DEPARTMENT_ID)
        WHERE COMMISSION_PCT IS NOT NULL GROUP BY DEPARTMENT_ID;
--12. job title and average salary of employees.
SELECT JOB_TITLE, AVG(SALARY) FROM EMPLOYEES JOIN JOBS USING (JOB_ID) GROUP BY JOB_TITLE;
--13. the country name, city, and number of those departments where at least 2 employees are working.
SELECT COUNTRY_NAME, CITY, DEPARTMENT_ID FROM EMPLOYEES JOIN DEPARTMENTS D USING (DEPARTMENT_ID)
    JOIN LOCATIONS USING (LOCATION_ID) JOIN COUNTRIES USING (COUNTRY_ID)
        GROUP BY DEPARTMENT_ID, CITY, COUNTRY_NAME HAVING COUNT(*) >= 2;
--14. the employee ID, job name, number of days worked in for all those jobs in department 80.
SELECT E.EMPLOYEE_ID, J.JOB_TITLE, END_DATE - START_DATE NrOfDaysWorked FROM JOB_HISTORY H
    JOIN EMPLOYEES E ON H.EMPLOYEE_ID = E.EMPLOYEE_ID
        JOIN JOBS J ON H.JOB_ID = J.JOB_ID WHERE H.DEPARTMENT_ID = 80;
--15. the name ( first name and last name ) for those employees who gets more salary than the employee whose ID is 163.
SELECT FIRST_NAME ||  ' ' || LAST_NAME Full_Name FROM EMPLOYEES
    WHERE SALARY > (SELECT SALARY FROM EMPLOYEES WHERE EMPLOYEE_ID = 163);
--16. the employee id, employee name (first name and last name ) for all employees who earn more than the average salary.
SELECT EMPLOYEE_ID, FIRST_NAME ||  ' ' || LAST_NAME Full_Name FROM EMPLOYEES
    WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES);
--17. the employee name ( first name and last name ), employee id and salary of all employees who report to Payam.
SELECT FIRST_NAME ||  ' ' || LAST_NAME Full_Name, EMPLOYEE_ID, SALARY FROM EMPLOYEES
    WHERE MANAGER_ID = (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Payam');
--18. the department number, name ( first name and last name ), job and department name for all employees in the Finance department.
SELECT DEPARTMENT_ID, FIRST_NAME ||  ' ' || LAST_NAME Full_Name, JOB_TITLE, DEPARTMENT_NAME FROM EMPLOYEES
    JOIN DEPARTMENTS USING (DEPARTMENT_ID) JOIN JOBS USING (JOB_ID) WHERE DEPARTMENT_NAME = 'Finance';
--19. all the information of an employee whose id is any of the number 134, 159 and 183.
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID IN (134, 159, 183);
--20. all the information of the employees whose salary is within the range of smallest salary and 2500.
SELECT * FROM EMPLOYEES WHERE SALARY BETWEEN (SELECT MIN(SALARY) FROM EMPLOYEES) AND 2500;
--21. all the information of the employees who does not work in those departments where some employees works whose id within the range 100 and 200.
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID NOT IN (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE
    DEPARTMENT_ID IS NOT NULL AND EMPLOYEE_ID BETWEEN 100 AND 200);
--22. all the information for those employees whose id is any id who earn the second highest salary.
SELECT * FROM EMPLOYEES WHERE SALARY = (SELECT MIN(SALARY) FROM
    (SELECT SALARY FROM EMPLOYEES ORDER BY SALARY DESC FETCH FIRST 2 ROWS ONLY ));
--23. the employee name( first name and last name ) and hire date for all employees in the same department as Clara. Exclude Clara.
SELECT FIRST_NAME ||  ' ' || LAST_NAME Full_Name, HIRE_DATE FROM EMPLOYEES
    WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Clara') AND FIRST_NAME != 'Clara';
--24. the employee number and name( first name and last name ) for all employees who work in a department with any employee whose name contains a T.
SELECT EMPLOYEE_ID, FIRST_NAME ||  ' ' || LAST_NAME Full_Name FROM EMPLOYEES WHERE DEPARTMENT_ID IN
    (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME LIKE 'T%');
--25. full name(first and last name), job title, starting and ending date of last jobs for those employees which worked without a commission percentage.
SELECT FIRST_NAME ||  ' ' || LAST_NAME Full_Name, JOB_TITLE, START_DATE, END_DATE
    FROM EMPLOYEES E JOIN JOBS USING (JOB_ID) JOIN (SELECT EMPLOYEE_ID, MAX(START_DATE) START_DATE, MAX(END_DATE) END_DATE
            FROM JOB_HISTORY J GROUP BY EMPLOYEE_ID) USING (EMPLOYEE_ID) WHERE COMMISSION_PCT IS NULL;
--26. the employee number, name( first name and last name ), and salary for all employees who earn more than the average salary and who work in a department with any employee with a J in their name.
SELECT EMPLOYEE_ID, FIRST_NAME ||  ' ' || LAST_NAME FullName, SALARY FROM EMPLOYEES
    WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES) AND DEPARTMENT_ID IN
        (SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME LIKE 'J%');
--27. the employee number, name( first name and last name ) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN.
SELECT EMPLOYEE_ID, FIRST_NAME ||  ' ' || LAST_NAME FullName, J.JOB_TITLE FROM EMPLOYEES
    JOIN JOBS J on EMPLOYEES.JOB_ID = J.JOB_ID WHERE
        SALARY < ANY(SELECT SALARY FROM EMPLOYEES WHERE JOB_ID = 'MK_MAN');
--28. the employee number, name( first name and last name ) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN. Exclude Job title MK_MAN.
SELECT EMPLOYEE_ID, FIRST_NAME ||  ' ' || LAST_NAME FullName, J.JOB_TITLE FROM EMPLOYEES
    JOIN JOBS J on EMPLOYEES.JOB_ID = J.JOB_ID WHERE
        SALARY < ANY(SELECT SALARY FROM EMPLOYEES WHERE JOB_ID = 'MK_MAN')
            AND J.JOB_ID != 'MK_MAN';
--29. all the information of those employees who did not have any job in the past.
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID FROM JOB_HISTORY);
--30. the employee number, name( first name and last name ) and job title for all employees whose salary is more than any average salary of any department.
SELECT EMPLOYEE_ID, FIRST_NAME ||  ' ' || LAST_NAME Full_Name, J.JOB_TITLE FROM EMPLOYEES
    JOIN JOBS J on EMPLOYEES.JOB_ID = J.JOB_ID WHERE
        SALARY > ANY(SELECT AVG(SALARY) FROM EMPLOYEES GROUP BY DEPARTMENT_ID);
--31. the employee id, name ( first name and last name ) and the job id column with a modified title SALESMAN for those employees whose job title is ST_MAN and DEVELOPER for whose job title is IT_PROG.
SELECT EMPLOYEE_ID, FIRST_NAME ||  ' ' || LAST_NAME Full_Name,
       CASE JOB_ID
            WHEN 'ST_MAN' THEN 'SALESMAN'
            WHEN 'IT_PROG' THEN 'DEVELOPER'
            ELSE JOB_ID
       END AS JOB_ID
FROM EMPLOYEES;
--32. the employee id, name ( first name and last name ), salary and the SalaryStatus column with a title HIGH and LOW respectively for those employees whose salary is more than and less than the average salary of all employees.
SELECT EMPLOYEE_ID, FIRST_NAME ||  ' ' || LAST_NAME Full_Name, SALARY,
       CASE WHEN SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES) THEN 'HIGH'
           ELSE 'LOW' END AS Salary_Status
FROM EMPLOYEES;
--33. the employee id, name ( first name and last name ), SalaryDrawn, AvgCompare (salary - the average salary of all employees)
    -- and the SalaryStatus column with a title HIGH and LOW respectively for those employees whose salary is more than and less than
    -- the average salary of all employees.
SELECT EMPLOYEE_ID, FIRST_NAME ||  ' ' || LAST_NAME Full_Name, SALARY,
    ROUND(SALARY - (SELECT AVG(SALARY) FROM EMPLOYEES), 2) Avg_Compare,
       CASE WHEN SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES) THEN 'HIGH'
           ELSE 'LOW' END Salary_Status
FROM EMPLOYEES;
--34. all the employees who earn more than the average and who work in any of the IT departments.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_NAME FROM EMPLOYEES JOIN DEPARTMENTS USING(DEPARTMENT_ID)
    WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES) AND DEPARTMENT_NAME LIKE 'IT%';
--35. who earns more than Mr. Ozer.
SELECT * FROM EMPLOYEES WHERE SALARY > (SELECT SALARY FROM EMPLOYEES WHERE LAST_NAME = 'Ozer');
--36. which employees have a manager who works for a department based in the US.
SELECT * FROM EMPLOYEES WHERE MANAGER_ID IN
    (SELECT EMPLOYEE_ID FROM EMPLOYEES JOIN DEPARTMENTS USING(DEPARTMENT_ID)
        JOIN LOCATIONS USING (LOCATION_ID) WHERE COUNTRY_ID = 'US');
--37. the names of all employees whose salary is greater than 50% of their department’s total salary bill.
SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES P WHERE SALARY >
    (SELECT 0.5 * SUM(SALARY) FROM EMPLOYEES E WHERE E.DEPARTMENT_ID = P.DEPARTMENT_ID);
--38. the employee id, name ( first name and last name ), salary, department name and city for all
--the employees who gets the salary as the salary earn by the employee which is maximum within the joining person January 1st, 2002 and December 31st, 2003.  
SELECT EMPLOYEE_ID, FIRST_NAME ||  ' ' || LAST_NAME Full_Name, SALARY, DEPARTMENT_NAME, CITY
    FROM EMPLOYEES JOIN DEPARTMENTS USING (DEPARTMENT_ID) JOIN LOCATIONS USING (LOCATION_ID)
        WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEES WHERE HIRE_DATE BETWEEN '01-JAN-2002' AND '31-DEC-2003');
--39. the first and last name, salary, and department ID for all those employees who earn more than the average salary and arrange the list in descending order on salary.
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID FROM EMPLOYEES
    WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES) ORDER BY SALARY DESC;
--40. the first and last name, salary, and department ID for those employees who earn more than the maximum salary of a department which ID is 40.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_ID FROM EMPLOYEES
    WHERE SALARY > (SELECT MAX(SALARY) FROM EMPLOYEES WHERE DEPARTMENT_ID  = 40);
--41. the department name and Id for all departments where they located, that Id is equal to the Id for the location where department number 30 is located.
SELECT DEPARTMENT_ID, DEPARTMENT_NAME FROM DEPARTMENTS
    WHERE LOCATION_ID = (SELECT LOCATION_ID FROM DEPARTMENTS WHERE DEPARTMENT_ID = 30);
--42. the first and last name, salary, and department ID for all those employees who work in that department where the employee works who hold the ID 201.
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID FROM EMPLOYEES
    WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 201);
--43. the first and last name, salary, and department ID for those employees whose salary is equal to the salary of the employee who works in that department which ID is 40.
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID FROM EMPLOYEES
    WHERE SALARY = (SELECT SALARY FROM EMPLOYEES WHERE DEPARTMENT_ID = 40);
--44. the first and last name, salary, and department ID for those employees who earn more than the minimum salary of a department which ID is 40.
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID FROM EMPLOYEES
    WHERE SALARY > (SELECT MIN(SALARY) FROM EMPLOYEES WHERE DEPARTMENT_ID = 40);
--45. the first and last name, salary, and department ID for those employees who earn less than the minimum salary of a department which ID is 70.
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID FROM EMPLOYEES
    WHERE SALARY < (SELECT MIN(SALARY) FROM EMPLOYEES WHERE DEPARTMENT_ID = 70);
--46. the first and last name, salary, and department ID for those employees who earn less than the average salary, and also work at the department where the employee Laura is working as a first name holder.
SELECT EMPLOYEE_ID, FIRST_NAME ||  ' ' || LAST_NAME Full_Name, SALARY, DEPARTMENT_NAME
    FROM EMPLOYEES JOIN DEPARTMENTS USING (DEPARTMENT_ID) WHERE SALARY < (SELECT AVG(SALARY) FROM EMPLOYEES) AND
        DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Laura');
--47. the full name (first and last name) of manager who is supervising 4 or more employees.
SELECT FIRST_NAME ||  ' ' || LAST_NAME Full_Name FROM EMPLOYEES M WHERE
    (SELECT COUNT(*) FROM EMPLOYEES E WHERE E.MANAGER_ID = M.EMPLOYEE_ID) >= 4;
--48. the details of the current job for those employees who worked as a Sales Representative in the past.
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM JOB_HISTORY
    JOIN JOBS USING (JOB_ID) WHERE JOB_TITLE = 'Sales Representative');
--49. all the information about those employees who earn second lowest salary of all the employees.
SELECT * FROM EMPLOYEES WHERE SALARY = (SELECT MAX(SALARY) FROM
    (SELECT SALARY FROM EMPLOYEES ORDER BY SALARY FETCH FIRST 2 ROWS ONLY));
--50. the department ID, full name (first and last name), salary for those employees who is highest salary drawer in a department.
SELECT DEPARTMENT_ID, FIRST_NAME ||  ' ' || LAST_NAME Full_Name, SALARY FROM EMPLOYEES P
    WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEES E WHERE E.DEPARTMENT_ID = P.DEPARTMENT_ID);