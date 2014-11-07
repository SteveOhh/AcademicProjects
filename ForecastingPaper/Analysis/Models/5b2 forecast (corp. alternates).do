set more off

local datadirOUT			"\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Analysis\Graph Output\WithExogVars"


use "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\DatasetWithProjectedXVars.dta", clear


*** Set up dependent variable and independent variables***
local Yvar GRItemCorpGiv
label var GRItemCorpGiv "Corp. Itemized Giving (GR)"


* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Create model 
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	


* Permutation 1 (M1) *** best one ***
local newvars GRspIn2012Dol D.corp_tax GRcorp_incIn2012Dol GRgdpIn2012Dol
qui reg `Yvar' `newvars'
eststo M1

* (M2) -- recession isn't significant
local newvars2 GRspIn2012Dol D.corp_tax GRcorp_incIn2012Dol GRgdpIn2012Dol recession
qui reg `Yvar' `newvars2' 
eststo M2


* (M3) -- polynomial S&P isn't significant.
local newvars3 GRspIn2012Dol D.corp_tax GRcorp_incIn2012Dol GRgdpIn2012Dol GRspIn2012Dol_sq
qui reg `Yvar' `newvars3' 
eststo M3

* (M4) -- lag of Y isn't significant
local newvars4 GRspIn2012Dol D.corp_tax GRcorp_incIn2012Dol GRgdpIn2012Dol L.`Yvar'
qui reg `Yvar' `newvars4' 
eststo M4

* (M5) -- GDP lag isn't significant
local newvars5 GRspIn2012Dol D.corp_tax GRcorp_incIn2012Dol GRgdpIn2012Dol L.GRgdpIn2012Dol
qui reg `Yvar' `newvars5' 
eststo M5



* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Predict
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	


***************** new forecast ***
forecast create GivModel1, replace

forecast estimates M1

* Declaring variables exogenous gets Stata to ensure that there are no nonmissing values; 
* it shouldn't change anything if they are 100% exogenous (which is a strong assumption)
* If this is left out, these variables can be forecast along with the dependent variable


forecast solve, prefix(p_) begin(2001) end(2015)
label var p_GRItemCorpGiv "Model 1"

tsline p_GRItemCorpGiv `Yvar' if tin(2001,2015), xtitle(Year) yti(Growth Rate) scheme(economist)
graph save "`datadirOUT'\5b2_M1.gph", replace

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Evaluate model *
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

* Portmanteau test for white noise (reject if, say, p < .05)
predict res6 if tin(2000, 2010), res 

*** save the important parts for forecast evaluation

rename p_GRItemCorpGiv M1_5b2Fcast
preserve
keep Year GRItemCorpGiv M1_5b2Fcast res6

***save
saveold "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\5b2_M1forecast.dta", replace 
restore


**********************************
***************** new forecast ***
**********************************
forecast create GivModel2, replace

forecast estimates M2

forecast solve, prefix(p_) begin(2001) end(2015)
label var p_GRItemCorpGiv "Model 2"

tsline p_GRItemCorpGiv `Yvar' if tin(2001,2015), xtitle(Year) yti(Growth Rate) scheme(economist)
graph save "`datadirOUT'\5b2_M2.gph", replace

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Evaluate model *
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

* Portmanteau test for white noise (reject if, say, p < .05)
predict res7 if tin(2000, 2010), res 

*** save the important parts for forecast evaluation

rename p_GRItemCorpGiv M2_5b2Fcast
preserve
keep Year M2_5b2Fcast res7

***save
saveold "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\5b2_M2forecast.dta", replace 
restore


**********************************
***************** new forecast ***
**********************************

forecast create GivModel3, replace

forecast estimates M3

forecast solve, prefix(p_) begin(2001) end(2015)
label var p_GRItemCorpGiv "Model 3"

tsline p_GRItemCorpGiv `Yvar' if tin(2001,2015), xtitle(Year) yti(Growth Rate) scheme(economist)
graph save "`datadirOUT'\5b2_M3.gph", replace

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Evaluate model *
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

* Portmanteau test for white noise (reject if, say, p < .05)
predict res8 if tin(2000, 2010), res 

*** save the important parts for forecast evaluation

rename p_GRItemCorpGiv M3_5b2Fcast
preserve
keep Year M3_5b2Fcast res8

***save
saveold "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\5b2_M3forecast.dta", replace 
restore


**********************************
***************** new forecast ***
**********************************
forecast create GivModel4, replace

forecast estimates M4

forecast solve, prefix(p_) begin(2001) end(2015)
label var p_GRItemCorpGiv "Model 4"

tsline p_GRItemCorpGiv `Yvar' if tin(2001,2015), xtitle(Year) yti(Growth Rate) scheme(economist)
graph save "`datadirOUT'\5b2_M4.gph", replace

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Evaluate model *
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

* Portmanteau test for white noise (reject if, say, p < .05)
predict res9 if tin(2000, 2010), res 

*** save the important parts for forecast evaluation

rename p_GRItemCorpGiv M4_5b2Fcast
preserve
keep Year M4_5b2Fcast res9

***save
saveold "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\5b2_M4forecast.dta", replace 
restore


**********************************
***************** new forecast ***
**********************************
forecast create GivModel5, replace

forecast estimates M5

forecast solve, prefix(p_) begin(2001) end(2015)
label var p_GRItemCorpGiv "Model 5"

tsline p_GRItemCorpGiv `Yvar' if tin(2001,2015), xtitle(Year) yti(Growth Rate) scheme(economist)
graph save "`datadirOUT'\5b2_M5.gph", replace

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Evaluate model *
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

* Portmanteau test for white noise (reject if, say, p < .05)
predict res10 if tin(2000, 2010), res 

*** save the important parts for forecast evaluation

rename p_GRItemCorpGiv M5_5b2Fcast
preserve
keep Year M5_5b2Fcast res10

***save
saveold "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\5b2_M5forecast.dta", replace 
restore
