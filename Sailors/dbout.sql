SQL> /*
SQL> Homework: create DB
SQL> Author: <enter your first and last name here>
SQL> */
SQL> SELECT * FROM Sailors;

       SID SNAME               RATING        AGE    TRAINEE                     
---------- --------------- ---------- ---------- ----------                     
        22 Dave                     7         45         85                     
        29 Mike                     1         33                                
        31 Mary                     8         55         85                     
        32 Albert                   8         25         31                     
        58 Jim                     10         35         32                     
        64 Jane                     7         35         22                     
        71 Dave                    10         16         32                     
        74 Jane                     9         40         95                     
        85 Art                      3         25         29                     
        95 Jane                     3         63                                

10 rows selected.

SQL> SELECT * FROM Boats;

       BID BNAME           COLOR            RATE     LENGTH  LOGKEEPER          
---------- --------------- ---------- ---------- ---------- ----------          
       101 Interlake       blue              350         30         95          
       102 Interlake       red               275         23         22          
       103 Clipper         green             160         15         85          
       104 Marine          red               195         24         22          
       105 Weekend Rx      white             500         43         31          
       106 C#              red               300         27         32          
       107 Bayside         white             350         32         85          
       108 C++             blue              100         12         95          

8 rows selected.

SQL> SELECT * FROM Reservations;

       BID FORDATE          SID ONDATE                                          
---------- --------- ---------- ---------                                       
       101 10-OCT-19         22 07-OCT-19                                       
       102 14-OCT-19         22 10-OCT-19                                       
       103 17-NOV-19         22 10-OCT-19                                       
       105 14-OCT-19         58 13-OCT-19                                       
       102 20-OCT-19         31 10-OCT-19                                       
       103 22-NOV-19         31 20-OCT-19                                       
       104 23-NOV-19         31 20-OCT-19                                       
       101 05-SEP-19         64 27-AUG-19                                       
       102 20-NOV-19         64 03-NOV-19                                       
       103 18-OCT-19         74 04-AUG-19                                       

10 rows selected.

SQL> SELECT * FROM LazySailors;

       SID SNAME               RATING                                           
---------- --------------- ----------                                           
        29 Mike                     1                                           
        32 Albert                   8                                           
        71 Dave                    10                                           
        85 Art                      3                                           
        95 Jane                     3                                           

SQL> SET AUTOCOMMIT ON;
SQL> INSERT INTO Sailors VALUES (22, 'Dave', 6, 45.0, 95);
INSERT INTO Sailors VALUES (22, 'Dave', 6, 45.0, 95)
*
ERROR at line 1:
ORA-00001: unique constraint (STROHSCD.SIC1) violated 


SQL> INSERT INTO Sailors VALUES (21, 'Jay', 6, 45.0, 99);
INSERT INTO Sailors VALUES (21, 'Jay', 6, 45.0, 99)
*
ERROR at line 1:
ORA-02091: transaction rolled back 
ORA-02291: integrity constraint (STROHSCD.SIC2) violated - parent key not found 


SQL> INSERT INTO Sailors VALUES (92, 'Popeye', 17, 45.0, 95);
INSERT INTO Sailors VALUES (92, 'Popeye', 17, 45.0, 95)
*
ERROR at line 1:
ORA-02290: check constraint (STROHSCD.SIC3) violated 


SQL> SET ECHO OFF
