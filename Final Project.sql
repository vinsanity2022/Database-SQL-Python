/*
 Exercise 1: Using Joins
 Write and execute a SQL query to list the school names, community names and 
 average attendance for communities with a hardship index of 98.
 */
SELECT cpd.NAME_OF_SCHOOL,
    csd.COMMUNITY_AREA_NAME,
    cpd.AVERAGE_STUDENT_ATTENDANCE
FROM chicago_public_schools AS cpd
    LEFT JOIN chicago_socioeconomic_data AS csd ON cpd.COMMUNITY_AREA_NUMBER = csd.COMMUNITY_AREA_NUMBER
WHERE csd.HARDSHIP_INDEX = 98
    /*
     Write and execute a SQL query to list all crimes that took place at a school. 
     Include case number, crime type and community name.
     */
SELECT cc.CASE_NUMBER,
    cc.PRIMARY_TYPE,
    csd.COMMUNITY_AREA_NAME
FROM chicago_crime AS cc
    LEFT JOIN chicago_socioeconomic_data AS csd ON cc.COMMUNITY_AREA_NUMBER = csd.COMMUNITY_AREA_NUMBER
WHERE cc.LOCATION_DESCRIPTION LIKE '%SCHOOL%'
    /*
     Exercise 2: Creating a View
     Write and execute a SQL statement to create a view showing the columns 
     listed in the following table, with new column names as shown in the second column.
     Column name in CHICAGOPUBLICSCHOOLS Column name in view
     
     Write and execute a SQL statement that returns all of the columns from the view.
     
     Write and execute a SQL statement that returns just the school name and leaders rating from the view.
     
     */
    CREATE VIEW CHICAGOPUBLICSHCOOLS AS
SELECT name_of_school AS School_name,
    Safety_Icon AS Safety_Rating,
    Family_Involvement_Icon AS Family_Rating,
    Environment_Icon AS Environment_Rating,
    Instruction_Icon AS Instruction_Rating,
    Leaders_Icon AS Leaders_Rating,
    Teachers_Icon AS Teachers_Rating   
FROM chicago_public_schools

SELECT *
FROM CHICAGOPUBLICSHCOOLS
    /*
     Exercise 3: Creating a Stored Procedure

     Write the structure of a query to create or replace a stored procedure called UPDATELEADERSSCORE that takes a 
     inSchoolID parameter as an integer and a inLeaderScore parameter as an integer.

     Inside your stored procedure, write a SQL statement to update the LeadersScore field in the CHICAGOPUBLICSCHOOLS 
     table for the school identified by inSchoolID to the value in the inLeader_Score parameter.

     Inside your stored procedure, write a SQL IF statement to update the LeadersIcon field in the CHICAGOPUBLICSCHOOLS 
     table for the school identified by inSchool_ID using the following information.

     Write a query to call the stored procedure, passing a valid school ID and a leader score of 50, to check that the 
     procedure works as expected.

     Exercise 4: Using Transactions

     Update your stored procedure definition. Add a generic ELSE clause to the IF statement that rolls back 
     the current work if the score did not fit any of the preceding categories.

     Update your stored procedure definition again. Add a statement to commit the current unit of work at the end of 
     the procedure.

     Run your code to replace the stored procedure.

    Write and run one query to check that the updated stored procedure works as expected when you use a valid score of 38.

    rite and run another query to check that the updated stored procedure works as expected when you use an invalid score of 101.
     */

CREATE PROCEDURE UPDATELEADERSSCORE (
	IN SchoolID INTEGER, IN LeadersScore VARCHAR(3))
BEGIN

    IF LeadersScore >=0 AND LeadersScore <= 100 THEN
    UPDATE chicago_public_schools
    SET Leaders_Icon = CASE
                        WHEN LeadersScore  BETWEEN 80 AND 100 THEN 'Very strong'
                        WHEN LeadersScore  BETWEEN 60 AND 79 THEN 'Strong'
                        WHEN LeadersScore BETWEEN 40 AND 59 THEN 'Average'
                        WHEN LeadersScore BETWEEN 20 AND 39 THEN 'Weak'
                        WHEN LeadersScore  BETWEEN 0 AND 19 THEN 'Very weak'
                        END
    WHERE School_ID = SchoolID;

    UPDATE chicago_public_schools
	SET Leaders_Score = LeadersScore
	WHERE School_ID = SchoolID; 

    ELSE
        ROLLBACK WORK;   

    END IF;

         COMMIT WORK;
END

CALL UPDATELEADERSSCORE(610038, 100) -- to check if the stored procedure is running as directed.


SELECT School_ID, Leaders_Score, Leaders_Icon FROM chicago_public_schools -- checking the table for changes



-- modfying the space of leaders_icon from varchar(4) to (15)
ALTER TABLE chicago_public_schools MODIFY COLUMN Leaders_Icon VARCHAR(15);


