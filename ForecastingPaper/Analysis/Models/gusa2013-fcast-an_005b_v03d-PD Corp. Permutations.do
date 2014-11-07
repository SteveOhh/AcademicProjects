//	file: 
		local Namedo "gusa2013-fcast-an_005b_v02a-2002 Partha Deb Corp. Permutations"
//
//	task:	Build upon base corporate giving model, for comparison
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
local Yvar GRItemCorpGiv



* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Create model 
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* this is a different Y variable (GR instead of FD), but the covariates are the same
local origXVars LD.ItemCorpGiv D.corp_incIn2012Dol LD.corp_incIn2012Dol D.gdpIn2012Dol LD.gdpIn2012Dol D.corp_tax LD.corp_tax
reg `Yvar' `origXVars' 
eststo Base // not necessary to put this in the table

* maybe copy above with GRs for everything
* other file has difference modeled as function of differences

* Permutation 1 (M1) *** best one ***
local newvars GRspIn2012Dol D.corp_tax GRcorp_incIn2012Dol GRgdpIn2012Dol
reg `Yvar' `newvars'
eststo M1

* (M2) -- recession isn't significant
local newvars2 GRspIn2012Dol D.corp_tax GRcorp_incIn2012Dol GRgdpIn2012Dol recession
reg `Yvar' `newvars2' 
eststo M2


* (M3) -- polynomial S&P isn't significant.
local newvars3 GRspIn2012Dol D.corp_tax GRcorp_incIn2012Dol GRgdpIn2012Dol GRspIn2012Dol_sq
reg `Yvar' `newvars3' 
eststo M3

* (M4) -- lag of Y isn't significant
local newvars4 GRspIn2012Dol D.corp_tax GRcorp_incIn2012Dol GRgdpIn2012Dol L.`Yvar'
reg `Yvar' `newvars4' 
eststo M4

* (M5) -- GDP lag isn't significant
local newvars5 GRspIn2012Dol D.corp_tax GRcorp_incIn2012Dol GRgdpIn2012Dol L.GRgdpIn2012Dol
reg `Yvar' `newvars5' 
eststo M5

* also tried with cons_sent/D.Cons_Sent too


***Export regression table
*estout, label c(b se _star p) wrap

esttab M1 M2 M3 M4 M5 using "`tabledir'\Corp. Models.rtf", gaps label replace /*
*/ star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) r2 ar2 aic compress
eststo clear



****************************
****************************


	log close
	set more on
