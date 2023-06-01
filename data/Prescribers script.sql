--QUESTION 1: A
SELECT COUNT(total_claim_count), prescriber.npi
FROM prescription
 INNER JOIN prescriber
 ON prescription.npi=prescriber.npi
 GROUP BY prescriber.npi
 ORDER BY count DESC
 LIMIT 1;
 
 --QUESTION 1:B 
SELECT COUNT(total_claim_count),prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name,prescriber.specialty_description,prescriber.npi
FROM prescription
 	INNER JOIN prescriber
	 ON prescription.npi=prescriber.npi
	 GROUP BY prescriber.npi,prescriber.nppes_provider_first_name,prescriber.nppes_provider_last_org_name,prescriber.specialty_description
	 ORDER BY count DESC;
	 
--QUESTION 2:A
SELECT COUNT(total_claim_count),specialty_description
FROM prescription
INNER JOIN prescriber
ON prescription.npi=prescriber.npi
GROUP BY prescriber.specialty_description
ORDER BY count DESC;

--QUESTION 2:B

SELECT COUNT(total_claim_count), prescriber.specialty_description, drug.drug_name,drug.opioid_drug_flag,drug.long_acting_opioid_drug_flag
FROM prescription
INNER JOIN prescriber ON prescription.npi = prescriber.npi
INNER JOIN drug ON drug.drug_name = prescription.drug_name
WHERE drug.opioid_drug_flag='Y' OR drug.long_acting_opioid_drug_flag='Y'
GROUP BY prescriber.specialty_description, drug.drug_name,drug.opioid_drug_flag,drug.long_acting_opioid_drug_flag
ORDER BY count DESC;

--QUESTION 3:A
SELECT drug.generic_name,prescription.total_drug_cost
FROM drug
INNER JOIN prescription
ON drug.drug_name=prescription.drug_name
ORDER BY total_drug_cost DESC;
-- PIRFENIDONE
--QUESTION 3:b
SELECT drug.generic_name,ROUND(total_drug_cost/total_day_supply,2) AS cost_per_day
FROM drug
INNER JOIN prescription
ON drug.drug_name=prescription.drug_name
ORDER BY cost_per_day DESC;

--QUESTION 4:A
SELECT drug_name,
    CASE
        WHEN opioid_drug_flag = 'Y' THEN 'opioid'
        WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
        ELSE 'neither'
    END AS drug_type
FROM drug;

--QUESTION 4:B
SELECT
    CAST(SUM(CASE WHEN drug.opioid_drug_flag = 'Y' THEN prescription.total_drug_cost ELSE 0 END) AS MONEY) AS opioid_total_cost,
    CAST(SUM(CASE WHEN drug.antibiotic_drug_flag = 'Y' THEN prescription.total_drug_cost ELSE 0 END) AS MONEY) AS antibiotic_total_cost
FROM prescription
INNER JOIN drug ON prescription.drug_name = drug.drug_name;

--QUESTION 5:A
SELECT COUNT(cbsa),state
FROM cbsa
	INNER JOIN fips_county 
	ON cbsa.fipscounty=fips_county.fipscounty
WHERE state ILIKE '%TN%'
GROUP BY state,cbsa.cbsa
ORDER BY cbsa.cbsa DESC;
--10

--QUESTION 5:B
SELECT cbsa.cbsa,SUM(population) AS total_population,cbsaname AS name
FROM cbsa
	INNER JOIN population
	USING(fipscounty)
GROUP BY cbsa.cbsa,cbsaname 
ORDER BY cbsa DESC;
--Largest Nashville-Davidson--Murfreesboro--Franklin, TN
--Smallest Chattanooga, TN-GA

--QUESTION 5:c
SELECT population,fips_county.county
FROM population
	INNER JOIN fips_county
	USING(fipscounty)
ORDER BY population DESC;
--shelby

--QUESTION 6: A
SELECT drug_name,total_claim_count
FROM prescription
WHERE total_claim_count>=3000

--QUESTION 6:B
SELECT p.drug_name,p.total_claim_count,
	CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	ELSE 'not opioid'
	END AS drug_type
FROM prescription as p
INNER JOIN drug AS d
ON p.drug_name=d.drug_name
WHERE total_claim_count>=3000

--QUESTION 6:C
SELECT pr.nppes_provider_last_org_name,pr.nppes_provider_first_name,p.drug_name,p.total_claim_count,
	CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	ELSE 'not opioid'
	END AS drug_type
FROM prescription as p
INNER JOIN drug AS d
ON p.drug_name=d.drug_name
INNER JOIN prescriber as pr
ON pr.npi=p.npi
WHERE total_claim_count>=3000

--QUESTION 7:A
SELECT pr.npi, d.drug_name, pr.specialty_description, pr.nppes_provider_city
FROM prescriber AS pr 
CROSS JOIN drug AS d 
WHERE pr.specialty_description = 'Pain Management' AND pr.nppes_provider_city = 'NASHVILLE' AND d.opioid_drug_flag='Y'

--QUESTION 7:B
SELECT  pr.npi, d.drug_name,SUM(p.total_claim_count) AS total_claim
FROM prescriber as pr
CROSS JOIN drug AS d
LEFT JOIN prescription as p
ON p.npi=pr.npi
WHERE pr.specialty_description = 'Pain Management' AND pr.nppes_provider_city = 'NASHVILLE' AND d.opioid_drug_flag='Y'
GROUP BY pr.npi,d.drug_name
ORDER BY total_claim DESC;

--QUESTION 7:C
SELECT pr.npi, d.drug_name, COALESCE(SUM(p.total_claim_count), 0) AS total_claims
FROM prescriber AS pr
CROSS JOIN drug AS d
LEFT JOIN prescription AS p ON p.npi = pr.npi AND p.drug_name = d.drug_name
WHERE pr.specialty_description = 'Pain Management' AND pr.nppes_provider_city = 'NASHVILLE' AND d.opioid_drug_flag = 'Y'
GROUP BY pr.npi, d.drug_name
ORDER BY total_claims DESC;





