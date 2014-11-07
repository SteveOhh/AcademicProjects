set more off

	local datadirOUT	"\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Analysis\Graph Output\WithExogVars"


use "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\DatasetWithProjectedXVars.dta", clear



*** Set up dependent variable and independent variables***
local Yvar GRItemIndGiv
label var GRItemIndGiv "Ind. Itemized Giving (GR)"



* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Create model 
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Best version - M1
local newvars1 D.prsl_consIn2012Dol D.tax_rate GRspIn2012Dol GRspIn2012Dol_sq L.`Yvar'
qui reg `Yvar' `newvars1' 
eststo M1

* (M2) without squared GDP
local newvars2 D.prsl_consIn2012Dol D.tax_rate GRspIn2012Dol L.`Yvar'
qui reg `Yvar' `newvars2' 
eststo M2

* (M3) 2 lags of Y
local newvars3 D.prsl_consIn2012Dol D.tax_rate GRspIn2012Dol GRspIn2012Dol_sq  L(1/2).`Yvar'
qui reg `Yvar' `newvars3'
eststo M3

* (M4) lags with recession
local newvars4 D.prsl_consIn2012Dol D.tax_rate GRspIn2012Dol GRspIn2012Dol_sq L.`Yvar' recession
qui reg `Yvar' `newvars4'  
eststo M4

* (M5) trying consumer sentiment (level, D, and L don't change things)
local newvars5 D.prsl_consIn2012Dol D.tax_rate GRspIn2012Dol GRspIn2012Dol_sq L.`Yvar' Cons_Sent
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
label var p_GRItemIndGiv "Model 1"

tsline p_GRItemIndGiv `Yvar' if tin(2001,2015), xtitle(Year) yti(Growth Rate) scheme(economist) 
graph save "`datadirOUT'\5a2_M1.gph", replace

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Evaluate model *
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

* Portmanteau test for white noise (reject if, say, p < .05)
predict res1 if tin(2000, 2010), res 

*** save the important parts for forecast evaluation

rename p_GRItemIndGiv M1_5a2Fcast
preserve
keep Year GRItemIndGiv M1_5a2Fcast res1

***save
saveold "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\5a2_M1forecast.dta", replace 
restore


**********************************
***************** new forecast ***
**********************************
forecast create GivModel2, replace

forecast estimates M2

forecast solve, prefix(p_) begin(2001) end(2015)
label var p_GRItemIndGiv "Model 2"

tsline p_GRItemIndGiv `Yvar' if tin(2001,2015), xtitle(Year) yti(Growth Rate) scheme(economist)
graph save "`datadirOUT'\5a2_M2.gph", replace

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Evaluate model *
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

* Portmanteau test for white noise (reject if, say, p < .05)
predict res2 if tin(2000, 2010), res 

*** save the important parts for forecast evaluation

rename p_GRItemIndGiv M2_5a2Fcast
preserve
keep Year M2_5a2Fcast res2

***save
saveold "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\5a2_M2forecast.dta", replace 
restore


**********************************
***************** new forecast ***
**********************************
forecast create GivModel3, replace

forecast estimates M3

forecast solve, prefix(p_) begin(2001) end(2015)
label var p_GRItemIndGiv "Model 3"

tsline p_GRItemIndGiv `Yvar' if tin(2001,2015), xtitle(Year) yti(Growth Rate) scheme(economist)
graph save "`datadirOUT'\5a2_M3.gph", replace

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Evaluate model *
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

* Portmanteau test for white noise (reject if, say, p < .05)
predict res3 if tin(2000, 2010), res 

*** save the important parts for forecast evaluation

rename p_GRItemIndGiv M3_5a2Fcast
preserve
keep Year M3_5a2Fcast res3

***save
saveold "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\5a2_M3forecast.dta", replace 
restore


**********************************
***************** new forecast ***
**********************************
forecast create GivModel4, replace

forecast estimates M4

forecast solve, prefix(p_) begin(2001) end(2015)
label var p_GRItemIndGiv "Model 4"

tsline p_GRItemIndGiv `Yvar' if tin(2001,2015), xtitle(Year) yti(Growth Rate) scheme(economist)
graph save "`datadirOUT'\5a2_M4.gph", replace

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Evaluate model *
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

* Portmanteau test for white noise (reject if, say, p < .05)
predict res4 if tin(2000, 2010), res 

*** save the important parts for forecast evaluation

rename p_GRItemIndGiv M4_5a2Fcast
preserve
keep Year M4_5a2Fcast res4

***save
saveold "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\5a2_M4forecast.dta", replace 
restore


**********************************
***************** new forecast ***
**********************************
forecast create GivModel5, replace

forecast estimates M5

forecast solve, prefix(p_) begin(2001) end(2015)
label var p_GRItemIndGiv "Model 5"

tsline p_GRItemIndGiv `Yvar' if tin(2001,2015), xtitle(Year) yti(Growth Rate) scheme(economist)
graph save "`datadirOUT'\5a2_M5.gph", replace

* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* Evaluate model *
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	
* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	* *** *** *** *** *** *** *** *** *** *** *** *** *** *** *	

* Portmanteau test for white noise (reject if, say, p < .05)
predict res5 if tin(2000, 2010), res 

*** save the important parts for forecast evaluation

rename p_GRItemIndGiv M5_5a2Fcast
preserve
keep Year M5_5a2Fcast res5

***save
saveold "\\Client\G$\Research\Giving USA\GUSA 2013\Forecast Project\Work\Datasets\Derived\5a2_M5forecast.dta", replace 
restore

