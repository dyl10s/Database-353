-- File: companyDML-a-solution  
-- SQL/DML HOMEWORK (on the COMPANY database)
/*
Every query is worth 2 point. There is no partial credit for a
partially working query - think of this hwk as a large program and each query is a small part of the program.
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Download the script file company.sql and use it to create your COMPANY database.
-- Dowlnoad the file companyDBinstance; it is provided for your convenience when checking the results of your queries.
(B)
Implement the queries below by ***editing this file*** to include
your name and your SQL code in the indicated places.   
--
(C)
IMPORTANT:
-- Don't use views
-- Don't use inline queries in the FROM clause - see our class notes.
--
(D)
After you have written the SQL code in the appropriate places:
** Run this file (from the command line in sqlplus).
** Print the resulting spooled file (companyDML-a.out) and submit the printout in class on the due date.
--
**** Note: you can use Apex to develop the individual queries. However, you ***MUST*** run this file from the command line as just explained above and then submit a printout of the spooled file. Submitting a printout of the webpage resulting from Apex will *NOT* be accepted.
--
*/
-- Please don't remove the SET ECHO command below.
SPOOL companyDML-a.sql
SET ECHO ON
-- ---------------------------------------------------------------
-- 
-- Name: Dylan Strohschein
--
-- ------------------------------------------------------------
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10A)
Find the ssn and last name of every employee who doesn't have a  supervisor, or his last name contains at least two occurences of the letter 'a'. Sort the results by ssn.
*/
SELECT ssn, lname FROM Employee 
WHERE
super_ssn IS NULL OR
lname LIKE '%a%a%'
ORDER BY ssn;
--
-- JOINING 3 TABLES ------------------------------
-- 
/*(11A)
For every employee who works more than 30 hours on any project: Find the ssn, lname, project number, project name, and numer of hours. Sort the results by ssn.
*/
SELECT e.ssn, e.lname, p.pnumber, p.pname, wo.hours FROM Employee e
LEFT JOIN works_on wo ON wo.essn = e.ssn
LEFT JOIN project p ON p.pnumber = wo.pno
WHERE wo.hours > 30
ORDER BY e.ssn;
--
-- JOINING 3 TABLES ---------------------------
--
/*(12A)
Write a query that consists of one block only.
For every employee who works on a project that is not controlled by the department he works for: Find the employee's lname, the department he works for, the project number that he works on, and the number of the department that controls that project. Sort the results by lname.
*/
SELECT e.lname, d.dnumber, wo.pno, p.dnum FROM Employee e
LEFT JOIN works_on wo ON wo.essn = e.ssn
LEFT JOIN project p ON p.pnumber = wo.pno
LEFT JOIN department d ON d.dnumber = e.dno
WHERE p.dnum != e.dno
ORDER BY lname;
--
-- JOINING 4 TABLES -------------------------
--
/*(13A)
For every employee who works for more than 20 hours on any project that is located in the same location as his department: Find the ssn, lname, project number, project location, department number, and department location.Sort the results by lname
*/
SELECT e.ssn, e.lname, p.pnumber, dlp.dlocation, e.dno, dle.dlocation FROM employee e
LEFT JOIN works_on wo ON wo.essn = e.ssn
LEFT JOIN project p ON p.pnumber = wo.pno
LEFT JOIN dept_locations dle ON dle.dnumber = e.dno
LEFT JOIN dept_locations dlp ON dlp.dnumber = p.dnum
WHERE (wo.hours > 20 AND dle.dlocation = dlp.dlocation)
ORDER BY e.lname;
--
-- SELF JOIN -------------------------------------------
-- 
/*(14A)
Write a query that consists of one block only.
For every employee whose salary is less than 70% of his immediate supervisor's salary: Find his ssn, lname, salary; and his supervisor's ssn, lname, and salary. Sort the results by ssn.  
*/
SELECT e.ssn, e.lname, e.salary FROM employee e
LEFT JOIN employee es ON es.ssn = e.super_ssn
WHERE (e.salary / es.salary < .7)
ORDER BY e.ssn;
--
-- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE -------------------
--
/*(15A)
For projects located in Houston: Find pairs of last names such that the two employees in the pair work on the same project. Remove duplicates. Sort the result by the lname in the left column in the result. 
*/
SELECT DISTINCT e1.lname, e2.lname FROM employee e1
LEFT JOIN employee e2 ON e1.ssn != e2.ssn
LEFT JOIN works_on wo1 ON wo1.essn = e1.ssn
LEFT JOIN works_on wo2 ON wo2.essn = e2.ssn
LEFT JOIN project p ON p.pnumber = wo1.pno AND p.plocation = 'Houston'
WHERE wo1.pno = wo2.pno AND e1.lname < e2.lname;
--
------------------------------------
--
/*(16A) Hint: A NULL in the hours column should be considered as zero hours.
Find the ssn, lname, and the total number of hours worked on projects for every employee whose total is less than 40 hours. Sort the result by lname
*/ 
SELECT e.ssn, e.lname, SUM(wo.hours) FROM employee e
LEFT JOIN works_on wo ON wo.essn = e.ssn
HAVING SUM(wo.hours) < 40
GROUP BY e.ssn, e.lname
ORDER BY e.lname;
--
------------------------------------
-- 
/*(17A)
For every project that has more than 2 employees working on it: 
Find the project number, project name, number of employees working on it, 
and the total number of hours worked by all employees on that project. 
Sort the results by project number.
*/ 
SELECT p.pnumber, p.pname, COUNT(wo.essn), SUM(wo.hours) FROM project p
LEFT JOIN works_on wo ON wo.pno = p.pnumber
HAVING COUNT(wo.essn) > 2
GROUP BY p.pnumber, p.pname
ORDER BY p.pnumber;
-- 
-- CORRELATED SUBQUERY --------------------------------
--
/*(18A)
For every employee who has the highest salary in his department: 
Find the dno, ssn, lname, and salary . 
Sort the results by department number.
*/
SELECT e.dno, e.ssn, e.lname, e.salary FROM Department d
LEFT JOIN employee e ON e.ssn = 
                        (SELECT ssn FROM employee 
                        WHERE dno = d.dnumber 
                        ORDER BY e.salary DESC 
                        FETCH FIRST 1 ROWS ONLY)
ORDER BY e.dno;
--
-- NON-CORRELATED SUBQUERY -------------------------------
--
/*(19A)
For every employee who does not work on any project that is located in Houston: 
Find the ssn and lname. Sort the results by lname
*/
SELECT e.ssn, e.lname FROM employee e
WHERE NOT EXISTS (SELECT wo.essn FROM works_on wo
                    LEFT JOIN project p ON p.pnumber = wo.pno
                    WHERE p.plocation != 'Houston' AND 
                          p.plocation != NULL AND 
                          wo.essn = e.ssn)
ORDER BY e.lname;
--
-- DIVISION ---------------------------------------------
--
/*(20A) Hint: This is a DIVISION query
For every employee who works on every project that is located in Stafford: 
Find the ssn and lname. Sort the results by lname
*/
SELECT e.ssn, e.lname FROM employee e
WHERE e.ssn ALL (SELECT wo.essn FROM project p
                LEFT JOIN works_on wo ON wo.pno = p.pnumber)

--
SET ECHO OFF
SPOOL OFF


