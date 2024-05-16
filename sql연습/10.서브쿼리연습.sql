-- 
-- subquery
--

--
-- 1) select 절, insert into t1 values(...)
-- 
-- insert into board values(null, (select max(group_no) +1 from board), ... ))
-- select (select 1+2 from dual) from dual;
-- select * from (select 1+2 from dual) a;


--
-- 2) from 절의 서브쿼리
-- 
select now() as n, sysdate() as s, 3+1 as r from dual;
select n,s,r from (select now() as n, sysdate() as s, 3+1 as r from dual) a;


--
-- 3) where 절의 서브쿼리
-- 
 
-- 예제) 현재, Fai Bale이 근무하는 부서에서 근무하는 다른 직원의 사번과 이름을 출력하세요.
select b.dept_no from employees a, dept_emp b 
where a.emp_no = b.emp_no and b.to_date='9999-01-01' and concat(a.first_name, ' ', a.last_name) ='Fai Bale';
-- 'd004'

select a.emp_no, a.first_name from employees a, dept_emp b 
where a.emp_no = b.emp_no and b.to_date='9999-01-01' and b.dept_no='d004';


select a.emp_no, a.first_name from employees a, dept_emp b 
where a.emp_no = b.emp_no and b.to_date='9999-01-01' 
	and b.dept_no= 
	(	select b.dept_no from employees a, dept_emp b 
		where a.emp_no = b.emp_no and b.to_date='9999-01-01' and concat(a.first_name, ' ', a.last_name) ='Fai Bale');

-- 3-1) 단일행 연산자: = > , < , >= , <=, <>, !=
-- 실습문제1
-- 현재, 전체 사원의 평균 연봉보다 적은 급여를 받는 사원의 이름과 급여를 출력 하세요.
select avg(salary) from salaries where to_date='9999-01-01';

select a.first_name, b.salary from employees a, salaries b 
where a.emp_no=b.emp_no and b.to_date='9999-01-01' and b.salary < (select avg(salary) from salaries where to_date='9999-01-01')
order by b.salary desc;

-- 실습문제2
-- 현재, 직책별 평균급여 중에 가장 작은 직책의 직책이름과 그 평균 급여를 출력해 보세요. 
-- 1) 직책별 평균 급여
select b.title, avg(a.salary)
from salaries a, titles b where a.emp_no=b.emp_no and a.to_date='9999-01-01' and b.to_date='9999-01-01'
group by b.title;

-- 2) 직책별 가장 적은 평균 급여: from절 subquery
select min(avg_salary) from (
	select b.title, avg(a.salary) as avg_salary
	from salaries a, titles b where a.emp_no=b.emp_no and a.to_date='9999-01-01' and b.to_date='9999-01-01'
	group by b.title) a;

-- 3) sol1: where절 subquery(=)
select b.title, avg(a.salary)
from salaries a, titles b where a.emp_no=b.emp_no and a.to_date='9999-01-01' and b.to_date='9999-01-01'
group by b.title 
having avg(a.salary)= (select min(avg_salary) from (
	select b.title, avg(a.salary) as avg_salary
	from salaries a, titles b where a.emp_no=b.emp_no and a.to_date='9999-01-01' and b.to_date='9999-01-01'
	group by b.title) a);

-- 4) sol2: top-k(limit)
select b.title, avg(a.salary)
from salaries a, titles b where a.emp_no=b.emp_no and a.to_date='9999-01-01' and b.to_date='9999-01-01'
group by b.title order by avg(a.salary) asc limit 0, 1;

-- 3-2) 복수행 연산자: in, not in, 비교연산+any, 비교연산자+all ex)<all

-- any 사용법
-- 1. =any: in
-- 2. >anym >=any: 최소값
-- 3. <any, <=any: 최대값
-- 4. <>any, !=any: not in

-- all 사용법
-- 1. =all: (x)
-- 2. >all, >=all : 최대값
-- 3. <all, <=all : 최소값
-- 4. <>all, !=all

-- 실습문제3
-- 현재 급여가 50000 이상인 직원의 이름과 급여를 출력하세요.
-- 둘리 60000

-- sol1) join
select a.first_name, b.salary from employees a , salaries b 
where a.emp_no= b.emp_no and b.to_date='9999-01-01' and b.salary>=50000 order by b.salary asc;

-- sol2) subquery: where (in)
select emp_no, salary from salaries where to_date='9999-01-01' and salary>50000;

select a.first_name, b.salary from employees a, salaries b 
where a.emp_no = b.emp_no and b.to_date='9999-01-01' and (a.emp_no, b.salary) 
	in (select emp_no, salary from salaries where to_date='9999-01-01' and salary>50000)
order by b.salary asc;

-- sol3) subquery: where (=any)
select a.first_name, b.salary from employees a, salaries b 
where a.emp_no = b.emp_no and b.to_date='9999-01-01' and (a.emp_no, b.salary) 
	=any (select emp_no, salary from salaries where to_date='9999-01-01' and salary>50000)
order by b.salary asc;

-- 실습문제4:
-- 현재, 각 부서별로 최고 급여를 받고 있는 직원의 부서, 이름과 월급을 출력하세요.
-- 총무 둘리 4000
-- sol1: where절 subquery(in)
-- select a.dept_name, c.first_name, d.salary from departments a, dept_emp b, employees c, salaries d
-- where a.dept_no=b.dept_no and b.emp_no=c.emp_no and c.emp_no=d.emp_no
-- 	and b.to_date='9999-01-01' and d.to_date='9999-01-01'
-- group by a.dept_no;

-- select a.dept_no, max(b.salary) from dept_emp a, salaries b 
-- where a.emp_no=b.emp_no and a.to_date= '9999-01-01' and b.to_date='9999-01-01'
-- group by a.dept_no;
    
select a.dept_name, c.first_name, d.salary 
from departments a, dept_emp b, employees c, salaries d
where a.dept_no=b.dept_no and b.emp_no=c.emp_no and c.emp_no=d.emp_no
	and b.to_date='9999-01-01' and d.to_date='9999-01-01'
    and (b.dept_no, d.salary) in (
		select a.dept_no, max(b.salary) as max_salary from dept_emp a, salaries b 
		where a.emp_no=b.emp_no and a.to_date= '9999-01-01' and b.to_date='9999-01-01'
		group by a.dept_no);
    
    
-- sol2: from절 subquery & join
select a.dept_name, c.first_name, d.salary 
from departments a, dept_emp b, employees c, salaries d, (
		select a.dept_no, max(b.salary) as max_salary from dept_emp a, salaries b 
		where a.emp_no=b.emp_no and a.to_date= '9999-01-01' and b.to_date='9999-01-01'
		group by a.dept_no) e
where a.dept_no=b.dept_no and b.emp_no=c.emp_no and c.emp_no=d.emp_no and b.dept_no=e.dept_no and d.salary= e.max_salary
	and b.to_date='9999-01-01' and d.to_date='9999-01-01';
