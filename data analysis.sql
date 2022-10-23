select *
from ipl_bb

#Average team score for different teams
with cte as
(
select id,innings,BattingTeam,sum(total_run) as trn
from ipl_bb
group by id,innings,battingteam
)
select battingteam,round(avg(trn),2) as avg_score
from cte
group by battingteam

#average wicket taken for different teams
with cte1 as
(
select id,innings,BattingTeam,sum(iswicketdelivery) as wkt
from ipl_bb
group by id,innings,battingteam
)
select battingteam,round(avg(wkt),2) as avg_wkt
from cte1
group by battingteam

#Average Bowling Economic rate for different teams

with cte2 as (select id,innings,overs,count(ballnumber) as cnt_ball,battingteam 
from ipl_bb
group by id,innings,overs,battingteam),
cte3 as
(select battingteam,sum(total_run) as trn
from ipl_bb
group by battingteam)

select cte3.battingteam,cte3.trn/count(cte2.overs) as eco_teams
from cte3 join cte2 on
cte3.battingteam = cte2.battingteam
group by cte3.battingteam

#overall strike rate of different teams
select battingteam,(sum(total_run)/count(ballnumber))*100 as Team_sr
from ipl_bb
group by battingteam

#average of wickten fallen for each team
select battingteam,count(iswicketdelivery)/count(distinct(id)) as avg_wicketfallen
from ipl_bb
where iswicketdelivery <>0
group by battingteam

#number of runs in each category for different teams
with cte_0 as 
(select battingteam,count(batsman_run) as No_dot from ipl_bb where batsman_run = 0
group by battingteam),
cte_runs as (select battingteam,count(batsman_run) as No_singles from ipl_bb where batsman_run in (1,2,3)
group by battingteam),
cte_4 as (select battingteam,count(batsman_run) as No_fours from ipl_bb where batsman_run = 4 
group by battingteam),
cte_6 as (select battingteam,count(batsman_run) as No_six from ipl_bb where batsman_run = 6
group by battingteam),
cte_tl as ( select battingteam,count(batsman_run) as tl_ball from ipl_bb group by battingteam)

select cte_0.battingteam,tl_ball,No_dot,No_singles,No_fours,No_six
from cte_0 join cte_runs on
cte_0.battingteam = cte_runs.battingteam
join cte_4 on
cte_0.battingteam = cte_4.battingteam
join cte_6 on
cte_0.battingteam = cte_6.battingteam
join cte_tl on
cte_0.battingteam = cte_tl.battingteam

# Identifying bowling team for each matches and extrarun providing for each team
create view extraruns as (
with cte4 as (select id, team1,Team2, case when TossDecision = 'field' then tosswinner
end bow,
case when TossDecision = 'bat' then tosswinner
end bat
from ipl_matches),

cte5 as (select id, bow,
case when bat = team1 then team2
when bat =  team2 then team1 
end bow2
from cte4)

select 
case when bow is null then bow2
else bow
end bowling_team,sum(extras_run) as extra_run
from cte5 join ipl_bb on
cte5.id = ipl_bb.id
group by bowling_team)
select *
from extraruns

#top five batsman based on runs

select batter,sum(batsman_run) as total_run
from ipl_bb
group by batter
order by sum(batsman_run) desc
limit 5

#top bowlers based on wickets

select bowler,sum(iswicketdelivery) as total_wicket
from ipl_bb
where kind <> 'run out'
group by bowler 
order by total_wicket desc
limit 5

#tosswinner and match winner ratio
with cte6 as (
select count(*) as  total_matches,
 (select count(*)
from ipl_matches
where tosswinner <> winningteam) as toss_loss
,(
select count(*)
from ipl_matches
where tosswinner = winningteam) as toss_win
from ipl_matches
limit 1)

select toss_win/total_matches * 100 as win_per,toss_loss/total_matches*100 as loss_per
from cte6







