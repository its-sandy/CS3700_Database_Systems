-- 1. List the parties who won in each constituency. If tie, report all parties with max votes
select maxv.ConstituencyId, p.Name from party as p,
(
	select c.ConstituencyId, c.PartyId, v.count from candidate as c,
	(select candidateId, count(*) as count from votes group by candidateId) as v
	where c.CandidateId = v.candidateId
) as v,
(
	select c.ConstituencyId, max(v.count) as maxcount from candidate as c,
	(select candidateId, count(*) as count from votes group by candidateId) as v
	where c.CandidateId = v.candidateId group by c.ConstituencyId	
) as maxv
where  v.ConstituencyId = maxv.ConstituencyId and v.count = maxv.maxcount and v.PartyId = p.PartyId;

-- 2. List the number of members in each Alliance. Parties not in an alliance are treated as an independent entity
select entity, count(*) as memberCount from partymembers as pm,
(
	(select p.PartyId, p.Name as entity from party as p where p.AllianceId is null)
	union
	(select p.PartyId, a.Name as entity from party as p, alliance as a where p.AllianceId = a.AllianceId)
) as e
where pm.PartyId = e.PartyId group by entity;

-- 3. List the cumulative count of votes cast in every hour of the day on all election days
select cast(substring(Vote_timestamp, 12, 2) as unsigned) as hour, count(*) as totalVotes from votes
group by hour order by hour;

-- 4. List of parties having more than 26 crore rupees in total asset value of party members
select p.Name, sum(c.Assets) as TotalAssets from party as p, candidate as c
where p.PartyId = c.PartyId group by p.Name having TotalAssets > 260000000;

-- 5. Order parties by higher probability of members becoming candidates
select p.Name, c.count/pm.count as SelectionProb from party as p, 
(select PartyId, count(*) as count from candidate group by PartyId) as c, 
(select PartyId, count(*) as count from partymembers group by PartyId) as pm 
where c.PartyId = p.PartyId and pm.PartyId = p.PartyId order by SelectionProb desc;

-- 6. List of parties with no candidates with criminal offences
select p.Name from party as p where not exists (
	select * from candidate as c where c.PartyId = p.PartyId and c.CriminalRecord != 'No crime history'
);

-- 7. List of voting centers that are monitored by female election officials and female election officials only
select distinct votingcenter from electionofficials
where votingcenter not in (select votingcenter from electionofficials where Sex != 'Female'); 

-- 8. List of election officials who have verified/ monitored both a voting center and a candidate in the same constituency
select distinct e.OfficialId, e.Name, c.ConstituencyId 
from electionofficials as e, votingcenter as vc, candidate as c, verification as ver
where e.votingcenter = vc.CenterId and vc.ConstituencyId = c.ConstituencyId 
and c.CandidateId = ver.CandidateId and ver.OfficialId = e.OfficialId; 

-- 9. Time when verification of all candidates of a given constituency got over, for each constituency
select c.ConstituencyId, max(v.verification_timestamp) as VerificationEndTime from candidate as c, verification as v
where c.CandidateId = v.CandidateId group by c.ConstituencyId;

-- 10. Identify the voting centers with no evms (i.e, without electronic voting)
select CenterId from votingcenter where CenterId not in (select VotingCenterId from evm);



