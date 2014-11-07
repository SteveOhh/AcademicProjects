//	file: 
		local Namedo "gusa2013-fcast-an_005a_v02a-2002 Partha Deb Ind. Permutations"
//
//	task:	Build upon PD base individual model for comparison
//		***version 03*** uses only itemized portion instead of all giving


//
//	author:
		local aut "\ sc \ 2014-03-14"

// Input datasets:

		local master		 "DatasetWithProjectedXVars"	//  Master Dataset for 2013 with projected values

										
* Opening tasks. 								
*
capture log close
clear all

***	***		***  Defining the directories	***		****

			cd							"G:\Research\Giving USA\GUSA 2013\Forecast Project\Work\Analysis"
			local datadirIN				"G:\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived"
			local logdir				"G:\Research\Giving USA\GUSA 2013\Forecast Project\Work\Analysis\Log Files"
			log using 					"`logdir'\\`Namedo'.log", replace
			local datadirOUT			"G:\Research\Giving USA\GUSA 2013\Forecast Project\Work\Analysis\Graph Output\WithExogVars"
			local tabledir				"G:\Research\Giving USA\GUSA 2013\Forecast Project\Work\Analysis\Table Output"


local datadirNamedo "`datadirOUT'\\`Namedo'"

adopath + C:\Docume~1\Admini~1\Mydocu~1\ado 
adopath ++ "G:\Research\StataAdoFiles"

set more off

local tag "`Namedo'.do  `aut'"

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

use  "`datadirIN'\\`master'", clear	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	



* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

*** Set up dependent variable and independent variables***

* Using GR of all corporate giving instead of just itemized
*** go back and create this variable in a separate file, once it's determined what we're actually using
local Yvar GRItemIndGiv


* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Create model 
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* this is a slightly different Y variable (GR instead of FD), but the covariates are the same
local origXVars LD.ItemIndGiv LD.person_incomeIn2012Dol D.person_incomeIn2012Dol D.spIn2012Dol D.tax_rate 
reg `Yvar' `origXVars' 
eststo Base // not necessary to put this in the table

* maybe copy above with GRs for everything
* other file has difference modeled as function of differences

* Best version - M1
local newvars1 D.prsl_consIn2012Dol D.tax_rate GRspIn2012Dol GRspIn2012Dol_sq L.`Yvar'
reg `Yvar' `newvars1' 
eststo M1

* (M2) without squared GDP
local newvars2 D.prsl_consIn2012Dol D.tax_rate GRspIn2012Dol L.`Yvar'
reg `Yvar' `newvars2' 
eststo M2

* (M3) 2 lags of Y
local newvars3 D.prsl_consIn2012Dol D.tax_rate GRspIn2012Dol GRspIn2012Dol_sq  L(1/2).`Yvar'
reg `Yvar' `newvars3' 
eststo M3

* (M4) lags with recession
local newvars4 D.prsl_consIn2012Dol D.tax_rate GRspIn2012Dol GRspIn2012Dol_sq L.`Yvar' recession
reg `Yvar' `newvars4'  
eststo M4

* (M5) trying consumer sentiment (level, D, and L don't change things)
local newvars5 D.prsl_consIn2012Dol D.tax_rate GRspIn2012Dol GRspIn2012Dol_sq L.`Yvar' Cons_Sent
reg `Yvar' `newvars5' 
eststo M5

/*
* (M6) GR of consumption doesn't help either
local newvars6 GRprsl_consIn2012Dol D.tax_rate GRspIn2012Dol GRspIn2012Dol_sq L.`Yvar'
reg `Yvar' `newvars6' 
*/

***Export regression table
esttab M1 M2 M3 M4 M5 using "`tabledir'\Ind. Models.rtf", gaps label replace /*
*/ star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) r2 aic ar2 compress
eststo clear


****************************
****************************


	log close
	set more on
