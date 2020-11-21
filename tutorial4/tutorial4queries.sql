-- Rebin's solution (no. of rows for each query)
-- 1. 124
-- 2. 746
-- 3. 57 (ta says 39)
-- 4. 1
-- 5. 155
-- 6. 0 (ta says 2)
-- 7. 1771
-- 8. 1
-- 9. 1
-- 10. 0
-- 11. 0
-- 12. 2
-- 13. 0
-- 14. 0
-- 15. 1
-- 16. 1
-- 17. 0

-- q1 
-- select c.courseId from course as c where c.courseId not in (select courseId from prerequisite);

-- q2
-- select name, rollNo from student where rollNo not in (
-- select rollNo from enrollment where year = 2003 and sem = "even"
-- );

-- q3
-- select c.courseId from course as c where not exists (
-- 	select p.courseId from prerequisite as p where p.courseId = c.courseId and 
--     p.preReqCourse in (select courseId from prerequisite)
-- );
-- select distinct courseId from prerequisite where preReqCourse not in (select courseId from prerequisite)

-- q4
select name, empId from professor where empId in (
    (select empId from teaching where sem = 'even' and year = 2018)
    intersect
    (select empId from teaching where sem = 'odd' and year = 2018)
);

-- q5
-- select courseId from course where courseId not in (select courseId from teaching);