-- show indexes from course;
-- show columns from course;
-- show indexes from department;
-- show columns from department;
-- show indexes from enrollment;
-- show columns from enrollment;
-- show indexes from prerequisite;
-- show columns from prerequisite;
-- show indexes from professor;
-- show columns from professor;
-- show indexes from student;
-- show columns from student;
-- show indexes from teaching;
-- show columns from teaching;

-- do select and order by
-- maybe use order by (sort)....on a non key field....now when you have an index it will be much faster
-- he difficulty is in determining what columns need indexing and whether enforcing uniqueness is necessary. ..specify unique index maybe
-- Deciding which fields should be indexed involves several considerations. If you have a field involved in searching, grouping, or sorting, indexing it will likely result in a performance gain. These include fields that are part of join operations or fields that appear with clauses such asWHERE, GROUP BY, or ORDER BY.
-- https://logicalread.com/mysql-performance-tuning-with-indexes-mc13/#.X55O41UzbH5
-- put screenshots of explain command before and after adding indices....in the report
-- While indexes are really good when trying to find particular information on a table, they can’t help us when we need all the information in it. 
-- join on indexed vs non indexed
-- list down the initially present indices in the concerned tables

-- drop database academic_insti;
-- select * from teaching where empId = '99052';
-- select * from teaching where courseId = '457';
-- select * from teaching where sem = 'even' and year = 2001;
-- select * from prerequisite where preReqCourse = '852';
-- select * from prerequisite where courseId = '133';
-- select e.rollNo, t.empId from enrollment as e, teaching as t where e.courseId = t.courseId and e.sem = t.sem and e.year = t.year;
-- select e.rollNo, t.classRoom from enrollment as e, teaching as t where e.courseId = t.courseId and e.sem = t.sem and e.year = t.year;
-- create index classRoomInd on teaching (classRoom);
-- create index csyInd on enrollment (courseId, sem, year);
-- alter table enrollment drop index csyInd;

-- select e.rollNo from enrollment as e, teaching as t where t.classRoom = 'R5' and e.courseId = t.courseId and e.sem = t.sem and e.year = t.year and t.year = 2003;

select t.classRoom, count(e.rollNo) from enrollment as e, teaching as t where e.courseId = t.courseId and e.sem = t.sem and e.year = t.year and t.year = 2003 group by t.classRoom;

-- SHOW CREATE TABLE enrollment;
-- alter table enrollment drop foreign key enrollment_ibfk_1;
-- alter table enrollment drop index courseId;

-- SHOW CREATE TABLE teaching;
-- alter table teaching drop foreign key teaching_ibfk_1;
-- alter table teaching drop index courseId;

