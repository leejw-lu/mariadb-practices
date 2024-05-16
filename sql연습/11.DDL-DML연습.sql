-- DDL/DML 연습

drop table member;
create table member (
	no int not null auto_increment,
    email varchar(200) not null default '',
    password varchar(64) not null,
    name varchar(50) not null,
    department varchar(100),
    primary key(no)
);

desc member;

alter table member add column juminbunho char(13) not null;

alter table member drop juminbunho;

alter table member add column juminbunho char(13) not null after email;

alter table member change column department dept varchar(100) not null;
desc member;

alter table member add column self_intro text;
desc member;

alter table member drop juminbunho;
desc member;

-- insert 
insert into member values(null, 'jiwoojenny@gmail.com', password('1234'), '이지우', '개발팀', null);
select * from member;

insert into member(no, email, name, dept, password) 
	values (null, 'jiwoojenny2@gmail.com', '이지우2', '개발팀2', password('1234'));
    
select * from member;

-- update
update member set email='jiwoojenny3@gmail.com', password=password('4321') where no=2;
select * from member;

-- delete
delete from member where no=2;
select * from member;

-- transaction
select no, email from member;

select @@autocommit; -- 1
insert into member(no, email, name, dept, password) 
	values (null, 'jiwoojenny2@gmail.com', '이지우2', '개발팀2', password('1234'));
select no, email from member;

-- tx begin
set autocommit=0;
select @@autocommit; -- 0
insert into member(no, email, name, dept, password) 
	values (null, 'jiwoojenny2@gmail.com', '이지우2', '개발팀2', password('1234'));
select no, email from member;

-- tx end
commit;

