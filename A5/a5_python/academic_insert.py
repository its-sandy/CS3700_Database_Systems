# Group 5 submission--
# Vamsi Krishna CS17B045
# Vimarsh Sathia CS17B046
# Arnav Mhaske CS17B110
# Suhas Pai CS17B116
# Santhosh Kumar CS16B107

import mysql.connector
import random
mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="ENTER PASSWORD HERE",
  database = "academic_insti"
)
mycursor = mydb.cursor()
def generate_random_grade():
    l = ['S','A','B','C','D','E','U']
    return random.choice(l)
def add_new_course(dept_id,course_id,teacher_id,classroom): ## adds new course, updates teaching and course tables appropriately
    mycursor.execute('SELECT * from professor as p where p.empId = "{}"'.format(teacher_id))
    teacher_res = mycursor.fetchall()
    if len(teacher_res)==0:
        print("Invalid teacher_id!")
        return
    else:
        mycursor.execute('SELECT * from course as c where c.courseId = "{}"'.format(course_id))
        course_res = mycursor.fetchall()
        if len(course_res) > 0:
            print("Course with the given ID already exists!")
            return


        mycursor.execute('INSERT INTO course (courseId,cname,credits,deptNo) VALUES ("{}","{}",{},"{}")'.format(course_id,"course_name_"+str(course_id),3,dept_id))
        mycursor.execute('INSERT INTO teaching (empId,courseId,sem,year,classRoom) VALUES ("{}","{}","{}",{},"{}")'.format(teacher_id,course_id,"even",2006,classroom))
        mydb.commit()

def check_prereqs(sroll_no,course_id): ## get all prereqs, check if student has passed all
    mycursor.execute('SELECT p.preReqCourse from prerequisite as p where p.courseId = "{}"'.format(course_id))
    prereq_res = mycursor.fetchall()
    for prereq in prereq_res:
        mycursor.execute('SELECT * from enrollment as e where e.courseId = "{}" and e.rollNo = "{}" and  e.year<=2006 and e.grade!="U"'.format(prereq[0],sroll_no))
        res = mycursor.fetchall()
        
        if len(res)==0:
            return False
    return True

def enroll_student(sroll_no,course_list): ## Enrolls students after checking various conditions
    mycursor.execute('SELECT * from student as s where s.rollNo = "{}"'.format(sroll_no))
    res = mycursor.fetchall()
    if len(res) == 0:
        print("Student with the given roll number does not exist")
        return

    for course_id in course_list:
        mycursor.execute('SELECT * from course as c where c.courseId = "{}"'.format(course_id))
        check = mycursor.fetchall()
        if len(check) == 0:
            print("Course with Id {} does not exist. Could not enroll the student in the course".format(course_id))
            continue
        flag = check_prereqs(sroll_no,course_id)
        if flag:
            mycursor.execute('INSERT INTO enrollment (rollNo,courseId,sem,year,grade) VALUES ("{}","{}","even",2006,"{}")'.format(sroll_no,course_id,generate_random_grade()))
            mydb.commit()
        else:
            print("Student has not completed all prerequisites of the course {}".format(course_id))

            
while(True):
    print("Select one of the two options 1. Add a new course 2. Enroll a student into courses 3. Exit")
    opt = int(input())
    if opt == 1:  ##### Example input : 1 CS3300 Emp1112 CS36
        print("Enter the department id, course id, teacher id and classroom")
        inp = input()
        inp = inp.split(" ")
        add_new_course(inp[0],inp[1],inp[2],inp[3])
    elif opt == 2: ##### Example input for rollnumber CS17Bxyz - CS17Bxyz CS3300 CS3700 CS6666
        print("Enter student roll number, and a list of course ids to enroll the student in (Space separated)")
        inp = input()
        inp = inp.split(" ")
        enroll_student(inp[0],inp[1:])
    else:
        break



