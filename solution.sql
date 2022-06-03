--1
SELECT
	e1.ename,e1.deptno,e2.maxsal
FROM
	emp e1
JOIN
	(SELECT deptno,MAX(sal) AS maxsal FROM emp GROUP BY deptno) AS e2
ON
	e1.sal = e2.maxsal;

--2
SELECT
	e2.*,e1.ename,e1.sal
FROM
	emp e1
JOIN
	(SELECT deptno,AVG(sal) AVGsal FROM emp GROUP BY deptno) AS e2
ON
	e1.sal>e2.AVGsal AND e1.deptno = e2.deptno;

--3
SELECT
	n.deptno,AVG(grade)
FROM
	(SELECT e.ename,e.sal,e.deptno,s.grade FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal) n
GROUP BY
	deptno;
--3@standard
SELECT
	e.deptno,avg(s.grade)
FROM
	emp e
JOIN 
	salgrade s 
ON 
	e.sal BETWEEN s.losal AND s.hisal
GROUP BY
	deptno;

--4
SELECT
	ename,sal
FROM
	emp
ORDER BY
	sal DESC
LIMIT
	0,1;
--4 addition
SELECT
	sal
FROM
	emp 
WHERE
	sal NOT IN (SELECT DISTINCT e1.sal FROM emp e1 JOIN emp e2 ON e1.sal<e2.sal);

--5
SELECT
	deptno,t.AVGsal
FROM
	(SELECT deptno,AVG(sal) AS AVGsal FROM emp GROUP BY deptno) AS t
ORDER BY
	t.AVGsal DESC
LIMIT 
	0,1;
--5 standard
SELECT
	deptno,AVG(sal) AS AVGsal
FROM 
	emp 
GROUP BY 
	deptno
ORDER BY
	AVGsal DESC
LIMIT 
0,1;
--5 addition
SELECT
	deptno,avg(sal) as AVGsal
FROM
	emp 
GROUP BY
	deptno
HAVING
	avgsal = (SELECT max(t.AVGsal) FROM(SELECT deptno,AVG(sal) AS AVGsal FROM emp GROUP BY deptno) AS t);

--6
SELECT
	dname,AVGsal
FROM
	(SELECT d.dname,t.AVGsal FROM dept d 
JOIN
	(SELECT deptno,AVG(sal) AS AVGsal FROM emp GROUP BY deptno) AS t ON d.deptno=t.deptno) AS tt
ORDER BY
	AVGsal DESC
LIMIT
	0,1;
--6 standard
SELECT
	d.dname,avg(e.sal) as avgsal
FROM
	emp e
JOIN 
	dept d
ON
	e.deptno = d.deptno
GROUP BY
	d.dname
ORDER BY
	avgsal DESC
LIMIT
	0,1;
	
--7
SELECT
	d.dname,a.AVGsal,s.grade
FROM
	dept d
JOIN
	(SELECT deptno,AVG(sal) AS AVGsal FROM emp GROUP BY deptno) AS a
ON
	d.deptno = a.deptno
JOIN
	salgrade s
ON
	a.AVGsal BETWEEN s.losal AND s.hisal
ORDER BY
	AVGsal ASC
LIMIT
	0,1;
--7 standard
SELECT 
	a.*,s.grade
FROM
	(SELECT d.dname,AVG(sal) AS AVGsal FROM emp e JOIN dept d ON e.deptno = d.deptno GROUP BY e.deptno) AS a
JOIN
	salgrade s
ON
	a.AVGsal BETWEEN s.losal AND s.hisal
WHERE
	s.grade = (SELECT grade FROM salgrade WHERE (SELECT AVG(sal) AS AVGsal FROM emp GROUP BY deptno ORDER BY AVGsal ASC LIMIT 0,1) BETWEEN losal and hisal);
	
--8
SELECT
	t.ename
FROM
	(SELECT DISTINCT e1.ename,e1.sal FROM emp e1 JOIN emp e2 ON e1.empno = e2.mgr) AS t
WHERE
	t.sal>(SELECT MAX(sal) FROM emp WHERE ename NOT IN (SELECT DISTINCT e1.ename FROM emp e1 JOIN emp e2 ON e1.empno = e2.mgr));

--9
SELECT
	e.ename,e.sal
FROM
	emp e
ORDER BY
	e.sal desc
LIMIT
	0,5;

--10
SELECT
	e.ename,e.sal
FROM
	emp e
ORDER BY
	e.sal desc
LIMIT
	5,5;
	
--11
SELECT
	e.ename,e.hiredate
FROM
	emp e
ORDER BY
	e.hiredate desc
LIMIT
	0,5;

--12
SELECT
	s.grade,count(ename)
FROM
	emp e
JOIN
	salgrade s
ON
	e.sal BETWEEN s.losal AND s.hisal
GROUP BY
	grade;

--13
--1.用C表找出黎明老师在哪些课里，接着拼接S表与SC表，找出没有选黎明老师课的学生
--2.将S表与SC表拼接在一起并剔除大于60分的课程，按照学生分组找出课程数大于等于2门的学生，接着回原表计算他们的平均成绩，最后拼接
--3.S表与SC表拼接找到修了一号课的学生名单，以及修了二号课的学生名单，取一名单还在二名单中的学生。

--14
SELECT
	e1.ename empname,e2.ename mgrname
FROM
	emp e1
LEFT JOIN
	emp e2
ON
	e1.mgr = e2.empno;

--15
SELECT
	e1.ename employees, e1.hiredate, e2.ename employers, e2.hiredate, d.dname
FROM
	emp e1
LEFT JOIN
	emp e2
ON
	e1.mgr = e2.empno and e1.hiredate < e2.hiredate
JOIN
	dept d
ON
	e1.deptno = d.deptno;

--16
SELECT
	e.*, d.dname
FROM
	emp e
RIGHT JOIN
	dept d
ON
	e.deptno = d.deptno
ORDER BY
	d.deptno;

--17
SELECT
	COUNT(*) as sumcount,d.dname
FROM
	emp e
JOIN
	dept d 
ON
	e.deptno = d.deptno
GROUP BY
	d.dname
HAVING
	sumcount >= 5;

--18
SELECT
	e.ename, e.sal
FROM
	emp e
WHERE
	e.sal > (SELECT e.sal FROM emp e WHERE e.ename = 'SMITH');

--19
SELECT
	e.ename,e.job,t.*,d.dname
FROM
	emp e
JOIN
	(SELECT d.deptno,COUNT(*) as deptcount FROM emp e JOIN dept d ON e.deptno = d.deptno GROUP BY d.deptno) AS t
ON
	e.deptno = t.deptno
JOIN
	dept d
ON
	d.deptno = e.deptno;

--20
SELECT
	e.job,COUNT(*)
FROM
	emp e
GROUP BY
	e.job
HAVING
	MIN(sal)>1500;

--21
SELECT
	e.ename
FROM
	emp e 
JOIN
	dept d
ON
	e.deptno = d.deptno and d.dname = 'SALES';

--22
SELECT
	e.ename,d.dname,e.mgr,s.grade
FROM
	emp e
JOIN
	dept d
ON
	e.deptno = d.deptno
JOIN
	salgrade s
ON
	e.sal BETWEEN s.losal AND s.hisal
WHERE
	e.sal > (SELECT AVG(sal) FROM emp);

--23
SELECT
	e.ename,e.job,d.dname
FROM
	emp e 
JOIN
	dept d 
ON
	e.deptno = d.deptno
WHERE
	e.job = (SELECT e.job FROM emp e WHERE e.ename = 'SCOTT') and e.ename != 'SCOTT';

--24
SELECT
	e.ename,e.sal
FROM
	emp e
WHERE
	e.sal in (SELECT e.sal FROM emp e WHERE e.deptno = 30) AND e.ename not in (SELECT e.ename from emp e WHERE e.deptno = 30);

--25
SELECT
	e.ename,d.dname,e.sal
FROM
	emp e
JOIN
	dept d
ON
	e.deptno = d.deptno
WHERE
	e.sal > (SELECT max(sal) FROM emp WHERE deptno = 30);

--26
SELECT
	d.deptno,ISNULL(t.ecount,0),ISNULL(t.avgsal,0),IFNULL(t.avgservicetime,0)
FROM
	(SELECT deptno, COUNT(*) as ecount, AVG(sal) as avgsal, AVG(TIMESTAMPDIFF(YEAR,hiredate,now())) as avgservicetime FROM emp GROUP BY deptno) as t
RIGHT JOIN
	dept d 
ON
	d.deptno = t.deptno;

--27
SELECT
	e.ename,d.dname,e.sal
FROM
	emp e 
JOIN
	dept d 
ON
	e.deptno = d.deptno;

--28
SELECT
	t.Cemployee,d.*
FROM
	(SELECT deptno,COUNT(*) AS Cemployee FROM emp GROUP BY deptno) as t
RIGHT JOIN
	dept d
ON
	t.deptno = d.deptno;

--29
SELECT
	t.minsal,e.ename,e.job
FROM
	(SELECT job,MIN(sal) as minsal FROM emp GROUP BY job) as t
JOIN
	emp e 
ON
	e.sal = t.minsal;

--30
SELECT 
	deptno,MIN(sal)
FROM
	emp
WHERE
	job = 'MANAGER'
GROUP BY
	deptno;

--31
SELECT
	ename,(sal+IFNULL(comm,0))*12 as yearsal
FROM
	emp
ORDER BY
	yearsal;

--32
SELECT
	e1.ename as employees, e2.ename as employer
FROM
	emp e1
JOIN
	emp e2
ON
	e1.mgr = e2.empno
WHERE
	e2.sal>3000;

--33
SELECT 
	IFNULL(COUNT(empno),0) as count, dname, IFNULL(SUM(sal),0) as sumsal
FROM
	dept d
LEFT JOIN
	emp e
ON
	e.deptno = d.deptno
WHERE
	d.dname LIKE '%S%'
GROUP BY
	d.dname;

--34
UPDATE emp SET sal = sal/1.1 WHERE TIMESTAMPDIFF(year,hiredate,now()) > 30;

+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
+--------+------------+----------+
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |
+--------+------------+----------+

+-------+-------+-------+
| GRADE | LOSAL | HISAL |
+-------+-------+-------+
|     1 |   700 |  1200 |
|     2 |  1201 |  1400 |
|     3 |  1401 |  2000 |
|     4 |  2001 |  3000 |
|     5 |  3001 |  9999 |
+-------+-------+-------+

+-------+--------+-----------+------+------------+---------+---------+--------+
| EMPNO | ENAME  | JOB       | MGR  | HIREDATE   | SAL     | COMM    | DEPTNO |
+-------+--------+-----------+------+------------+---------+---------+--------+
|  7369 | SMITH  | CLERK     | 7902 | 1980-12-17 |  800.00 |    NULL |     20 |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1981-02-20 | 1600.00 |  300.00 |     30 |
|  7521 | WARD   | SALESMAN  | 7698 | 1981-02-22 | 1250.00 |  500.00 |     30 |
|  7566 | JONES  | MANAGER   | 7839 | 1981-04-02 | 2975.00 |    NULL |     20 |
|  7654 | MARTIN | SALESMAN  | 7698 | 1981-09-28 | 1250.00 | 1400.00 |     30 |
|  7698 | BLAKE  | MANAGER   | 7839 | 1981-05-01 | 2850.00 |    NULL |     30 |
|  7782 | CLARK  | MANAGER   | 7839 | 1981-06-09 | 2450.00 |    NULL |     10 |
|  7788 | SCOTT  | ANALYST   | 7566 | 1987-04-19 | 3000.00 |    NULL |     20 |
|  7839 | KING   | PRESIDENT | NULL | 1981-11-17 | 5000.00 |    NULL |     10 |
|  7844 | TURNER | SALESMAN  | 7698 | 1981-09-08 | 1500.00 |    0.00 |     30 |
|  7876 | ADAMS  | CLERK     | 7788 | 1987-05-23 | 1100.00 |    NULL |     20 |
|  7900 | JAMES  | CLERK     | 7698 | 1981-12-03 |  950.00 |    NULL |     30 |
|  7902 | FORD   | ANALYST   | 7566 | 1981-12-03 | 3000.00 |    NULL |     20 |
|  7934 | MILLER | CLERK     | 7782 | 1982-01-23 | 1300.00 |    NULL |     10 |
+-------+--------+-----------+------+------------+---------+---------+--------+

