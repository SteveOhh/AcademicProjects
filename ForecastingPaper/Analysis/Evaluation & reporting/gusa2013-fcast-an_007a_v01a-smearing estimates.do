//	file: 
		local Namedo "gusa2013-fcast-an_007a_v01a-smearing estimates"
//
//	task:  Make real giving predictions (and predictions for changes in levels
//			


//
//	author:
		local aut "\ sc \ 2014-04-25"

// Input datasets:

		local master		 "DatasetWithProjectedXVars.dta"	//  combined projected values dataset

										
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



********** need to merge forecasts to original dataset
merge 1:1 Year using "`datadirIN'\forecasts.dta"
drop _merge


* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Convert estimates back to amounts - smearing estimate procedure
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

*** individual
gen hX = exp(M1_5a2Fcast) if Year < 2011
gen Ratio = ItemIndGiv/L.ItemIndGiv // "Ratio" expressing giving as a % of last period's giving

qui reg Ratio hX, noconstant 

gen PredictedIndChange = exp(M1_5a2Fcast)*_b[hX] if Year > 2000
gen PredictedInd = PredictedIndChange*L.ItemIndGiv if Year == 2011
replace PredictedInd = PredictedIndChange*L.PredictedInd if Year > 2011

list M1_5a2Fcast ItemIndGiv PredictedInd PredictedIndChange Year if Year > 2000

list Ratio PredictedIndChange ItemIndGiv PredictedInd if Year > 2000

*** corporate
gen gX = exp(M1_5b2Fcast) if Year < 2011
gen cRatio = ItemCorpGiv/L.ItemCorpGiv // "Ratio" expressing giving as a % of last period's giving

qui reg cRatio gX, noconstant 

gen PredictedCorpChange = exp(M1_5b2Fcast)*_b[gX] if Year > 2000
gen PredictedCorp = PredictedCorpChange*L.ItemCorpGiv if Year == 2011
replace PredictedCorp = PredictedCorpChange*L.PredictedCorp if Year > 2011

list M1_5b2Fcast ItemCorpGiv PredictedCorp PredictedCorpChange Year if Year > 2000

list cRatio PredictedCorpChange ItemCorpGiv PredictedCorp if Year > 2000
****************************
****************************


	log close
	set more on
