-- get to know my data
use md_water_services;
show tables;

select * from location;
select * from visits;
show columns  from water_source;
select * from water_source;

-- get to know the unique water sources offered in maji ndogo
select distinct type_of_water_source from water_source;

-- get to see if they are places where one spends a long time in the queue
select * from visits
where time_in_queue > 500;

-- investigate what type of water sources take this long to queue for
-- I'll take a couple of source_ids from the previous result namely AkKi00881224 ,SoRu37635224 ,SoRu36096224
-- when we run the query below we will see that the type of water source taking this long to queue for is the shared tap

select * from water_source
where source_id in ('AkKi00881224' ,'SoRu37635224' ,'SoRu36096224');


/* Assessing the quality of water sources:
-- They assigned a score to each source from 1, being terrible, to 10 for a good, clean water source in a home. Shared taps are not rated as high, and the score also depends on how long the queue times are.
-- check to find records where the subject_quality_score is 10, only looking for home taps and where the source was visited a second time. */
select * from water_source where type_of_water_source = 'tap_in_home';

select * from water_quality where subjective_quality_score = 10;

select * from visits where visit_count = 2;


select ws.type_of_water_source, v.visit_count, wq.subjective_quality_score
from visits as v
inner join water_quality as wq
on v.record_id = wq.record_id
left join water_source as ws
on ws.source_id = v.source_id
where wq.subjective_quality_score = 10 and v.visit_count = 2;

/* There are 218 rows of data. This should not be the case. I think some of the employees may have made mistakes. 
 I would recommend that they appoint an Auditor to check some of the data independently, and make sure they have the right information*/
 
 
 -- 5. Investigate pollution issues:
 -- I also will write a query to check if the results are Clean but the biological column is > 0.01.
select * from well_pollution;

select * from well_pollution
where biological > 0.01 and results = 'Clean';

/*There seems like we have some inconsistencies in how the well statuses are recorded. 
Specifically , there could be a data input personnel that might have mistaken the description field for determining the clean-liness of the water.
I will look at the description and identify the records that mistakenly have the word Clean in the description.
The query below returned 38 wrong descriptions.*/

select * from well_pollution
where biological > 0.01 and results = 'Clean' and description like '%Clean%';

-- Cleaning
/* Case 1a: Update descriptions that mistakenly mention `Clean Bacteria: E. coli` to `Bacteria: E. coli`
   Case 1b: Update the descriptions that mistakenly mention `Clean Bacteria: Giardia Lamblia` to `Bacteria: Giardia Lamblia
   Case 2: Update the `result` to `Contaminated: Biological` where `biological` is greater than 0.01 plus current results is `Clean` */
   
SET SQL_SAFE_UPDATES = 0; 
  
update well_pollution set description = 'Bacteria: E. coli'
where description = 'Clean Bacteria: E. coli' ;

update well_pollution set description = 'Bacteria: Giardia Lamblia'
where description = 'Clean Bacteria: Giardia Lamblia' ;

update well_pollution set results = 'Contaminated: Biological' 
where biological > 0.01 AND results = 'Clean';
   





