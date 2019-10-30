SQL> -- ---------------------------------------------------------------
SQL> --
SQL> -- Name: Dylan Strohschein
SQL> --
SQL> -- ------------------------------------------------------------
SQL> -- NULL AND SUBSTRINGS -------------------------------
SQL> --
SQL> /*(10A)
SQL> Find the ssn and last name of every employee who doesn't have a  supervisor, or his last name contains at least two occurences of the letter 'a'. Sort the results by ssn.
SQL> */
SQL> SELECT ssn, lname FROM Employee
  2  WHERE
  3  super_ssn IS NULL OR
  4  lname LIKE '%a%a%'
  5  ORDER BY ssn;

SSN       LNAME                                                                 
--------- ---------------                                                       
666884444 Narayan                                                               
888665555 Borg                                                                  
987654321 Wallace                                                               
987987987 Jabbar                                                                
999887777 Zelaya                                                                

SQL> --
SQL> -- JOINING 3 TABLES ------------------------------
SQL> --
SQL> /*(11A)
SQL> For every employee who works more than 30 hours on any project: Find the ssn, lname, project number, project name, and numer of hours. Sort the results by ssn.
SQL> */
SQL> SELECT e.ssn, e.lname, p.pnumber, p.pname, wo.hours FROM Employee e
  2  LEFT JOIN works_on wo ON wo.essn = e.ssn
  3  LEFT JOIN project p ON p.pnumber = wo.pno
  4  WHERE wo.hours > 30
  5  ORDER BY e.ssn;

SSN       LNAME              PNUMBER PNAME                HOURS                 
--------- --------------- ---------- --------------- ----------                 
123456789 Smith                    1 ProductX              32.5                 
666884444 Narayan                  3 ProductZ                40                 
987987987 Jabbar                  10 Computerization         35                 

SQL> --
SQL> -- JOINING 3 TABLES ---------------------------
SQL> --
SQL> /*(12A)
SQL> Write a query that consists of one block only.
SQL> For every employee who works on a project that is not controlled by the department he works for: Find the employee's lname, the department he works for, the project number that he works on, and the number of the department that controls that project. Sort the results by lname.
SQL> */
SQL> SELECT e.lname, d.dnumber, wo.pno, p.dnum FROM Employee e
  2  LEFT JOIN works_on wo ON wo.essn = e.ssn
  3  LEFT JOIN project p ON p.pnumber = wo.pno
  4  LEFT JOIN department d ON d.dnumber = e.dno
  5  WHERE p.dnum != e.dno
  6  ORDER BY lname;

LNAME              DNUMBER        PNO       DNUM                                
--------------- ---------- ---------- ----------                                
Wallace                  4         20          1                                
Wong                     5         20          1                                
Wong                     5         10          4                                

SQL> --
SQL> -- JOINING 4 TABLES -------------------------
SQL> --
SQL> /*(13A)
SQL> For every employee who works for more than 20 hours on any project that is located in the same location as his department: Find the ssn, lname, project number, project location, department number, and department location.Sort the results by lname
SQL> */
SQL> SELECT e.ssn, e.lname, p.pnumber, dlp.dlocation, e.dno, dle.dlocation FROM employee e
  2  LEFT JOIN works_on wo ON wo.essn = e.ssn
  3  LEFT JOIN project p ON p.pnumber = wo.pno
  4  LEFT JOIN dept_locations dle ON dle.dnumber = e.dno
  5  LEFT JOIN dept_locations dlp ON dlp.dnumber = p.dnum
  6  WHERE (wo.hours > 20 AND dle.dlocation = dlp.dlocation)
  7  ORDER BY e.lname;

SSN       LNAME              PNUMBER DLOCATION              DNO DLOCATION       
--------- --------------- ---------- --------------- ---------- --------------- 
987987987 Jabbar                  10 Stafford                 4 Stafford        
666884444 Narayan                  3 Houston                  5 Houston         
666884444 Narayan                  3 Bellaire                 5 Bellaire        
666884444 Narayan                  3 Sugarland                5 Sugarland       
123456789 Smith                    1 Houston                  5 Houston         
123456789 Smith                    1 Sugarland                5 Sugarland       
123456789 Smith                    1 Bellaire                 5 Bellaire        
999887777 Zelaya                  30 Stafford                 4 Stafford        

8 rows selected.

SQL> --
SQL> -- SELF JOIN -------------------------------------------
SQL> --
SQL> /*(14A)
SQL> Write a query that consists of one block only.
SQL> For every employee whose salary is less than 70% of his immediate supervisor's salary: Find his ssn, lname, salary; and his supervisor's ssn, lname, and salary. Sort the results by ssn.
SQL> */
SQL> SELECT e.ssn, e.lname, e.salary FROM employee e
  2  LEFT JOIN employee es ON es.ssn = e.super_ssn
  3  WHERE (e.salary / es.salary < .7)
  4  ORDER BY e.ssn;

SSN       LNAME               SALARY                                            
--------- --------------- ----------                                            
453453453 English              25000                                            
987987987 Jabbar               25000                                            
999887777 Zelaya               25000                                            

SQL> --
SQL> -- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE -------------------
SQL> --
SQL> /*(15A)
SQL> For projects located in Houston: Find pairs of last names such that the two employees in the pair work on the same project. Remove duplicates. Sort the result by the lname in the left column in the result.
SQL> */
SQL> SELECT DISTINCT e1.lname, e2.lname FROM employee e1
  2  LEFT JOIN employee e2 ON e1.ssn != e2.ssn
  3  LEFT JOIN works_on wo1 ON wo1.essn = e1.ssn
  4  LEFT JOIN works_on wo2 ON wo2.essn = e2.ssn
  5  LEFT JOIN project p ON p.pnumber = wo1.pno AND p.plocation = 'Houston'
  6  WHERE wo1.pno = wo2.pno AND e1.lname < e2.lname;

LNAME           LNAME                                                           
--------------- ---------------                                                 
English         Smith                                                           
Smith           Wong                                                            
Wallace         Zelaya                                                          
Narayan         Wong                                                            
Wong            Zelaya                                                          
English         Wong                                                            
Borg            Wallace                                                         
Wallace         Wong                                                            
Borg            Wong                                                            
Jabbar          Wallace                                                         
Jabbar          Wong                                                            

LNAME           LNAME                                                           
--------------- ---------------                                                 
Jabbar          Zelaya                                                          

12 rows selected.

SQL> --
SQL> ------------------------------------
SQL> --
SQL> /*(16A) Hint: A NULL in the hours column should be considered as zero hours.
SQL> Find the ssn, lname, and the total number of hours worked on projects for every employee whose total is less than 40 hours. Sort the result by lname
SQL> */
SQL> SELECT e.ssn, e.lname, SUM(wo.hours) FROM employee e
  2  LEFT JOIN works_on wo ON wo.essn = e.ssn
  3  HAVING SUM(wo.hours) < 40
  4  GROUP BY e.ssn, e.lname
  5  ORDER BY e.lname;

SSN       LNAME           SUM(WO.HOURS)                                         
--------- --------------- -------------                                         
987654321 Wallace                    35                                         

SQL> --
SQL> ------------------------------------
SQL> --
SQL> /*(17A)
SQL> For every project that has more than 2 employees working on it:
SQL> Find the project number, project name, number of employees working on it,
SQL> and the total number of hours worked by all employees on that project.
SQL> Sort the results by project number.
SQL> */
SQL> SELECT p.pnumber, p.pname, COUNT(wo.essn), SUM(wo.hours) FROM project p
  2  LEFT JOIN works_on wo ON wo.pno = p.pnumber
  3  HAVING COUNT(wo.essn) > 2
  4  GROUP BY p.pnumber, p.pname
  5  ORDER BY p.pnumber;

   PNUMBER PNAME           COUNT(WO.ESSN) SUM(WO.HOURS)                         
---------- --------------- -------------- -------------                         
         2 ProductY                     3          37.5                         
        10 Computerization              3            55                         
        20 Reorganization               3            25                         
        30 Newbenefits                  3            55                         

SQL> --
SQL> -- CORRELATED SUBQUERY --------------------------------
SQL> --
SQL> /*(18A)
SQL> For every employee who has the highest salary in his department:
SQL> Find the dno, ssn, lname, and salary .
SQL> Sort the results by department number.
SQL> */
SQL> SELECT e.dno, e.ssn, e.lname, e.salary FROM Department d
  2  LEFT JOIN employee e ON e.ssn =
  3  			     (SELECT ssn FROM employee
  4  			     WHERE dno = d.dnumber
  5  			     ORDER BY e.salary DESC
  6  			     FETCH FIRST 1 ROWS ONLY)
  7  ORDER BY e.dno;

       DNO SSN       LNAME               SALARY                                 
---------- --------- --------------- ----------                                 
         1 888665555 Borg                 55000                                 
         4 999887777 Zelaya               25000                                 
         5 123456789 Smith                30000                                 

SQL> --
SQL> -- NON-CORRELATED SUBQUERY -------------------------------
SQL> --
SQL> /*(19A)
SQL> For every employee who does not work on any project that is located in Houston:
SQL> Find the ssn and lname. Sort the results by lname
SQL> */
SQL> SELECT e.ssn, e.lname FROM employee e
  2  WHERE NOT EXISTS (SELECT wo.essn FROM works_on wo
  3  			 LEFT JOIN project p ON p.pnumber = wo.pno
  4  			 WHERE p.plocation != 'Houston' AND p.plocation != NULL AND wo.essn = e.ssn);

SSN       LNAME                                                                 
--------- ---------------                                                       
123456789 Smith                                                                 
333445555 Wong                                                                  
453453453 English                                                               
666884444 Narayan                                                               
888665555 Borg                                                                  
987654321 Wallace                                                               
987987987 Jabbar                                                                
999887777 Zelaya                                                                

8 rows selected.

SQL> --
SQL> -- DIVISION ---------------------------------------------
SQL> --
SQL> /*(20A) Hint: This is a DIVISION query
SQL> For every employee who works on every project that is located in Stafford:
SQL> Find the ssn and lname. Sort the results by lname
SQL> */
SQL> SELECT e.ssn, e.lname FROM employee e
  2  WHERE e.ssn ALL (SELECT wo.essn FROM project p
  3  		     LEFT JOIN works_on wo ON wo.pno = p.pnumber)
  4  
SQL> --
SQL> SET ECHO OFF
