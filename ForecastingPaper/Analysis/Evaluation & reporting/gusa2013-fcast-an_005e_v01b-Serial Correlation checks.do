****** these are different than the forecast residuals

reg GRItemIndGiv D.prsl_consIn2012Dol D.tax_rate GRspIn2012Dol GRspIn2012Dol_sq L.ItemIndGiv
predict res, r
gen lres = res[_n-1]

*******************
corr lres res     
				  
dwstat

ac res
*******************


reg GRItemCorpGiv GRspIn2012Dol D.corp_tax GRcorp_incIn2012Dol GRgdpIn2012Dol
predict corpres, r
gen lcres = corpres[_n-1]

*******************
corr lcres corpres

dwstat

ac corpres
*******************


******** for forecast errors:
. foreach x in  res1 res2 res3 res4 res5 res6 res7 res8 res9 res10 {
  2. ac `x'
  3. }
}
  * DW stats are more annoying to create, bc they have to be run in Stata 13.
