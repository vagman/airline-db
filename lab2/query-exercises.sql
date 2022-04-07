-- 4) Τι θα είχαμε, αν δίναμε αύξηση 10% σε κάθε καθηγητή;
select name, salary, salary * 1.1
from instructor;

-- 5) Βρείτε τους τίτλους των μαθημάτων στο τμήμα Computer Science που έχουν 3 πιστωτικές μονάδες.
select title, dept_name, credits
from course
where credits = '3' and dept_name = 'Comp. Sci.';

-- 6) Ανακαλέστε τα ονόματα των καθηγητών, μαζί με τα ονόματα των τμημάτων τους, καθώς και το όνομα του κτιρίου των τμημάτων τους.
select name, building, instructor.dept_name
from instructor, department
where instructor.dept_name = department.dept_name;

-- 7) Βρείτε τους καθηγητές του τμήματος Πληροφορικής που έχουν διδάξει κάποια μαθήματα.
select name, teaches.id, course_id
from instructor, teaches
where instructor.id = teaches.id and dept_name = 'Comp. Sci.';

-- 8) Για τους καθηγητές στο Πανεπιστήμιο που έχουν διδάξει κάποιο μάθημα, βρείτε τα ονόματά τους & το ID του μαθήματος των μαθημάτων που δίδαξαν.
select *
from instructor, teaches
where instructor.id = teaches.id;

-- 9) Βρείτε τον κωδικό καθηγητή και το όνομα του τμήματος των καθηγητών που σχετίζονται με ένα τμήμα με προϋπολογισμό μεγαλύτερο από 95000 €.
select department.dept_name, instructor.name, budget
from instructor, department
where instructor.dept_name = department.dept_name and budget > 95000;

-- 10) Αναφέρατε τα ονόματα των καθηγητών μαζί με τους τίτλους των μαθημάτων που διδάσκουν.
select distrinct name, title
from instructor, teaches, course
where instructor.id = teaches.id and teaches.course_id = course.course_id;

-- Second Part of the Lab:

-- 1) Για τους καθηγητές στο Πανεπιστήμιο που έχουν διδάξει κάποιο μάθημα, βρείτε τα 
-- ονόματά τους & το ID του μαθήματος των μαθημάτων που δίδαξαν. (natural join)
select *
from instructor natural join teaches;

-- 2) Αναφέρατε τα ονόματα των καθηγητών μαζί με τους τίτλους των μαθημάτων που
-- διδάσκουν.
select name, title
from instructor, teaches, course
where instructor.dept_name = course.dept_name and instructor.id = teaches.id;

select name, title
from (instructor natural join teaches) course using (course_id);

select name, title
from (instructor natural join teaches) join course using (course_id);

-- 3) Rename
-- here we rename 'name' with instructor_name'
select name as instructor_name, course_id
from instructor, teaches
where instructor.ID = teaches.ID;

-- 4) Βρες τους καθηγητές των οποίων ο μισθός είναι μεγαλύτερος απο το μισθό απο κάποιο
-- (τουλάχιστον 1) καθηγητή του τμήματος Βιολογίας
select I1.name, I1.salary
from instructor as I1, instructor as I2
where I1.salary > I2.salary and I2.dept_name = 'Biology';

-- 5) Να εμφανιστούν τα ονόματα των τμημάτων όπου το κτίριο που στεγάζονται έχει μέσα την λέξη 'Watson'
select dept_name
from department
where building like '%Watson%';

-- 6) Να εμφανιστούν τα ονόματα των πόλεων και των πλυθησμών τους όπου τα ονόματα της
-- πόλης ξεκινάνε απο 'Α' κεφαλαίο
select name, population
from city
where name like 'A%';