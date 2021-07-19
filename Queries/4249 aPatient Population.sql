--Patient Population

CREATE VIEW qwu6617.Trad4249 AS
SELECT
fp.Patient_DW_Id
,fp.Company_Code
,fp.Coid
,fp.Admission_Date
FROM EDWCDM_Views.Fact_Patient fp

INNER JOIN EDWCL_Views.Person_CL p
ON fp.Patient_Person_DW_Id = p.Person_DW_Id

INNER JOIN EDW_Pub_Views.Fact_Facility ff
ON fp.Coid = ff.Coid
AND ff.Division_Code = '00026' --Code for division
AND ff.LOB_Code = 'HOS' --Code for hospital
AND ff.COID_Status_Code = 'F' --Code for active facilities (i.e. not sold/closed)

INNER JOIN EDWCDM_PC_Views.Patient_Diagnosis  PD
ON	PD.Patient_DW_Id = FP.Patient_DW_Id  	   
AND PD.COID = FP.COID
AND PD.Diag_Mapped_Code NOT = 'Y'
AND pd.Diag_Cycle_Code = 'F'
AND pd.Diag_Rank_Num BETWEEN '1' AND '5'
AND (
	 (PD.Diag_Type_Code='0' AND pd.diag_code IN(
		'K850',
		'K8500',
		'K8501',
		'K8502',
		'K851',
		'K8510',
		'K8511',
		'K8512',
		'K852',
		'K8520',
		'K8521',
		'K8522',
		'K853',
		'K8530',
		'K8531',
		'K8532',
		'K858',
		'K8580',
		'K8581',
		'K8582',
		'K859',
		'K8590',
		'K8591',
		'K8592'
		)))

WHERE fp.Admission_Date BETWEEN '2018-01-01' AND '2021-01-01' --update date
AND fp.Discharge_Date BETWEEN '2018-01-01' AND '2021-01-01' --update date
AND ((Cast((Cast((fp.Admission_Date(Format'YYYY-MM')) AS CHAR(7)) || '-01') AS DATE) - Cast((Cast((p.Person_Birth_Date(Format'YYYY-MM')) AS CHAR(7)) || '-01') AS DATE))/365) >'17'
AND fp.Company_Code='H'
AND fp.final_bill_date <> '0001-01-01'
AND fp.final_bill_date IS NOT NULL
/*AND fp.Patient_Type_Code_Pos1 = 'I' */

GROUP BY 1,2,3,4