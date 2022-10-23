select *
from ipl_matches

ALTER TABLE `project1`.`ipl_matches` 
CHANGE COLUMN `Cities` `City` TEXT NULL DEFAULT NULL 

alter table ipl_matches
drop column matchdate

alter table ipl_matches
drop column superover

alter table ipl_matches
drop column season

alter table ipl_matches
drop column method

alter table ipl_matches
drop column matchdates

select *
from ipl_bb

