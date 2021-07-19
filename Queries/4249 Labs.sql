--Trad4249 Labs

SELECT
	fp.Coid AS HospID
	,Substr(Cast(Cast(Trim(OTranslate(reg.Medical_Record_Num,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ,'')) AS INTEGER) + 135792468 + Cast(fp.Coid AS INTEGER) + 1000000000000 AS CHAR(13)),2,12) AS PtID
	,Cast((reg.Patient_DW_ID (Format '999999999999999999')) + 135792468 + Cast(fp.Coid AS INTEGER)AS DECIMAL(18,0)) AS AdmtID
	,CPPS.Specimen_Collection_Date - fp.Admission_Date AS Rel_Coll_Date
	,CPPS.Specimen_Collection_Time AS Coll_Time
	,CPPR.Result_Verify_Date - fp.Admission_Date AS Rel_Final_Report_Day
	,CPPR.Clinical_Proc_Num AS Proc_Num
	,RCTP.Clinical_Proc_Mnemonic_CS AS Proc_Mnem  
	,RCTP.Clinical_Proc_Name AS Proc_Name    
	,CPPR.Result_Answer_Text AS Result_Answer_Text
	,CPPR.Result_Normal_Range_Text AS  Result_Normal_Range_Text
	,CPPR.Result_UOM_Amt AS UOM
	,RCTP.Clinical_Proc_EMR_ID AS Clinical_Proc_EMR_ID
	,ncm.Standard_Code_Text AS Loinc_Code
	,lnc.LONG_NM AS Loinc_Code_Desc
FROM EDWCDM_Views.Fact_Patient fp

INNER JOIN qwu6617.Trad4249 pop		--update pop
	ON fp.Patient_DW_Id = pop.Patient_DW_Id
	AND fp.Company_Code = pop.Company_Code
	AND fp.Coid = pop.Coid

INNER JOIN EDWCL_Views.Clinical_Registration reg
	  ON fp.Patient_DW_Id = reg.Patient_DW_Id
	AND fp.CoID = reg.CoID
	AND fp.company_code = reg.company_code   

INNER JOIN EDWCL_VIEWS.Clinical_Patient_Proc_Specimen CPPS
	ON fp.Patient_DW_Id = CPPS.Patient_DW_Id
	AND fp.Company_Code = cpps.Company_Code
	AND fp.Coid = cpps.Coid

INNER JOIN EDWCL_VIEWS.Clinical_Patient_Proc_Result CPPR
	ON CPPR.Patient_DW_Id = CPPS.Patient_DW_Id
	AND CPPR.Specimen_URN=CPPS.Specimen_URN
	AND cppr.company_code = cpps.company_Code
	AND CPPR.COID = CPPS.COID
	AND CPPR.Clinical_System_Module_Code='LAB'
	AND CPPR.Result_Verify_Date BETWEEN '2018-01-01' AND '2021-01-01'	
	
INNER JOIN EDWCL_VIEWS.Ref_Clinical_Test_Procedure RCTP
	ON CPPR.COID = RCTP.COID
	AND CPPR.Clinical_Proc_Num = RCTP.Clinical_Proc_Num

LEFT JOIN EDWCL_Views.Ref_Clin_Test_Proc_Nomen tpn
	ON rctp.COID = tpn.COID
	AND rctp.Clinical_Proc_Num = tpn.Clinical_Proc_Num

LEFT JOIN EDWCL_Views.Ref_Nomenclature_Code_Map ncm
	ON tpn.COID = ncm.COID
	AND tpn.Nomenclature_Code = ncm.Nomenclature_Code
	AND ncm.Standard_Code_Type = 'LOINC'
	AND ncm.Standard_Code NOT  LIKE '%IMO%'
	AND ncm.Active_Ind = 'Y'

LEFT JOIN EDWCDM_Views.RSLT_CD lnc
	ON ncm.Standard_Code_Text = lnc.RSLT_CD
	AND VLD_TO_TS = '9999-12-31 00:00:00'
	
WHERE Proc_Mnem  in(
		'LD-1',
		'LD-2',
		'LD-3',
		'LD-4',
		'LD-5',
		'LDH',
		'LDH1',
		'LDH2',
		'LDH3',
		'LDH4',
		'LDH5',
		'LDHAS',
		'LDHCSF',
		'LDHFL',
		'LDHFLD',
		'LDHPL',
		'LDHT',
		'LDHTOT',
		'LD-TOTAL') 
OR (Proc_Mnem  in(
		'LIP',
		'LIPSRC',
		'ISTATHCT',
		'BG HCTV',
		'HCTI',
		'HCT',
		'POCHCTV',
		'HGBEVAL HCT',
		'FOLHCT',
		'HELHCT',
		'POC HCT',
		'CVOR HCT',
		'LIPFL',
		'HCT POC',
		'HCT NC',
		'AMY',
		'AMYFLD',
		'SO HCT',
		'BG HCT',
		'AMYTOT',
		'FOLRBCHCT') AND Rel_Coll_Date <'2')


GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

