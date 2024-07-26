select *
from study_performance
where math_score = 100


---------These are queries to know the insight of the impact of various fafctors on students during exams


-- Avg scores per gender --

select gender, avg(math_score) as math_score, avg(writing_score) as writing_score, avg(reading_score) as reading_score
from study_performance
group by gender

-------------------------------------------------------------------------------------------------------------------------------

-- Avg scores per Race --

select race_ethnicity, avg(math_score) as math_score, avg(writing_score) as writing_score, avg(reading_score) as reading_score
from study_performance
group by race_ethnicity

--------------------------------------------------------------------------------------------------------------------------------


--Overall Avg score per gender--

select gender, AVG(math_score) as MathAVg, AVG(writing_score) as WritingAvg, AVG(reading_score) as ReadingAvg,
       avg(reading_score + math_score + writing_score) as GenderAvg 
from study_performance
group by gender

----------------------------------------------------------------------------------

--Overall average score per race

select race_ethnicity,  AVG(math_score) as MathAVg, AVG(writing_score) as WritingAvg, AVG(reading_score) as ReadingAvg,
       avg(reading_score + math_score + writing_score) as RaceAvg
from study_performance
group by race_ethnicity

--------------------------------------------------------------------------------------------------------------------------------


--Parent education level impact on grades

select parental_level_of_education, avg(reading_score) as AvgReadingScore, avg(writing_score) as AvgWritingScore, avg(math_score) as AvgMathsScore
from study_performance
group by parental_level_of_education

----------------------------------------------------------------------------------------------------------------------------------------------------


-- test preparation impact -- This is know how students were affected by their prepartion. That is those were able to complete or didnt complete(none)

select gender, test_preparation_course, avg(math_score) as math_score, avg(writing_score) as writing_score, avg(reading_score) as reading_score,
count(case 
			when gender = 'male' and test_preparation_course = 'completed' then 1     -- is a string, so partition by couldn't count them individually.
			when gender = 'male' and test_preparation_course = 'none' then 1			-- hence i represented them with 1 for count to count all the once							
			when gender = 'female' and test_preparation_course = 'completed' then 1
			when gender = 'female' and test_preparation_course = 'none' then 1
	 end) GenderNumber 
from study_performance
group by test_preparation_course, gender
--------------------------------------------------------------------------------------------------------------------------------------------------


-- top scorers and number of people.  This is to know more insight about individuals who took the various exams

		--Math scolars--
select distinct (math_score), gender, race_ethnicity, count(math_score) NumOfStudent
from study_performance
group by math_score, gender, race_ethnicity
order by math_score desc

		--Reading scolars--
select distinct reading_score, gender, race_ethnicity, count(reading_score) as NumOfStudent
from study_performance
group by reading_score, gender, race_ethnicity
order by reading_score desc

		--Writing scolars--
select distinct(writing_score), gender, race_ethnicity, count(writing_score) NumOfStudent
from study_performance
group by writing_score, gender,race_ethnicity
order by writing_score desc

------------------------------------------------------------------------------------------------------------------------------------------------

-- Top ten(10) scorees--
select gender, race_ethnicity, parental_level_of_education, (math_score + reading_score + writing_score) as TotalMarks
from study_performance
order by 4 desc


SELECT gender, race_ethnicity, parental_level_of_education, lunch, TotalMarks
FROM (
    SELECT gender, race_ethnicity, parental_level_of_education, lunch, 
        math_score + reading_score + writing_score AS TotalMarks,
        ROW_NUMBER() OVER (ORDER BY math_score + reading_score + writing_score DESC) AS Rank
    FROM study_performance
) AS ranked_performance
WHERE Rank <= 10;

-----------------------------------------------------------------------------------------------------
select  gender, race_ethnicity, parental_level_of_education, lunch, total_marks
from (
	select gender, race_ethnicity, parental_level_of_education, lunch,
		math_score + reading_score + writing_score as total_marks,
		ROW_NUMBER() over (order by math_score + reading_score + writing_score asc) as rnk
	from study_performance
) as Bottom_10
where rnk <= 10

