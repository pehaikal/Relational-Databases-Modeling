drop table if exists admins, programs, course, teacher, room, sessions, grps, candidate, student, attendance_module, exam, teacher_course, program_course, student_attendance;

create table admins (
admin_ID integer not null primary key,
admin_email varchar(55) not null,
admin_password varchar(22) not null
);

create table programs (
prog_name char(4) not null primary key,
prog_number integer not null,
prog_fee integer not null, --in euro
prog_duration varchar(12) --period needed to graduate
);

create table course (
crse_code varchar(20) not null primary key,
crse_name varchar(45) not null,
crse_duration varchar(15) --period needed to finish a course
);

create table teacher (
teach_email varchar(55) not null primary key,
teach_fname char(25) not null,
teach_mname char(30) not null,
teach_lname char(35) not null,
teach_recrtType varchar(13) not null, --internally or independently
teach_paymntDetails varchar(40)
);

create table room (
rm_number varchar(6) not null primary key,
rm_capacity char(20), --number of student in each rooom
rm_surface integer --in square meter
);

create table grps (
grp_number integer not null primary key,
grp_name char(20) not null,
grp_color varchar(10) not null
);

create table sessions (
sess_number integer not null primary key,
sess_type char(55) not null,
sess_duration varchar(5) not null, --in hours
sess_startDate timestamp,
sess_endDate timestamp,
sessCrse_code varchar(20) not null,--fk1 to course
sessRm_no varchar(6) not null, --fk2 to room
sessTeach_email varchar(55) not null, --fk3 to teacher
sessGrp_no integer not null --fk4 to group
);
ALTER TABLE sessions ADD CONSTRAINT fk1_session_course FOREIGN KEY (sessCrse_code ) REFERENCES course;
ALTER TABLE sessions ADD CONSTRAINT fk2_session_room FOREIGN KEY (sessRm_no) REFERENCES room;
ALTER TABLE sessions ADD CONSTRAINT fk3_session_teacher FOREIGN KEY (sessTeach_email) REFERENCES teacher;
ALTER TABLE sessions ADD CONSTRAINT fk4_session_group FOREIGN KEY (sessGrp_no) REFERENCES grps;

create table candidate (
cand_number integer not null primary key,
cand_title char(5) not null,
cand_fname char(15) not null,
cand_mname char(20) not null,
cand_lname char(25) not null,
cand_dob date not null,
cand_addressName varchar(60) not null,
cand_country char(50) not null,
cand_mobileNo varchar(15) not null,
cand_isrecruited boolean not null, -- if yes -> recruited otherwise no
cand_paymtStatus boolean null, -- if yes -> Payment completed -> promoted to sutdent otherwise no
cand_emailAddress varchar(55) null
);

create table student (
std_UID integer not null primary key,
std_loginName varchar(20) not null,
std_password varchar(22) not null,
std_gender char(2) not null,
std_intake varchar(20) not null,
stdProg_name char(4) not null, --fk1 to program
stdCand_no integer not null, --fk2 to candidate
stdGrp_no integer not null --fk3 to group
);
ALTER TABLE student ADD CONSTRAINT fk1_student_program FOREIGN KEY (stdprog_name) REFERENCES programs;
ALTER TABLE student ADD CONSTRAINT fk2_student_candidate FOREIGN KEY (stdcand_no) REFERENCES candidate;
ALTER TABLE student ADD CONSTRAINT fk3_student_group FOREIGN KEY (stdgrp_no) REFERENCES grps;

create table attendance_module (
attd_refNo integer not null primary key,
attd_dateTime timestamp not null,
attdSess_no integer not null 
);
ALTER TABLE attendance_module ADD CONSTRAINT fk_attendance_sessions FOREIGN KEY (attdSess_no) REFERENCES sessions;

create table exam (
exm_refNo integer not null primary key,
exm_date date not null,
exm_type char(22) not null,
exm_weight varchar(5) not null, --in percentage
exm_coefficient integer not null, 
exmCrse_Code varchar(20) not null, --fk1 to course
exmStd_UID integer not null --fk2 to student
);
ALTER TABLE exam ADD CONSTRAINT fk1_exam_course FOREIGN KEY (exmCrse_Code) REFERENCES course;
ALTER TABLE exam ADD CONSTRAINT fk2_exam_student FOREIGN KEY (exmStd_UID) REFERENCES student;

--many to many relation between teacher and course tables
create table teacher_course (
teach_email varchar(55) not null,
crse_code varchar(20) not null
);
ALTER TABLE teacher_course ADD CONSTRAINT teacher_course_pk PRIMARY KEY (teach_email, crse_code);
ALTER TABLE teacher_course ADD CONSTRAINT fk1_teacher_course FOREIGN KEY (teach_email) REFERENCES teacher;
ALTER TABLE teacher_course ADD CONSTRAINT fk2_teacher_course FOREIGN KEY (crse_code) REFERENCES course;

--many to many relation between program and course tables
create table program_course (
prog_name char(18) not null,
crse_code varchar(20) not null
);
ALTER TABLE program_course ADD CONSTRAINT program_course_pk PRIMARY KEY (prog_name, crse_code);
ALTER TABLE program_course ADD CONSTRAINT fk1_program_course FOREIGN KEY (prog_name) REFERENCES programs;
ALTER TABLE program_course ADD CONSTRAINT fk2_program_course FOREIGN KEY (crse_code) REFERENCES course;

--many to many relation between student and attendance_module tables
create table student_attendance (
std_UID integer not null,
attd_refNo integer not null
);
ALTER TABLE student_attendance ADD CONSTRAINT student_attendance_pk PRIMARY KEY (std_UID, attd_refNo);
ALTER TABLE student_attendance ADD CONSTRAINT fk1_student_attendance FOREIGN KEY (std_UID) REFERENCES student;
ALTER TABLE student_attendance ADD CONSTRAINT fk2_student_attendance FOREIGN KEY (attd_refNo) REFERENCES attendance_module;

comment on table sessions is 'sessCrse_code, sessRm_no, sessTeach_ID, sessGrp_no are respectively primary keys of the course, room, teacher and group tables';
comment on table student is 'stdProg_name, stdCand_no, stdGrp_no are respectively primary keys of the program, candidate and group tables';
comment on table attendance_module is 'attdSess_no is respectively primary key of the session table';
comment on table program_course is 'It is a many to many relation between program and course tables';
comment on table teacher_course is 'It is a many to many relation between teacher and course tables';
comment on table student_attendance is 'It is a many to many relation between student and attendance_module tables';