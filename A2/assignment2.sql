-- 1. List the names and ids of departments along with the average experience (as of 2020) of faculty in the department, in decreasing order of experience
select p.deptNo, d.name, sum(2020-startYear)/count(*) as avgFacultyExp from professor as p, department as d where p.deptNo = d.deptId group by p.deptNo order by avgFacultyExp desc;

-- 2. List the roll no, name and total credits completed by all students, ignoring courses with U grade
select e.rollNo, s.name, sum(c.credits) as creditsDone from enrollment as e, course as c, student as s where c.courseId = e.courseId and e.rollNo = s.rollNo and e.grade != 'U' group by e.rollNo;

-- 3. List the departments with gender ratio of male to female students more than 2, in decreasing order
select d.deptId, d.name, m.count/f.count as genderRatio from department as d,
(select deptNo, count(*) as count from student where sex = 'male' group by deptNo) as m,
(select deptNo, count(*) as count from student where sex = 'female' group by deptNo) as f
where d.deptId = m.deptNo and d.deptId= f.deptNo having genderRatio > 2 order by genderRatio desc;

-- 4. List the departments with the minimum number of students that have failed at least one course, along with this count
select c.deptNo, d.name, c.count as numStudentsFailed from 
	(select deptNo, count(*) as count from student where rollNo in 
		(select rollNo from enrollment where grade = 'U') 
	group by deptNo) as c,
    department as d
    where d.deptId = c.deptNo and
    c.count = (select min(count) from 
		(select deptNo, count(*) as count from student where rollNo in 
			(select rollNo from enrollment where grade = 'U')
		group by deptNo) 
	as c2);
    
-- 5. List of roll numbers and names of students who have never taken a course under a professor with less than 25 years of experience 
select s.rollNo, s.name from student as s where not exists (
	select * from enrollment as e, professor as p, teaching as t where
	e.rollNo = s.rollNo and e.courseId = t.courseId and e.year = t.year and e.sem = t.sem and t.empId = p.empId and p.startYear > 2020-25
);

-- 6. List of names and ids of courses that have been taught in all years between 2018 and 2020
select c.courseId, c.cname from teaching as t, course as c where t.year>=2018 and t.year<=2020 and c.courseId = t.courseId group by courseId having count(distinct t.year) = 2020-2018+1;

-- 7. List of professors that have taught both in odd semesters and in even semesters
select distinct p.empId, p.name from teaching as t, professor as p where p.empId = t.empId and t.sem = 'odd' and t.empId in (select empId from teaching where sem = 'even');


-- 8. List of names of students or professors that begins with 'Ba'
(select name from student where name like 'Ba%')
union
(select name from professor where name like 'Ba%');


-- 9. List the professors who have taught a course and also a prerequisite for the course (This query did not have any output rows)
select p.empId, p.name from professor as p, prerequisite as pre where 
exists (select * from teaching as t where t.empId = p.empId and t.courseId = pre.courseId) and 
exists (select * from teaching as t where t.empId = p.empId and t.courseId = pre.preReqCourse);