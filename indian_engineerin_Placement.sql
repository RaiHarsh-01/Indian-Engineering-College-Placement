drop table indian_engineering_student_placement;
Create table indian_engineering_student_placement(
Student_ID int,
gender varchar(10),
branch varchar(10),
cgpa numeric(10,2),
tenth_percentage numeric(10,1),
twelfth_percentage numeric(10,1),
backlogs int,
study_hours_per_day numeric(10,1),
attendance_percentage numeric(10,1),
projects_completed int,
internships_completed int,
coding_skill_rating int,
communication_skill_rating int,
aptitude_skill_rating int,
hackathons_participated int,
certifications_count int,
sleep_hours numeric(10,1),
stress_level int,
part_time_job varchar(5),
family_income_level varchar(10),
city_tier varchar(10),
internet_access varchar(5),
extracurricular_involvement varchar(10)
);
---------------------------------------------------------------------------
Table  placement_targets
Create table placement_targets(
Student_ID int,
placement_status varchar(10),
salary_lpa numer
);
---------------------------------------------------------------------------
Level 1: Basic (Foundational Selection & Filtering)

1. Retrieve all columns from the `Students` table to understand the raw data.
select * from indian_engineering_student_placement;

2. Get a list of all unique engineering `branch` names in the dataset.
select branch from indian_engineering_student_placement group by branch;

3. Select the `Student_ID` and `cgpa` of all students who have a `cgpa` greater than 9.
select Student_ID, cgpa from indian_engineering_student_placement where cgpa > 9;

4. Find all students belonging to the 'CSE' branch.
select * from indian_engineering_student_placement where branch = 'CSE';

5. List students who have `internet_access` = 'Yes' and also have a `part_time_job` = 'Yes'.
select * from indian_engineering_student_placement where internet_access = 'Yes' and part_time_job = 'Yes';

6. Retrieve all students and sort them by `tenth_percentage` in descending order. ✅
select * from indian_engineering_student_placement order by tenth_percentage desc; 

7. Find the `Student_ID` and `projects_completed` for the top 10 students who completed the most projects.
select Student_ID, projects_completed from indian_engineering_student_placement order by projects_completed desc, 
student_id asc limit 10;

8. Filter the `Students` table to show only those who have  `backlogs`.
select * from indian_engineering_student_placement where backlogs > 0;

9. List the `Student_ID` and `branch` of students living in 'Tier 1' cities.
select Student_ID, Branch from indian_engineering_student_placement where city_tier = 'Tier 1';

10.Select all students who have a `coding_skill_rating` of 5 .
select * from indian_engineering_student_placement where coding_skill_rating = 5;
--------------------------------------------------------------------------------------------------------------------

Level 2: Intermediate (Aggregations & Joining Tables)

11. Calculate the average `cgpa` for each `branch`.
select avg(cgpa), branch from indian_engineering_student_placement group by branch;

12. Count how many students are from each `city_tier`.
select count(*)as No_of_Stu, city_tier from indian_engineering_student_placement group by city_tier;

13. Using a `JOIN`, find the total number of 'Placed' students in each `branch`.
select count(p.placement_status)as No_of_Placed_stu, i.branch from indian_engineering_student_placement i join 
placement_targets p on i.Student_ID = p.Student_ID where placement_status = 'Placed' group by branch;

14. Using a `JOIN`, calculate the average `salary_lpa` for students who are marked as 'Placed'.
select avg(salary_lpa) as Avg_salary, Student_ID from placement_targets where placement_status = 'Placed' group by Student_ID;

15. Count how many students have completed more than 4 `internships`.✅
select count(*)as No_Stu from  indian_engineering_student_placement where internships_completed > 3 ;


16. Find the branches where the average `attendance_percentage` is higher than .
select branch, avg(attendance_percentage)as attend_Per from indian_engineering_student_placement
group by branch order by attend_Per desc limit 1;

17. Join the two tables to display `Student_ID`, `branch`, `coding_skill_rating`, and `salary_lpa`.
select i.Student_ID, i.Branch, i.Coding_skill_rating, p.salary_lpa from indian_engineering_student_placement i 
Join placement_targets p on i.Student_ID = p.Student_ID;

18. Find the highest `salary_lpa` offered to each `branch`.
select max(p.salary_lpa), i.branch from indian_engineering_student_placement i 
Join placement_targets p on i.Student_ID = p.Student_ID group by branch;

19. Count the number of 'Placed' vs 'Not Placed' students, grouped by `gender`.
select i.gender,
    sum(CASE WHEN p.placement_status = 'Placed' THEN 1 ELSE 0 END) AS Placed,
    sum(CASE WHEN p.placement_status = 'Not Placed' THEN 1 ELSE 0 END) AS Not_Placed
from indian_engineering_student_placement i join placement_targets p on i.Student_ID = p.Student_ID 
group by i.gender;

20. Identify students who participated in more than 1 `hackathons` and have a `placement_status` of 'Placed'.
select * from indian_engineering_student_placement i join placement_targets p on i.Student_ID = p.Student_ID
where hackathons_participated > 1 and placement_status = 'Placed';
--------------------------------------------------------------------------------------------------------------------

Level 3: Advanced (Window Functions, CTEs & Logic)

21. Use a Window Function (`RANK`) to rank students by their `cgpa` within their specific `branch`.
select student_id, rank() over(order by cgpa desc ), branch, cgpa from indian_engineering_student_placement;

22. Create a Common Table Expression (CTE) to find the average salary of placed students and then select all students who earned more than that average.


23. For every student, calculate the difference between their `cgpa` and the average `cgpa` of their own `branch`.
select student_id, branch, cgpa, avg(cgpa) over(order BY branch) as branch_avg_cgpa, 
cgpa - avg(cgpa) over(order BY branch) as cgpa_diff from indian_engineering_student_placement;

24. Use a `CASE` statement to label students as 'High Stress' if `stress_level` is , 'Medium' if between  and , and 'Low' otherwise.

25. Using Window Functions, find the top  highest-paid students in every `branch`.
select max(p.salary_lpa), i.branch from indian_engineering_student_placement i join placement_targets p 
on i.Student_ID = p.Student_ID group by branch ;

select max(p.salary_lpa) over(order by i.branch), i.student_id, i.branch from 
indian_engineering_student_placement i join placement_targets p 
on i.Student_ID = p.Student_ID group by student_id ;

WITH StudentRanks AS (
    SELECT 
        student_id, 
        branch, 
        salary,
        DENSE_RANK() OVER (PARTITION BY branch ORDER BY salary DESC) as salary_rank
    FROM indian_engineering_student_placement
)
SELECT 
    student_name, 
    branch, 
    salary
FROM StudentRanks
WHERE salary_rank = 1;

26. Identify students whose `cgpa` is higher than the global average `cgpa` of all 'Placed' students.
select i.student_id, i.cgpa- avg(i.cgpa) over()as Diff_XX from indian_engineering_student_placement i
join placement_targets p on i.Student_ID = p.Student_ID where  p.placement_status = 'Placed';

27. **Skills vs. Pay:** Write a query to compare the average `salary_lpa` for each `coding_skill_rating` (1 to 5) to see if higher ratings lead to higher pay.
28. **Placement Rate Report:** Generate a report showing `branch`, the total number of students, and the "Placement Rate" (Placed Students / Total Students).
29. **Unrealized Potential:** Find students who have 'High' `extracurricular_involvement` and a `coding_skill_rating` of  but are currently 'Not Placed'.
30. **Underpaid Experts:** List students who have a `coding_skill_rating` above the branch average but are receiving a `salary_lpa` below the branch average.

==============================================================================================================================

qus-1- Rank Students by CGPA within each Branch Write a query to rank students based on their cgpa within each 
branch in descending order. Use RANK() so that students with the same CGPA receive the same rank.

select Rank() over(Partition by branch order by cgpa), branch from indian_engineering_student_placement;

qus-2- Compare Individual CGPA to Branch Average
For every student, display their Student_ID, branch, cgpa, and the average CGPA of their respective branch.
