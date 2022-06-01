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
t1.ename
(
SELECT
DISTINCT e1.ename,e1.sal
FROM
emp e1
JOIN
emp e2
ON
e1.empno = e2.mgr;
)