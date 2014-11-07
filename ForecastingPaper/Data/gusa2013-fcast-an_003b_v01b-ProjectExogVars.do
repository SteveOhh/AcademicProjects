//	file: 
		local Namedo "gusa2013-fcast-an_003b_v01a-ProjectExogVars"
//
//	task:	Intermediate forecast: project values to use as exogenous in final VAR model

//
//	author:
		local aut "\ sc \ 2014-01-31"

// Input datasets:

		local master		 "FinalGUSADataForecastProject"	//  Master Dataset for 2013 that has all of the variables needed for sources AND uses

										
* Opening tasks. 								
*
capture log close
clear all

***	***		***  Defining the directories	***		****

			cd							"G:\Research\Giving USA\GUSA 2013\Forecast Project\Work\Analysis"
			local datadirIN				"G:\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived"
			local logdir				"G:\Research\Giving USA\GUSA 2013\Forecast Project\Work\Analysis\Log Files"
			log using 					"`logdir'\\`Namedo'.log", replace
			local datadirOUT			"G:\Research\Giving USA\GUSA 2013\Forecast Project\Work\Analysis\Graph Output\ACs and PACs for X variables"


local datadirNamedo "`datadirOUT'\\`Namedo'"

adopath + C:\Docume~1\Admini~1\Mydocu~1\ado 

set more off

local tag "`Namedo'.do  `aut'"

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

use  "`datadirIN'\\`master'", clear	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	



*** choose variables to forecast separately -- these could be in AR models, a VAR model, or a combination
local ExogVars GRgdpIn2012Dol GRcorp_incIn2012Dol GRprsl_consIn2012Dol prsl_consIn2012Dol /*
*/ GRprsl_consIn2012Dol_sq GRspIn2012Dol GRspIn2012Dol_sq /*
here are the ones generated 2014-04-04: */  IndGivGusa CorpGivGusa person_incomeIn2012Dol corp_incIn2012Dol /*
*/ gdpIn2012Dol GRperson_incomeIn2012Dol spIn2012Dol{


* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Select ARIMA specification
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
/* don't need to do this every time

* Examine PAC & AC functions
foreach x in `ExogVars' {
ac `x'
graph save "`datadirOUT'\\`x'AC.gph", replace
pac `x'
graph save "`datadirOUT'\\`x'PAC.gph", replace
}
*/

* corp_tax: AR(1)
* FDcorp_tax: xxx
*** implies we need to model taxes and then calculate the FD
* tax_rate: AR(1)
* FDtax_rate: xxx
* recession: xxx
**** should run with and without recession, because we can't predict it with this data

* don't forget cross-validation

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Model exogenous variables
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

tsappend, add(2)

* For now, create simple AR models (will need to examine these more closely)
foreach var in `ExogVars' {
arima `var', ar(1)
predict `var'pred
}

* We're missing even more of these two (key) variables
foreach var in ItemIndGiv ItemCorpGiv {
arima `var', ar(1)
predict `var'pred
}

* Missing _less_ of this particular one
arima Cons_Sent, ar(1)
predict Cons_Sentpred

* Have tax info through 2014
foreach x in corp_tax tax_rate {
replace `x' = `x'[_n-1] if Year > 2014
}
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Project values 
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

foreach var in `ExogVars' {
replace `var' = `var'pred if Year > 2012
}

replace recession = Rec_Prob/100 if Year > 2012
replace recession = 0 if Year > 2013

replace Cons_Sent = Cons_Sentpred if Year > 2013



**** test
*replace GRTotGivGusaConfirmed = GRTotGivGusaConfirmed[_n-1] if Year > 2010
/*  Further data manipulation
*Project squared values separately, if needed

foreach var in  {
replace `var'_sq = (`var'pred)^2 if Year > 2012
}

*/


****************************


save "`datadirIN'\\DatasetWithProjectedXVars.dta", replace

	log close
	set more on
