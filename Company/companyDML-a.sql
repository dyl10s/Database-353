SQL> SET ECHO ON
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
SQL> SELECT DISTINCT e1.lname, e2.lname FROM employee e1, employee e2;

LNAME           LNAME                                                           
--------------- ---------------                                                 
Smith           Wong                                                            
Wong            Jabbar                                                          
Wallace         Zelaya                                                          
Wallace         Wallace                                                         
Narayan         Smith                                                           
English         Smith                                                           
Smith           Zelaya                                                          
Narayan         English                                                         
English         Wallace                                                         
Smith           Jabbar                                                          
Wong            Zelaya                                                          

LNAME           LNAME                                                           
--------------- ---------------                                                 
Wong            Narayan                                                         
Narayan         Wong                                                            
Narayan         Borg                                                            
English         Zelaya                                                          
Jabbar          English                                                         
Jabbar          Jabbar                                                          
Borg            Smith                                                           
Borg            Borg                                                            
Smith           Smith                                                           
Smith           English                                                         
Smith           Borg                                                            

LNAME           LNAME                                                           
--------------- ---------------                                                 
Wong            Wallace                                                         
Wallace         Borg                                                            
Narayan         Narayan                                                         
English         Jabbar                                                          
Borg            Jabbar                                                          
Smith           Narayan                                                         
Wong            Smith                                                           
Wong            Wong                                                            
Zelaya          Wallace                                                         
Zelaya          English                                                         
Zelaya          Jabbar                                                          

LNAME           LNAME                                                           
--------------- ---------------                                                 
Wallace         Smith                                                           
English         Wong                                                            
Borg            Wallace                                                         
Smith           Wallace                                                         
Wong            English                                                         
Wong            Borg                                                            
Zelaya          Zelaya                                                          
Zelaya          Narayan                                                         
Wallace         Wong                                                            
Narayan         Zelaya                                                          
English         Borg                                                            

LNAME           LNAME                                                           
--------------- ---------------                                                 
Jabbar          Wallace                                                         
Jabbar          Borg                                                            
Borg            Wong                                                            
Borg            Zelaya                                                          
Zelaya          Smith                                                           
Zelaya          Borg                                                            
Wallace         Narayan                                                         
Wallace         Jabbar                                                          
Narayan         Jabbar                                                          
English         Narayan                                                         
English         English                                                         

LNAME           LNAME                                                           
--------------- ---------------                                                 
Jabbar          Wong                                                            
Zelaya          Wong                                                            
Wallace         English                                                         
Narayan         Wallace                                                         
Jabbar          Smith                                                           
Jabbar          Zelaya                                                          
Jabbar          Narayan                                                         
Borg            Narayan                                                         
Borg            English                                                         

64 rows selected.

SQL> --
SQL> ------------------------------------
SQL> --
SQL> /*(16A) Hint: A NULL in the hours column should be considered as zero hours.
SQL> Find the ssn, lname, and the total number of hours worked on projects for every employee whose total is less than 40 hours. Sort the result by lname
SQL> */
SQL> -- <<< Your SQL code goes here >>>
SQL> --
SQL> ------------------------------------
SQL> --
SQL> /*(17A)
SQL> For every project that has more than 2 employees working on it: Find the project number, project name, number of employees working on it, and the total number of hours worked by all employees on that project. Sort the results by project number.
SQL> */
SQL> -- <<< Your SQL code goes here >>>
SQL> --
SQL> -- CORRELATED SUBQUERY --------------------------------
SQL> --
SQL> /*(18A)
SQL> For every employee who has the highest salary in his department: Find the dno, ssn, lname, and salary . Sort the results by department number.
SQL> */
SQL> -- <<< Your SQL code goes here >>>
SQL> --
SQL> -- NON-CORRELATED SUBQUERY -------------------------------
SQL> --
SQL> /*(19A)
SQL> For every employee who does not work on any project that is located in Houston: Find the ssn and lname. Sort the results by lname
SQL> */
SQL> -- <<< Your SQL code goes here >>>
SQL> --
SQL> -- DIVISION ---------------------------------------------
SQL> --
SQL> /*(20A) Hint: This is a DIVISION query
SQL> For every employee who works on every project that is located in Stafford: Find the ssn and lname. Sort the results by lname
SQL> */
SQL> -- <<< Your SQL code goes here >>>
SQL> --
SQL> SET ECHO OFF
