-- 1) Βρείτε τα ονόματα των καθηγητών του παν/μίου.
select name
from instructor;

-- 2) Βρείτε τα ονόματα των τμημάτων των καθηγητών του παν/μίου.
select distinct dept_name
from instructor;

-- 3) Βρείτε τα ονόματα των καθηγητών στο τμήμα Computer Science που έχουν μισθόμεγαλύτερο από 70.000 €.
select name, salary
from instructor
where salary > 70000 and dept_name = 'Comp. Sci';

-- 4) Look at lab2 folder for the answer.