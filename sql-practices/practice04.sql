-- 서브쿼리(SUBQUERY) SQL 문제입니다.

-- 문제1.
-- 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까?
select count(*) from salaries
where to_date='9999-01-01' and salary > (select avg(salary) from salaries where to_date='9999-01-01');

-- 문제2. (x)
-- 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서 연봉을 조회하세요. 단 조회결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다. 

-- 문제3.
-- 현재, 자신의 부서 평균 급여보다 연봉(salary)이 많은 사원의 사번, 이름과 연봉을 조회하세요. 
select a.emp_no, concat(b.first_name, ' ', b.last_name) as 전체이름, c.salary 
from dept_emp a, employees b, salaries c, (
	select a.dept_no, avg(b.salary) as avg_salary from dept_emp a, salaries b
	where a.emp_no=b.emp_no and a.to_date='9999-01-01' and b.to_date='9999-01-01' group by a.dept_no
    ) d
where a.emp_no=b.emp_no and b.emp_no=c.emp_no 
	and a.dept_no=d.dept_no and c.salary> d.avg_salary 	-- from 서브쿼리 d 조건 추가부분
	and a.to_date='9999-01-01' and c.to_date='9999-01-01';

-- 서브쿼리: 부서 평균 급여 
-- select a.dept_no, avg(b.salary) as avg_salary from dept_emp a, salaries b
-- where a.emp_no=b.emp_no and a.to_date='9999-01-01' and b.to_date='9999-01-01' group by a.dept_no;

-- []  문제4.
-- 현재, 사원들의 사번, 이름, 매니저 이름, 부서 이름으로 출력해 보세요. 나의 매니저이름이 추가돼서 어려워짐 
-- 의문: 메니저도 사원인데 그러면 이름과 매니저이름 same???? 
-- department + dept_emp + eployees = 사원
-- dept_manager + employees = 매니저 
-- dept_emp - dept_manager 나의 매니저 

select a.emp_no, a.first_name as '사원 이름', e.first_name as '매니저 이름', b.dept_name 
from employees a, departments b, dept_emp c, dept_manager d, employees e
where a.emp_no=c.emp_no and b.dept_no=c.dept_no and c.dept_no = d.dept_no and b.dept_no=d.dept_no and d.emp_no=e.emp_no;

-- 문제5.
-- 현재, 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요.
select a.emp_no, a.first_name, b.title, c.salary
from employees a, titles b, salaries c, dept_emp d
where a.emp_no=b.emp_no and b.emp_no=c.emp_no and c.emp_no=d.emp_no 
	and b.to_date='9999-01-01' and c.to_date='9999-01-01' and d.to_date='9999-01-01'
	and d.dept_no= (select a.dept_no
		from dept_emp a, salaries b where a.emp_no=b.emp_no and a.to_date='9999-01-01' and b.to_date='9999-01-01'
		group by a.dept_no 
		order by avg(b.salary) desc limit 1)
order by c.salary desc;

-- 서브쿼리: 부서별 평균연봉 (d007)
-- select a.dept_no
-- from dept_emp a, salaries b where a.emp_no=b.emp_no and a.to_date='9999-01-01' and b.to_date='9999-01-01'
-- group by a.dept_no order by avg(b.salary) desc limit 1;


-- 문제6.
-- 평균 연봉이 가장 높은 부서는? 
-- 부서이름 평균연봉
select a.dept_name, avg(c.salary) as 평균연봉
from departments a, dept_emp b, salaries c
where a.dept_no=b.dept_no and b.emp_no=c.emp_no and b.to_date='9999-01-01' and c.to_date='9999-01-01'
group by a.dept_name order by 평균연봉 desc limit 1;

-- 문제7.
-- 평균 연봉이 가장 높은 직책?
-- 직책 평균 연봉 
select a.title, avg(b.salary) as 평균연봉
from titles a, salaries b
where a.emp_no=b.emp_no and a.to_date='9999-01-01' and b.to_date='9999-01-01'
group by a.title order by 평균연봉 desc limit 1;

-- subquery에서 round 

-- 문제8.
-- 현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은?
-- 부서이름, 사원이름, 연봉, 매니저 이름, 메니저 연봉 순으로 출력합니다.
-- select a.dept_name, c.first_name as '사원이름', d.salary as '연봉', f.first_name as '매니저 이름', g.salary as '매니저 연봉'
-- from departments a, dept_emp b, employees c, salaries d, dept_manager e , employees f, salaries g
-- where a.dept_no=b.dept_no and b.emp_no=c.emp_no and c.emp_no=d.emp_no and a.dept_no=e.dept_no and e.dept_no=

SELECT f.dept_name AS '부서이름', a.first_name AS '사원이름', d.salary AS '연봉', g.first_name AS '매니저 이름', e.salary AS '매니저 연봉'
FROM employees a, dept_emp b, dept_manager c, salaries d, salaries e, departments f, employees g
WHERE a.emp_no = b.emp_no AND c.dept_no = b.dept_no AND a.emp_no = d.emp_no AND c.emp_no = e.emp_no AND c.dept_no = f.dept_no AND c.emp_no = g.emp_no
AND b.to_date = '9999-01-01' AND c.to_date = '9999-01-01' AND d.to_date = '9999-01-01' AND e.to_date = '9999-01-01' AND d.salary > e.salary;
