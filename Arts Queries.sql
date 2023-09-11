/* 
Having previously cleaned the data in Excel, I begin here with further data preparation steps.
The most significant step is using the survey codebook to put meaning to the number values.

I then ask a series of questions about correlations in the data between attendance and participation
in artistic events with various respondent traits.

Finally, each query is followed by a summary of the results and possible application.
*/

USE ArtsData;


SELECT TOP 3 * FROM arts;


-- deleting a few columns I found less useful than expected last time I explored this data
ALTER TABLE arts
DROP COLUMN Nativity,
	Mother_Nativity,
	Father_Nativity,
	Union_member,
	Household_Changes,
	Division,
	Region,
	Own_or_Rent;


-- Quick check for fluke values (double-checking how I prepared the data and if it imported cleanly)
SELECT CASEID, Spanish_Speaker /*Spanish_Speaker should be a fully-populated binary column*/
FROM arts
WHERE Spanish_Speaker IS NULL OR Spanish_Speaker NOT IN (0,1);
-- No rows returned. Good to go.


-- Assigning meaning to number values

--- Preparing a few columns for the new data types
ALTER TABLE arts
ALTER COLUMN Spanish_Speaker VARCHAR(3);
ALTER TABLE arts
ALTER COLUMN Family_Income VARCHAR(30);
ALTER TABLE arts
ALTER COLUMN Household_Size VARCHAR(30);
ALTER TABLE arts
ALTER COLUMN Household_Type VARCHAR(30);
ALTER TABLE arts
ALTER COLUMN Marital_Status VARCHAR(30);
ALTER TABLE arts
ALTER COLUMN Sex VARCHAR(30);
ALTER TABLE arts
ALTER COLUMN Veteran VARCHAR(30);
ALTER TABLE arts
ALTER COLUMN Education_Level VARCHAR(50);
ALTER TABLE arts
ALTER COLUMN Race VARCHAR(30);
ALTER TABLE arts
ALTER COLUMN Citizenship VARCHAR(30);
ALTER TABLE arts
ALTER COLUMN Employment_Status VARCHAR(30);
ALTER TABLE arts
ALTER COLUMN Multiple_Jobs VARCHAR(30);
ALTER TABLE arts
ALTER COLUMN Job_Type VARCHAR(50);
ALTER TABLE arts
ALTER COLUMN Children_by_Age VARCHAR(30);

--- And finally putting the information into the tables
---- (ELSE clauses included to avoid NULLing database if query is run a second time)
UPDATE arts
SET 
Spanish_Speaker = 
	CASE
		WHEN Spanish_Speaker = 0 THEN 'No'
		WHEN Spanish_Speaker = 1 THEN 'Yes'
		ELSE Spanish_Speaker
	END,
Family_Income = 
	CASE
		WHEN Family_Income = 1 THEN '<5,000'
		WHEN Family_Income BETWEEN 2 AND 6 THEN '5,000-19,999'
		WHEN Family_Income BETWEEN 7 AND 10 THEN '20,000-39,999'
		WHEN Family_Income BETWEEN 11 AND 12 THEN '40,000-59,999'
		WHEN Family_Income BETWEEN 13 AND 14 THEN '60,000-99,999'
		WHEN Family_Income BETWEEN 15 AND 16 THEN '>100,000'
		ELSE Family_Income
	END,
Household_Type = 
	CASE
		WHEN Household_Type IN (0,8,9,10) THEN NULL
		WHEN Household_Type IN (1,2) THEN 'Married'
		WHEN Household_Type BETWEEN 3 AND 5 THEN 'Unmarried'
		WHEN Household_Type IN (6,7) THEN 'Single Parent'
		ELSE Household_Type
	END,
Marital_Status =
	CASE
		WHEN Marital_Status IN (1,2) THEN 'Married'
		WHEN Marital_Status = 3 THEN 'Widowed'
		WHEN Marital_Status IN (4,5) THEN 'Separated'
		WHEN Marital_Status = 6 THEN 'Never Married'
		ELSE Marital_Status
	END,
Sex =
	CASE
		WHEN Sex = 1 THEN 'Male'
		WHEN Sex = 2 THEN 'Female'
		ELSE Sex
	END,
Veteran =
	CASE
		WHEN Veteran = 1 THEN 'Yes'
		WHEN Veteran = 2 THEN 'No'
		ELSE Veteran
	END,
Education_Level = 
	CASE
		WHEN Education_Level BETWEEN 31 AND 38 THEN '< High School'
		WHEN Education_Level = 39 THEN 'High School or GED'
		WHEN Education_Level  = 40 THEN 'Some College, No Degree'
		WHEN Education_Level IN (41,42) THEN 'Associate Degree'
		WHEN Education_Level = 43 THEN 'Bachelor''s Degree'
		WHEN Education_Level = 44 THEN 'Master''s Degree'
		WHEN Education_Level IN (45,46) THEN 'Professional or Doctorate Degree'
		ELSE Education_Level
	END,
Race = 
	CASE
		WHEN Race = 1 THEN 'White'
		WHEN Race = 2 THEN 'Black'
		WHEN Race = 3 THEN 'American Indian'
		WHEN Race = 4 THEN 'Asian'
		WHEN Race = 5 THEN 'Pacific Islander'
		WHEN Race BETWEEN 6 AND 26 THEN 'Mixed'
		ELSE Race
	END,
Citizenship = 
	CASE
		WHEN Citizenship BETWEEN 1 AND 3 THEN 'Native'
		WHEN Citizenship = 4 THEN 'Naturalized'
		WHEN Citizenship = 5 THEN 'Non-Citizen'
		ELSE Citizenship
	END,
Employment_Status =
	CASE
		WHEN Employment_Status IN (1,2) THEN 'Employed'
		WHEN Employment_Status IN (3,4) THEN 'Unemployed'
		WHEN Employment_Status = 5 THEN 'Retired'
		WHEN Employment_Status = 6 THEN 'Disabled'
		WHEN Employment_Status = 7 THEN 'Not in labor force'
		ELSE Employment_Status
	END,
Multiple_Jobs = 
	CASE
		WHEN Multiple_Jobs = 1 THEN 'Yes'
		WHEN Multiple_Jobs = 2 THEN 'No'
		ELSE Multiple_Jobs
	END,
Job_Type =
	CASE
		WHEN Job_Type = 1 THEN 'Management'
		WHEN Job_Type = 2 THEN 'Business and Finances'
		WHEN Job_Type = 3 THEN 'Computer and Mathematics'
		WHEN Job_Type = 4 THEN 'Architecture and Engineering'
		WHEN Job_Type = 5 THEN 'Life, Physical, Social Science'
		WHEN Job_Type = 6 THEN 'Community and Social Service'
		WHEN Job_Type = 7 THEN 'Legal'
		WHEN Job_Type = 8 THEN 'Education, Training, Library'
		WHEN Job_Type = 9 THEN 'Arts, Entertainment, Sports'
		WHEN Job_Type = 10 THEN 'Healthcare Practice and Technical'
		WHEN Job_Type = 11 THEN 'Healthcare Support'
		WHEN Job_Type = 12 THEN 'Protective Service'
		WHEN Job_Type = 13 THEN 'Food Preparation and Serving'
		WHEN Job_Type = 14 THEN 'Building and Grounds'
		WHEN Job_Type = 15 THEN 'Personal Care'
		WHEN Job_Type = 16 THEN 'Sales'
		WHEN Job_Type = 17 THEN 'Office Administration'
		WHEN Job_Type = 18 THEN 'Farming, Fishing, Forestry'
		WHEN Job_Type = 19 THEN 'Construction and Extraction'
		WHEN Job_Type = 20 THEN 'Installation, Maintenance, Repair'
		WHEN Job_Type = 21 THEN 'Production'
		WHEN Job_Type = 22 THEN 'Transportation'
		WHEN Job_Type = 23 THEN 'Armed Forces'
		ELSE Job_Type
	END,
Children_by_Age =
	CASE
		WHEN Children_by_Age = 0 THEN 'No children'
		WHEN Children_by_Age = 1 THEN 'Young children'
		WHEN Children_by_Age = 2 THEN 'Older children'
		WHEN Children_by_Age = 3 THEN 'Teenaged Children'
		ELSE Children_by_Age
	END
;


SELECT TOP 3 * FROM arts;


/* Now for exploration. */

-- Q: Is there a relationship between race and one's tendency to use art in celebrating one's heritage?
SELECT Race,
	ROUND((CAST(SUM(CASE WHEN why_attend_Heritage = 1 THEN 1 ELSE 0 END) AS FLOAT)/
		SUM(CASE WHEN why_attend_Heritage IS NOT NULL THEN 1 ELSE 0 END)) * 100, 2) AS attendance,
	ROUND((CAST(SUM(CASE WHEN why_do_Heritage = 1 THEN 1 ELSE 0 END) AS FLOAT)/
		SUM(CASE WHEN why_do_Heritage IS NOT NULL THEN 1 ELSE 0 END)) * 100, 2) AS participation
FROM arts
GROUP BY Race
ORDER BY attendance DESC;
/* A: According to self-identification options available in the survey, Pacific Islanders topped the chart with 70% of respondents
attending an artisitic event to celebrate their heritage. White respondents were least likely to cite that as a reason at
a strong, but relatively low, 18%. Between them, in descending order, came American Indian, Asian, Black, and Mixed Heritage respondents. Citing heritage
as a reason to personally participate in the events followed a similar pattern, with participation percentages at roughly half 
of their respective attendance percentages.
	Therefore, appealing to heritage may be a powerful marketing option for any demographic, except perhaps White. Involving
heritage-centered aspects to an event may also be an effective way to help attendees associate strong emotions and memories
with the event, thereby encouraging repeat visits and word-of-mouth advertising. */


-- How does education history relate to tendency to use art as a means of learning?
SELECT Education_Level,
	ROUND((CAST(SUM(CASE WHEN why_attend_Learn = 1 THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*)) * 100, 2) AS attendance,
	ROUND((CAST(SUM(CASE WHEN why_do_Learn = 1 THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*)) * 100, 2) AS participation
FROM arts
GROUP BY Education_Level
ORDER BY attendance DESC;
/* A: Exactly the pattern one might expect: each step up in education level correlates to higher likelihood to 
cite learning as a motivation for art. Only 4% of respondents who hadn't graduated from high school cited this
reason for arts attendance, compared to 30% of Doctorate degree holders.
	Therefore, we see one aspect of the value in a university style education, where students are exposed to many
facets of life in a context of learning. Taking advantage of a penchant for learning by having artistic classes 
in school settings, as well as theaters and galleries in college towns, may be key to preserving the arts. */


-- Q: How does marital status relate to tendency to enter artistic settings for socialization?
SELECT Marital_Status,
	ROUND((CAST(SUM(CASE WHEN why_attend_Socialize = 1 THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*)) * 100, 2) AS attendance,
	ROUND((CAST(SUM(CASE WHEN why_do_Socialize = 1 THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*)) * 100, 2) AS participation
FROM arts
GROUP BY Marital_Status
ORDER BY attendance DESC;
/* A: Both metrics are highest for Never Married, then Married, then Separated, then Widowed. 
Differences are slight and >20% of patrons cite socialization as a motive, until a significant drop for the Widowed respondents.
	Therefore, events management may benefit from using the social aspect of their events as a marketing focus in general, 
but keep in mind that it may have less effect on the widowed population due perhaps to either age or a sense of loyalty. */

-- Q: Is the above due to age?
--- First exploring age vs art attendance for socialization
SELECT age,
	ROUND((CAST(SUM(CASE WHEN why_attend_Socialize = 1 THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*)) * 100, 2) AS attendance
FROM
	(SELECT 
		CASE 
			WHEN age >= 70 THEN '70+'
			WHEN age BETWEEN 60 AND 69 THEN '60-69'
			WHEN age BETWEEN 50 AND 59 THEN '50-59'
			WHEN age BETWEEN 40 AND 49 THEN '40-49'
			WHEN age BETWEEN 30 AND 39 THEN '30-39'
			WHEN age BETWEEN 20 AND 29 THEN '20-29'
			WHEN age IN (18,19) THEN '18-19'
		END AS age,
		why_attend_Socialize
	FROM arts) age_brackets
GROUP BY age
ORDER BY age;

--- Now age vs widowhood
SELECT age,
	ROUND((CAST(SUM(CASE WHEN Marital_Status = 'Widowed' THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*)) * 100, 2) AS widowhood
FROM
	(SELECT 
		CASE 
			WHEN age >= 70 THEN '70+'
			WHEN age BETWEEN 60 AND 69 THEN '60-69'
			WHEN age BETWEEN 50 AND 59 THEN '50-59'
			WHEN age BETWEEN 40 AND 49 THEN '40-49'
			WHEN age BETWEEN 30 AND 39 THEN '30-39'
			WHEN age BETWEEN 20 AND 29 THEN '20-29'
			WHEN age IN (18,19) THEN '18-19'
		END AS age,
		Marital_Status
	FROM arts) age_brackets
GROUP BY age
ORDER BY age;
/* A: Arts attendance for social purposes is fairly steady for each age bracket until a moderate drop off in the 70+ age bracket.
Meanwhile, widowhood increases by 2-4x with each step up in age bracket.
	Therefore, any affect of widowhood on the social appeal of artistic events does not appear to be due to age.
Other socially dissuasive traits that might be experienced with widowhood such as stress, poor mental health, and busyness 
would be common to the Separated respondents, thus it seems likely that the lower social motivation of widowed respondents 
in attending artistic events will be due to a sense of loyalty to the lost partner.
	While relevant marketing is possible, it would require considerable taste and sensitivity. */


-- Q: Do singers attend more musical theater than non-singers?

	--- Adding information from source data that I didn't include in original import
	EXEC sp_rename 'musicals.PEC1Q5A', 'mus_attend', 'COLUMN';
	EXEC sp_rename 'musicals.PEC1Q4A', 'opera_attend', 'COLUMN';

	UPDATE musicals
	SET mus_attend = NULL
	WHERE mus_attend NOT IN (1,2);

	UPDATE musicals
	SET opera_attend = NULL
	WHERE opera_attend NOT IN (1,2);
	
	UPDATE a
	SET a.num_Musicals = 0
	FROM arts a
	LEFT JOIN musicals m
	ON a.CASEID = m.CASEID
	WHERE a.num_Musicals IS NULL AND m.mus_attend = 2;

	UPDATE a
	SET a.num_Opera = 0
	FROM arts a
	LEFT JOIN musicals m
	ON a.CASEID = m.CASEID
	WHERE a.num_Opera IS NULL AND m.opera_attend = 2;

SELECT
	CASE WHEN do_you_Sing = 1 THEN 'Yes'
		 WHEN do_you_Sing = 2 THEN 'No' 
	END AS 'Do you sing?',
	COUNT(*) AS num_responses,
	SUM(CASE WHEN num_Musicals > 0 THEN 1 ELSE 0 END) AS musicals_attended,
	SUM(CASE WHEN num_Opera > 0 THEN 1 ELSE 0 END) AS operas_attended,
	ROUND(SUM(num_Musicals)/SUM(CASE WHEN num_Musicals IS NOT NULL THEN 1 ELSE 0 END), 2) AS musicals_per_respondent,
	ROUND(SUM(num_Opera)/SUM(CASE WHEN num_Opera IS NOT NULL THEN 1 ELSE 0 END), 2) AS operas_per_respondent
FROM arts
WHERE do_you_Sing IS NOT NULL
GROUP BY do_you_Sing;
/* A: Yes, self-described singers attend 2.5 x the musicals and 4 x the operas. In fact, despite nearly triple the 
number of respondents being non-singers, singers still account for a majority of opera tickets.
	Therefore, musical theater producers may benefit from marketing via other musical events, lessons providers,
and music colleges. */
	

-- Q: How does local access to artistic events relate to tendency to share one's own art via the internet?
WITH simplified_has_arts AS
	(
	SELECT CASEID,
		CASE WHEN community_Has_Arts_Opportunities IN (1,2) THEN 'Yes'
		 WHEN community_Has_Arts_Opportunities IN (3,4) THEN 'No'
		END AS opps
	FROM arts
	)
SELECT s.opps AS 'Many local opportunities', 
	ROUND((CAST(SUM(CASE WHEN a.Shared_Online = 1 THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*))*100, 2) AS 'Shared online'
FROM simplified_has_arts s
JOIN arts a 
ON s.CASEID = a.CASEID
WHERE community_Has_Arts_Opportunities IS NOT NULL
	AND Shared_Online IS NOT NULL
GROUP BY s.opps;
/* A: 15% of respondents who view local opportunities as being limited took their art online, compared to
11% of those who felt local art was more plentiful.
   Therefore, content creation services may benefit from targeted marketing in small, rural, or industrial communities,
though general marketing for the 11% of much larger communities would still bring greater returns. */


-- Q: Is there a relationship between income levels and repeat patronage of an art?
SELECT Family_Income, 
	COUNT(*) AS respondents_in_bracket,
	SUM(num_repeats) AS repeats_per_bracket,
	ROUND(CAST(SUM(num_repeats) AS FLOAT)/COUNT(*), 2) AS average_repeats
FROM arts
CROSS APPLY
	(SELECT (
		CASE WHEN num_Jazz > 1 THEN 1 ELSE 0 END
		+ CASE WHEN num_Latin > 1 THEN 1 ELSE 0 END
		+ CASE WHEN num_Classical > 1 THEN 1 ELSE 0 END
		+ CASE WHEN num_Opera > 1 THEN 1 ELSE 0 END
		+ CASE WHEN num_Musicals > 1 THEN 1 ELSE 0 END
		+ CASE WHEN num_Plays > 1 THEN 1 ELSE 0 END
		+ CASE WHEN num_Ballet > 1 THEN 1 ELSE 0 END
		+ CASE WHEN num_Dance > 1 THEN 1 ELSE 0 END
		+ CASE WHEN num_Other_Theater > 1 THEN 1 ELSE 0 END
		+ CASE WHEN num_Gallery > 1 THEN 1 ELSE 0 END
		) AS num_repeats
	) AS n
GROUP BY Family_Income
ORDER BY CASE Family_Income
	WHEN '<5,000' THEN 1
	WHEN '5,000-19,999' THEN 2
	WHEN '20,000-39,999' THEN 3
	WHEN '40,000-59,999' THEN 4
	WHEN '60,000-99,999' THEN 5
	WHEN '>100,000' THEN 6
	END;
/* A: Of the respondents who attended any sort of artistic event, just over 50% attended at least 
one type of event multiple times. Stated differently, the average respondent attended .5 event types
multiple times. There was no significant change to this between income brackets.
	Going further, many respondents attended multiple types of events multiple times. Accounting for this,
the numbers do rise significantly through the income brackets, with respondents who earn over 
$100,000/yr attending an average of .82 repeat events.
	Therefore, not only should it be beneficial to advertise one event at another similar event,
it may even be an ideal option for premium events to reach higher income attendants who are 
very likely to attend more events and be able to afford higher prices. */