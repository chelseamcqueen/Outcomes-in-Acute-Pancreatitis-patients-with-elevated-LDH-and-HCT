--Trad4249 HtWt code 

SELECT
cpv.Coid AS HospID,
Substr(Cast(Cast(Trim(OTranslate(reg.Medical_Record_Num,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ,'')) AS INTEGER) + 135792468 + Cast(cpv.Coid AS INTEGER) + 1000000000000 AS CHAR(13)),2,12) AS PtID,
Cast((cpv.Patient_DW_ID (Format '999999999999999999'))  + 135792468 + Cast(cpv.Coid AS INTEGER)AS DECIMAL(18,0)) AS AdmtID,
		cpv.Height_In_Feet_Amt,
		cpv.Height_In_Inches_Amt,
		cpv.Height_In_Centimeters_Amt,
		cpv.Weight_In_Pounds_Amt,
		cpv.Weight_In_Ounces_Amt,
		cpv.Weight_In_Kilograms_Amt
FROM	EDWCL_Views.Clinical_Patient_Vital cpv

INNER JOIN qwu6617.Trad4249 pop
ON cpv.Patient_DW_Id = pop.Patient_DW_Id
AND cpv.Coid = pop.Coid
AND cpv.Company_Code = pop.Company_Code

INNER JOIN EDWCL_Views.Clinical_Registration reg
ON cpv.Patient_DW_Id = reg.Patient_DW_Id
AND cpv.Coid = reg.Coid
AND cpv.Company_Code = reg.Company_Code

WHERE Cast(cpv.Entered_Date_Time AS DATE) - pop.Admission_Date < '2'

GROUP BY 1,2,3,4,5,6,7,8,9