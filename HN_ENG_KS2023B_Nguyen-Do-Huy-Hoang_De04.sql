create database hackathon01;
use hackathon01;

create table tbl_students(
	student_id int primary key auto_increment,
    student_name varchar(100) not null,
    phone varchar(20) not null unique,
    email varchar(100) not null unique,
    address varchar(255)
);

create table tbl_teachers(
	teacher_id int primary key auto_increment,
    teacher_name varchar(100) not null,
    specialization varchar(100),
    phone varchar(20) not null unique,
    email varchar(100) not null unique
);

create table tbl_courses(
	course_id int primary key auto_increment,
    course_name varchar(100) not null,
	teacher_id int,
    foreign key (teacher_id) references tbl_teachers(teacher_id),
    start_date date,
    end_date date,
    tuition_fee decimal(10,2)
);

create table tbl_enrollments(
	enrollment_id int primary key auto_increment,
    student_id int,
    course_id int,
    foreign key (student_id) references tbl_students(student_id),
    foreign key (course_id) references tbl_courses(course_id),
    enrollment_date date,
    status ENUM('Active', 'Completed', 'Cancelled')
);

create table tbl_schedules(
	schedule_id int primary key auto_increment,
    course_id int,
    teacher_id int,
    foreign key (course_id) references tbl_courses(course_id),
    foreign key (teacher_id) references tbl_teachers(teacher_id),
    class_date datetime,
    room varchar(50)
);
-- 2.1
alter table tbl_enrollments add column discount DECIMAL(10,2);
-- 2.2
alter table tbl_students modify column phone varchar(15) ; 
-- 2.3
-- alter table tbl_courses drop column tuition_fee;

-- 3
insert into tbl_students(student_name, phone, email, address) 
	value	('nguyen van a', '0123456789', 'nguyenA@gmail.com', 'HN'),
			('tran thi b', '9876543210', 'tranB@gmail.com','HCM');
            
insert into tbl_teachers(teacher_name, specialization, phone, email)
	value	('dinh van c', 'toan', '123123123','dinhC@gmail.com'),
			('le thi d', 'van', '456456456', 'leD@gmail.com');
	
insert into tbl_courses(course_name, teacher_id, start_date, end_date, tuition_fee)
	value	('toan co ban', 1, '2024-01-01', '2025-01-01', 29.99),
			('ngu van co ban', 2, '2024-06-06', '2025-06-06', 39.99),
            ('ngu van nang cao', 2, '2024-06-06', '2025-06-06', 39.99);

insert into tbl_enrollments(student_id, course_id, enrollment_date, status, discount)
	value	(1, 1, '2024-12-21', 'Completed', 0.1),
			(1, 2, '2024-01-12', 'Cancelled', 0.2),
            (2, null, '2024-01-12', 'Cancelled', 0.1),
            (null, 2, '2024-12-21', 'Active', 0.3);

insert into tbl_schedules(course_id, teacher_id, class_date, room)
	value	(1, 1, '2024-01-03', '001'),
			(2, 2, '2024-06-09', '002');

-- 4a
select * from tbl_courses;
-- 4b
select distinct student_name
from tbl_students s
join tbl_enrollments e on s.student_id = e.student_id;

-- 5a
select t.teacher_name, COUNT(c.course_id) as so_luong_khoa_hoc
from tbl_teachers  t
join tbl_courses  c on t.teacher_id = c.teacher_id
group by t.teacher_name;

-- 5b
select c.course_name, COUNT(e.student_id) AS so_luong_hoc_vien
from tbl_courses  c
join tbl_enrollments  e on c.course_id = e.course_id
group by c.course_name;

-- 6a
select s.student_name, COUNT(e.course_id) as so_luong_khoa_hoc_da_dang_ky
from tbl_students  s
join tbl_enrollments  e on s.student_id = e.student_id
group by s.student_name;

-- 6b
select s.student_name
from tbl_students  s
join tbl_enrollments  e on s.student_id = e.student_id
group by s.student_name
having COUNT(e.course_id) >= 2;

-- 7
select c.course_name, COUNT(e.student_id) AS so_luong_hoc_vien
from tbl_courses  c
join tbl_enrollments  e on c.course_id = e.course_id
group by c.course_name
order by so_luong_hoc_vien desc
limit 5;

-- 8
select s.student_name, SUM(c.tuition_fee * (1 - e.discount)) AS tong_tien_da_chi_tra
from tbl_students  s
join tbl_enrollments  e on s.student_id = e.student_id
join tbl_courses  c on e.course_id = c.course_id
group by s.student_name;


-- 9a
select s.student_name, COUNT(e.course_id) as so_luong_khoa_hoc
from tbl_students s
join tbl_enrollments e on s.student_id = e.student_id
group by s.student_name
having COUNT(e.course_id) = (
    select MAX(so_luong_khoa_hoc)
    from (
        select COUNT(course_id)  so_luong_khoa_hoc
        from tbl_enrollments
        group by student_id
    ) as counts
);

-- 9b
select c.course_name
from tbl_courses c
join tbl_enrollments e on c.course_id = e.course_id
where e.student_id is null;



