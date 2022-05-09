-- Να εμφανιστεί το όνομα και ο πλυθισμός των πόλεων που το όνομα τους να ξεκινάει με 'Α' 
-- και μετά να ακολουθεί οποιοσδήποτε χαρακτήρας.
select name, population
from city
where name like 'A%';

-- Να εμφανιστεί το όνομα και ο πλυθισμός των πόλεων που το όνομα τους 
-- περιέχει κάποιο γράμμα, στη συνέχεια 'c' μικρό και στην συνέχεια οποιοσδήποτε άλλο σύνολο χαρακτήρων.
-- e.g. 'Accara', 'Achalpur', 'Oceanside'
select name, population
from city
where name like '_c%';

-- Να βρεθει το τμήμα το οποίιο έχει εντός του ονόματος του κτιρίου του
-- το λεκτικό 'Watson'
select dept_name
from department
where building like '%Watson%';

-- Να εμφανιστούν τα ονόματα των πόλεων με αύξουσα αλφαβητική σειρά
select name
from city
order by name

select name, salary, dept_name
from instructor
order by salary desc, name, dept_name;

-- between (logical operator) and comparison operators
select name
from instructor
where salary >= 90000 and salary <= 100000;

select name
from instructor
where salary between 90000 and 100000;

-- Σύνολο των μαθημάτων που διδάχθηκαν είτε το Φθινόπωρο του 2009 είτε την
-- Άνοιξη του 2010, είτε και τα δύο.
(select course_id
from section
where semester = 'Fall' and year = 2009)
union
(select course_id
from section
where semester = 'Spring' and year = 2010);

-- Σύνολο των μαθημάτων που διδάχθηκαν το Φθινόπωρο του 2009, καθώς επίσης και την Άνοιξη του 2010.

(select course_id
from section
where semester = 'Fall' and year = 2009)
intersect
(select course_id
from section
where semester = 'Spring' and year = 2010);

--Τα μαθήματα που διδάχθηκαν το Φθινόπωρο του 2009, αλλά όχι την Άνοιξη του 2010.
(select course_id
from section
where semester = 'Fall' and year = 2009)
except
(select course_id
from section
where semester = 'Spring' and year = 2010);

-- Aggregate functions: sum, avg, min, max
select avg (salary) as avg_salary
from instructor
where dept_name = 'Biology';

-- Πόσοι καθηγητές διδασκαν την άνοιξη του 2010
select count(distinct id)
from teaches
where semester = 'Spring' and year = 2010;







