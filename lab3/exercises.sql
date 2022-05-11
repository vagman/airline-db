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


-- Βρείτε το Μ.Ο. των μισθών κάθε τμήματος.
select dept_name, round(avg(salary)) as average_salary
from instructor
group by dept_name;

-- Βρείτε τον αριθμό των καθηγητών σε κάθε τμήμα που δίδαξαν ένα μάθημα την Άνοιξη του 2010.
select dept_name, count(I.id) as sum_of_spring2010_instructors
from instructor as I natural join teaches as T
where T.semester = 'Spring' and T.year = '2010'
group by dept_name;

-- Βρείτε τα τμήματα όπου ο Μ.Ο. των μισθών των καθηγητών να είναι μεγαλύτερος από 42000.
select dept_name, round(avg(salary)) as average_salary_above_42k
from instructor
group by dept_name
having  avg(salary) >= 42000;

-- Βρείτε το άθροισμα του πλυθισμού ανά περιφέρεια (district). Να γίνει φθίνουσα αναπαράσταση 
-- του αποτελέσματος των 15 πρότων 
select district, sum(population) as district_population
from city
group by district
order by district_population desc limit 15;

-- Βρείτε τα μαθήματα που διδάχθηκαν το Φθινόπωρο του 2009 & την Άνοιξη του 2010.
(select course_id as fall_2009_courses
from section
where semester = 'Fall' and year = '2009' 
group by course_id)
intersect
(select course_id
from section
where semester = 'Spring' and year = '2010'
group by course_id
);

-- Another way with keyword "IN"...
select course_id as fall_2009_courses
from section
where semester = 'Spring' and year = 2010 and course_id in
    (select course_id
    from section
    where semester = 'Fall' and year = 2009);

-- Βρείτε τα ονόματα των καθηγητών των οποίων ο μισθός είναι μεγαλύτερος από
-- τουλάχιστον έναν καθηγητή του τμήματος Βιολογίας.
select I1.name, I1.salary
from instructor as I1, instructor as I2	
where I1.salary > I2.salary and I2.dept_name = 'Biology';

-- Another way
select name, salary
from instructor
where salary > some
	(select salary
	from instructor
	where dept_name = 'Biology');

-- Βρείτε τις πόλεις που ανεξαρτητιποιήθηκαν μετά το 1920 και βρίσκονται στην Ασιατική ύπειρο
select name
from city
where countryCode in 
	(select code
	from country
	where indepYear > 1920 and continent = 'Asia');

