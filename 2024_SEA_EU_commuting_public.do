** SAE-Special Issue. 2nd Submission. 
* New content: 
*1. Scatterplots with other data:
*2. Typologies: cluster analysis
*3. Econometrics: spline.


clear all

use "2024_SEA_EU_commuting_public.dta",replace

*************************************************************************************************^*
* Comparisons wiht other indicators
*************************************************************************************************^*

preserve

* We eliminate flows with distance > 1000 Km (they can not be accepted as commuting)

replace facebook = . if dist>1000
replace air_pas = . if dist>1000
replace train_pas = . if dist>1000

* We compute means across-years

bys i j: egen flow_mean=mean(flow)
bys i j: egen pass_mean_a=mean(air_pas)
bys i j: egen pass_mean_t=mean(train_pas)

* We drop the time dimension, keeping a cada par C2C

bys i j: drop if j==j[_n-1]
drop year

* Comparison with Facebook Conectivity Index
*drop if i == j

gen ln_facebook=ln(facebook+1)
gen ln_flow_mean=ln(flow_mean+1)

twoway scatter ln_facebook ln_flow_mean || lfit ln_facebook ln_flow_mean if dist<1000, title(Commuters vs Facebook, size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(scat_fflow_facebook, replace)
graph export scat_fflow_facebook.png, replace width(800) height(600)

* Comparison with Air Passengers
gen ln_pass_mean_a=ln(pass_mean_a+1)

twoway scatter ln_pass_mean_a ln_flow_mean|| lfit ln_pass_mean_a ln_flow_mean if dist<1000, title(Commuters vs Passengers Air (<1000 Km), size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(scat_fflow_pass_a, replace)
graph export scat_fflow_pass_a.png, replace width(800) height(600)

* Comparison with Train Passengers

gen ln_pass_mean_t=ln(pass_mean_t+1)

twoway scatter ln_pass_mean_t ln_flow_mean || lfit ln_pass_mean_t ln_flow_mean if dist<1000, title(Commuters vs Passengers Train (<1000 Km), size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(scat_fflow_pass_t, replace)
graph export scat_fflow_pass_t.png, replace width(800) height(600)

* Comparison with Train + Air Passengers

gen pass_mean_ta=(pass_mean_t + pass_mean_a)
gen ln_pass_mean_ta=ln(pass_mean_ta + 1)

twoway scatter ln_pass_mean_ta ln_flow_mean || lfit ln_pass_mean_ta ln_flow_mean if dist<1000, title(Commuters vs Passengers Train&Air (<1000 Km), size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(scat_fflow_pass_ta, replace)
graph export scat_fflow_pass_ta.png, replace width(800) height(600)

graph combine scat_fflow_facebook.gph scat_fflow_pass_a.gph scat_fflow_pass_t.gph scat_fflow_pass_ta.gph, xcommon ycommon xsize(1) ysize(1) cols(2) graphregion(ifcolor(white) fcolor(white) lcolor(white) icolor(white))
graph export fflow_comb_proves.png, replace

*************************************************************************

corr ln_flow_mean ln_facebook ln_pass_mean_a ln_pass_mean_t ln_pass_mean_ta if dist<1000

drop if i == j
corr ln_flow_mean ln_facebook ln_pass_mean_a ln_pass_mean_t ln_pass_mean_ta if dist<1000

restore

***********************************************************************************************
************************************************************************************************
* Check with the original flows of the LFS

preserve

keep if d_original_fls == 1

* We compute means accross years

replace facebook = . if dist>1000
replace air_pas = . if dist>1000
replace train_pas = . if dist>1000

bys i j: egen fls_flow_mean=mean(original_fls)
bys i j: egen flow_mean=mean(flow)
bys i j: egen pass_mean_a=mean(air_pas)
bys i j: egen pass_mean_t=mean(train_pas)

* We drop years, just keeping cross section for region-to-region flows

bys i j: drop if j==j[_n-1]
drop year

* Comparison with Facebook Conectivity Index
*drop if i == j
gen ln_fls_flow_mean=ln(fls_flow_mean+1)
gen ln_facebook=ln(facebook+1)
gen ln_flow_mean=ln(flow_mean+1)

twoway scatter ln_facebook ln_fls_flow_mean || lfit ln_facebook ln_fls_flow_mean if dist<1000, title(Commuters (LFS) vs Facebook, size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(lfs_scat_facebook, replace)
graph export lfs_scat_facebook.png, replace width(800) height(600)

* Comparison with Air Passengers
gen ln_pass_mean_a=ln(pass_mean_a+1)

twoway scatter ln_pass_mean_a ln_fls_flow_mean|| lfit ln_pass_mean_a ln_fls_flow_mean if dist<1000, title(Commuters (LFS) vs Passengers Air (<1000 Km), size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(lfs_scat_pass_a, replace)
graph export lfs_scat_pass_a.png, replace width(800) height(600)

* Comparison with Train Passengers

gen ln_pass_mean_t=ln(pass_mean_t+1)

twoway scatter ln_pass_mean_t ln_fls_flow_mean || lfit ln_pass_mean_t ln_fls_flow_mean if dist<1000, title(Commuters (LFS) vs Passengers Train (<1000 Km), size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(lfs_scat_pass_t, replace)
graph export lfs_scat_pass_t.png, replace width(800) height(600)

* Comparison with Train + Air Passengers

gen pass_mean_ta=(pass_mean_t + pass_mean_a)
gen ln_pass_mean_ta=ln(pass_mean_ta + 1)

twoway scatter ln_pass_mean_ta ln_fls_flow_mean || lfit ln_pass_mean_ta ln_fls_flow_mean if dist<1000, title(Commuters (LFS) vs Passengers Train&Air (<1000 Km), size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(lfs_scat_pass_ta, replace)
graph export lfs_scat_pass_ta.png, replace width(800) height(600)


* Comparison Original LFS with Final Commuting Dataset

twoway scatter ln_flow_mean ln_fls_flow_mean || lfit ln_flow_mean ln_fls_flow_mean if dist<1000, title(Commuters (Final) vs Commuters (Original: LFS)(<1000 Km), size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(lfs_scat_fflows, replace)
graph export lfs_scat_fflows.png, replace width(800) height(600)

*************************************************************************

corr ln_flow_mean ln_fls_flow_mean ln_facebook ln_pass_mean_a ln_pass_mean_t ln_pass_mean_ta if dist<1000

drop if i == j
corr ln_flow_mean ln_fls_flow_mean ln_facebook ln_pass_mean_a ln_pass_mean_t ln_pass_mean_ta if dist<1000


restore

*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
***************       COMPARISONS WITH COUNTRY SPECIFIC DATA ******************
*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

******************************************************************************
* Spain. Census. Inner flows. 2011
******************************************************************************

preserve

keep if year==2011
keep if c_i=="ES"&c_j=="ES"

sort i j

merge 1:1 i j using "Spain_census_2011.dta", keepusing(flow_spain)
drop if _merge==2
drop if _merge==1
drop _merge


* Comparison
*drop if i == j
gen ln_flow_spain=ln(flow_spain + 1)

twoway scatter ln_flow_spain ln_flow || lfit ln_flow_spain ln_flow, title(Commuters vs Census SPAIN.2011, size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(spain_intra_census_2011, replace)

graph export spain_intra_census_2011.png, replace width(800) height(600) 

corr ln_flow_spain ln_flow if year==2011

drop if i == j
corr ln_flow_spain ln_flow if year==2011 

restore


******************************************************************************
* Belgium. Persyn. Inner flows. 2010
******************************************************************************

preserve

keep if year==2010
keep if c_i=="BE"&c_j=="BE"

sort i j

merge 1:1 i j using "Persyn_Belgium_2010.dta", keepusing(flow_belgium)
drop if _merge==2
drop _merge


* Comparison
*drop if i == j
gen ln_flow_belgium=ln(flow_belgium+1)

twoway scatter ln_flow_belgium ln_flow || lfit ln_flow_belgium ln_flow, title(Commuters vs Belgium.2010, size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(belgium_intra_2010, replace)
graph export belgium_intra_2010.png, replace width(800) height(600) 

corr ln_flow_belgium ln_flow

drop if i == j
corr ln_flow_belgium ln_flow  

restore


******************************************************************************
* Switzerland. Mobility. Intranat flows. 2014 & 2018
******************************************************************************

preserve

keep if year == 2014
keep if c_i == "CH" | c_j == "CH"

sort i j

merge 1:1 i j using "Swiss_intranat_14_18.dta", keepusing(flow_swiss_2014)
drop if _merge==2
drop _merge


* Comparison
*drop if i == j
gen ln_flow_intra_swiss=ln(flow_swiss_2014+1)

twoway scatter ln_flow_intra_swiss ln_flow || lfit ln_flow_intra_swiss ln_flow, title(Commuters: final flows vs Official Swiss. Intranational. 2014, size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(swiss_intra_2014, replace)
graph export swiss_intra_2014.png, replace width(800) height(600)

corr ln_flow_intra_swiss ln_flow

drop if i == j
corr ln_flow_intra_swiss ln_flow  

restore


******************************************************************************
* Switzerland. Mobility. CH-DE-FR flows. 2014 & 2018
******************************************************************************

preserve

keep if year == 2014
keep if c_i == "CH" | c_j == "DE" | c_j == "FR"

sort i j

merge 1:1 i j using "Swiss_FR_DE_14_18.dta", keepusing(flow_CH_FR_DE_2014)
drop if _merge==2
drop _merge
drop if flow_CH_FR_DE_2014==.

* Comparison
*drop if i == j
gen ln_flow_CH_FR_DE=ln(flow_CH_FR_DE_2014+1)

twoway scatter ln_flow_CH_FR_DE ln_flow || lfit ln_flow_CH_FR_DE ln_flow, title(Commuters: final flows vs Official Switzerland-DE-FR.2014, size(vsmall)) xsize(1) ysize(1) xlab(5(5)10) ylab(5(5)20) xlabel(, grid labsize(small) angle(vertical)) ylabel(, labsize(small) angle(horizontal)) xtitle("") legend(on size(vsmall)) saving(swiss_CH_FR_DE_2014, replace)
graph export swiss_CH_FR_DE_2014.png, replace width(800) height(600) 

corr ln_flow_CH_FR_DE ln_flow

drop if i == j
corr ln_flow_CH_FR_DE ln_flow  

restore

*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
********************************** Cluster *************************************
*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

preserve
drop if c_i=="RO"
drop if c_j=="RO"

drop if i==j

***********************************************************************
********            INDICATORS                 ********
***************************************************************************

* We generate the flow variables
gen flow_type="International"
replace flow_type="Interregional" if c_i==c_j & i!=j
replace flow_type="Intraregional" if c_i==c_j & i==j
replace flow_type="International" if i=="ROW" & j=="ROW"

gen ee=flow
gen ie=inflow

*Totals year-origin-destination
bys year i j: egen double ee2=total(ee)
bys year i j: egen double ie2=total(ie)
bys year i j: drop if j==j[_n-1]
drop ee ie
rename ie2 ie
rename ee2 ee

*Totals origin-destination
bys i j: egen ee2=mean(ee)
bys i j: egen ie2=mean(ie)
bys i j: drop if j==j[_n-1]
drop ee ie year
rename ie2 ie
rename ee2 ee

* we drop "RoW"
drop if i=="ROW"

****    we build each indicator

*Ind 1: CONECTIVITY
*# of regions to which a region send employees internationally
replace ee=. if ee==0
replace ie=. if ie==0

bys i flow_type: egen I1_e=count(ee)
bys i: egen I1_et=count(ee)

bys i flow_type: egen I1_i=count(ie)
bys i: egen I1_it=count(ie)

*Ind 2: Intensity. # of outgoing commuters internationally

replace ee=0 if ee==.
replace ie=0 if ie==.

bys i flow_type: egen double I2_e=total(ee)
bys i: egen double I2_et=total(ee)

bys i flow_type: egen double I2_i=total(ie)
bys i: egen double I2_it=total(ie)


*Ind 3: Relative Intensity. % of outgoing commuters internationally

gen double I3_e=I2_e/I2_et
gen double I3_i=I2_i/I2_it

*Ind 4: Interregional Balance. 
*Ratio between the share of international outgoing commuters of the region / share of international outgoing commuters of the country

bys c_i flow_type: egen double ec=total(ee)
bys c_i: egen double ect=total(ee)

bys c_i flow_type: egen double ic=total(ie)
bys c_i: egen double ict=total(ie)

gen double sc_e=ec/ect
gen double sc_i=ic/ict
drop ec ect ic ict

gen double I4_e=I3_e/sc_e
gen double I4_i=I3_i/sc_i
drop sc_e sc_i

*Ind 5: Network selectivity
*Share of outgoing commuters to the main destination region abroad
gen double sh_ce=ee/I2_e

bys i flow_type: egen double I5=max(sh_ce)
drop sh_ce
replace I5=0 if I5==.

*Ind 6: External influence
*Inrternational outflows/inflows of the main incoming region

bys i flow_type: egen double max_i=max(ie)

gen double I6_2=I2_e/max_i
drop max_i

*Ind 6(version 2): Influencia externa
*Exportaciones/Importaciones internacionales

gen double I6=I2_e/I2_i

*Ind 7: Send-receive balance
* Balance comercial (exportaciones - importaciones)

gen I7=I2_e-I2_i

drop I1_et I1_i I2_it I2_i I3_i I4_i I1_it I2_et ee ie

rename I1_e I1
rename I2_e I2
rename I3_e I3
rename I4_e I4
*keep if flow_type=="International"
drop flow_type c_i c_j j
bys i: drop if i==i[_n-1]

replace I1=0 if I1==.
replace I2=0 if I2==.
replace I3=0 if I3==.
replace I4=0 if I4==.
replace I5=0 if I5==.
replace I6=0 if I6==.
replace I7=0 if I7==.

keep nut_i nut_j i I1 I2 I3 I4 I5 I6_2 I6 I7
save "Indicators_cluster_analysis.dta", replace


**************** CLUSTER ANALISIS ************************

*** 3 GROUPS

* ALL INTERREGIONAL FLOWS: FOR + OUTR

*clear all
*use "Indicators_cluster_analysis.dta"
drop I6_2

graph box I*, ysize() ylabel(, nogrid labsize(small)) graphregion(ifcolor(white) fcolor(white) lcolor(white) icolor(white)) ytitle(Thous. mill. euros (I2 and I7) Nº regions (I1) and % (I3-I6), size(small)) legend(ring() position() cols(4) order (1 "Indicator 1" 2 "Indicator 2" 3 "Indicator 3" 4 "Indicator 4" 5 "Indicator 5" 6 "Indicator 6" 7 "Indicator 7") size(small)) scheme() title()

egen I1_s=std(I1)
egen I2_s=std(I2)
egen I3_s=std(I3)
egen I4_s=std(I4)
egen I5_s=std(I5)
egen I6_s=std(I6)
egen I7_s=std(I7)

graph box I*_s, ysize() ylabel(, nogrid labsize(small)) graphregion(ifcolor(white) fcolor(white) lcolor(white) icolor(white)) ytitle(Standarized units) legend(ring() position() cols(4) order (1 "Indicator 1" 2 "Indicator 2" 3 "Indicator 3" 4 "Indicator 4" 5 "Indicator 5" 6 "Indicator 6" 7 "Indicator 7") size(small)) scheme() title()

cluster wardslinkage I*_s, measure(L2squared) name(cluster1)
cluster dendrogram cluster1, cutnumber(50) labels(i) xlabel(, angle(vertical) labsize(*.75)) name(cluster1)
cluster generate c1 = groups(3), name(cluster1)

graph box I*_s if c1==1, ysize() ylabel(, nogrid labsize(small)) yscale(range(-10 10) titleg(1)) graphregion(ifcolor(white) fcolor(white) lcolor(white) icolor(white)) ytitle(Standarized units, size(small)) legend(ring() position() cols(4) order (1 "Indicator 1" 2 "Indicator 2" 3 "Indicator 3" 4 "Indicator 4" 5 "Indicator 5" 6 "Indicator 6" 7 "Indicator 7") size(small)) scheme() title() saving("cluster1_1", replace)
graph box I*_s if c1==2, ysize() ylabel(, nogrid labsize(small))yscale(range(-10 10) titleg(1)) graphregion(ifcolor(white) fcolor(white) lcolor(white) icolor(white)) ytitle(Standarized units, size(small)) legend(ring() position() cols(4) order (1 "Indicator 1" 2 "Indicator 2" 3 "Indicator 3" 4 "Indicator 4" 5 "Indicator 5" 6 "Indicator 6" 7 "Indicator 7") size(small)) scheme() title() saving("cluster1_2", replace)
graph box I*_s if c1==3, ysize() ylabel(, nogrid labsize(small)) yscale(range(-10 10) titleg(1)) graphregion(ifcolor(white) fcolor(white) lcolor(white) icolor(white)) ytitle(Standarized units, size(small)) legend(ring() position() cols(4) order (1 "Indicator 1" 2 "Indicator 2" 3 "Indicator 3" 4 "Indicator 4" 5 "Indicator 5" 6 "Indicator 6" 7 "Indicator 7") size(small)) scheme() title() saving("cluster1_3", replace)

cluster kmeans I*_s, k(3) measure(L2squared) name(Kmeans) start(group(c1))
tab c1 Kmeans

keep i c1 Kmeans
export excel  using "cluster1.xls", firstrow(variables) replace
save "cluster1.dta", replace

restore

*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
********************************************************************************
********************************** Modeling ************************************
*******************************************************************************
*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


clear all

use "2024_SEA_EU_commuting_public.dta",replace

drop if c_i=="RO"
drop if c_j=="RO"

* Merge clusters

sort i

merge m:1 i using "cluster1.dta"
drop if _merge ==2
drop if _merge ==1
drop _merge

replace c1=0 if c1==.
replace Kmeans=0 if Kmeans==.


gen ln_area_i=ln(area_km_i + 1)
gen ln_area_j=ln(area_km_j + 1)

**Here we generate the country fixed effects * year
xi i.c_i*i.year, prefix (_CO)
xi i.c_j*i.year, prefix (_CD)
	
set matsize 10000 

****************************************************************************************

gen ln_jrc_cost1=ln(jrc_total_cost+1) 
gen ln_jrc_time1=ln(jrc_time_road+1)

reg ln_jrc_cost1 ln_dist outermost_i outermost_j island_i island_j coast_i coast_j intra inter
predict ln_jrc_cost_p
gen ln_jrc_cost=ln_jrc_cost1
replace ln_jrc_cost=ln_jrc_cost_p if ln_jrc_cost1==.

reg ln_jrc_time1 ln_dist outermost_i outermost_j island_i island_j coast_i coast_j intra inter
predict ln_jrc_time_p
gen ln_jrc_time=ln_jrc_time1
replace ln_jrc_time=ln_jrc_time_p if ln_jrc_time1==.

********************************** Spline regressions **********************************

	*Generating the spline for AREAj
	
	*4 streches. Linear
		mkspline ln_area_j 4=ln_area_j
	*4 streches. Percentiles
		mkspline ln_area_pc_j 4=ln_area_j, p
	*4 streches. Cubic spline
        mkspline ln_area_cubic_j=ln_area_j, cubic nk(4)
		

********************************************************
*    PIECEWISE REGRESSIONS
********************************************************

preserve

drop if flow==.
drop if flow==0

***************************************************************
* With Distance  
		
reg ln_flow ln_area_cubic* ln_dist ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX*,cluster(pairid) robust 
		est store spline_lnarea_cubic_dist

reg ln_flow ln_area_cubic* ln_dist ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if num_nuts3_j==1,cluster(pairid) robust 
		est store spline_lnarea_pc_1nut3_d
		
reg ln_flow ln_area_cubic* ln_dist ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if Kmeans==1,cluster(pairid) robust 
		est store spline_lnarea_cubic_G1_d
		
reg ln_flow ln_area_cubic* ln_dist ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if Kmeans==2,cluster(pairid) robust 
		est store spline_lnarea_cubic_G2_d
		
reg ln_flow ln_area_cubic* ln_dist ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if Kmeans==3,cluster(pairid) robust 
		est store spline_lnarea_cubic_G3_d
		
reg ln_flow ln_area_j* ln_dist ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX*,cluster(pairid) robust
est store spline_lnarea1_d
		
reg ln_flow ln_area_pc* ln_dist ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX*,cluster(pairid) robust
est store spline_lnarea_pc1_d

outreg2[spline*_d] using tabla_spline_dist, excel replace keep(ln_area* ln_dist ln_dif* intra inter UEM) addtext(Country_i*time FE, YES, Country_i*time FE, YES)

*********************************************************************************
* With Travel times
		
reg ln_flow ln_area_cubic* ln_jrc_time ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX*,cluster(pairid) robust 
		est store spline_lnarea_cubic_t

reg ln_flow ln_area_cubic* ln_jrc_time ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if num_nuts3_j==1,cluster(pairid) robust 
		est store spline_lnarea_pc_1nut3_t

reg ln_flow ln_area_cubic* ln_jrc_time ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if Kmeans==1,cluster(pairid) robust 
		est store spline_lnarea_cubic_G1_t
		
reg ln_flow ln_area_cubic* ln_jrc_time ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if Kmeans==2,cluster(pairid) robust 
		est store spline_lnarea_cubic_G2_t
		
reg ln_flow ln_area_cubic* ln_jrc_time ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if Kmeans==3,cluster(pairid) robust 
		est store spline_lnarea_cubic_G3_t
		
reg ln_flow ln_area_j* ln_jrc_time ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX*,cluster(pairid) robust
est store spline_lnarea1_t
		
reg ln_flow ln_area_pc* ln_jrc_time ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX*,cluster(pairid) robust
est store spline_lnarea_pc1_t

outreg2[spline*_t] using tabla_spline_time, excel replace keep(ln_area* ln_jrc_time ln_dif* intra inter UEM) addtext(Country_i*time FE, YES, Country_i*time FE, YES)

********************************************************************************************************
* With Generalized transportation costs

reg ln_flow ln_area_cubic* ln_jrc_cost ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX*,cluster(pairid) robust 
		est store spline_lnarea_cubic_c

reg ln_flow ln_area_cubic* ln_jrc_cost ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if num_nuts3_j==1,cluster(pairid) robust 
		est store spline_lnarea_cubic_1nut3_c
		
reg ln_flow ln_area_cubic* ln_jrc_cost ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if Kmeans==1,cluster(pairid) robust 
		est store spline_lnarea_cubic_G1_c
		
reg ln_flow ln_area_cubic* ln_jrc_cost ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if Kmeans==2,cluster(pairid) robust 
		est store spline_lnarea_cubic_G2_c
		
reg ln_flow ln_area_cubic* ln_jrc_cost ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX* if Kmeans==3,cluster(pairid) robust 
		est store spline_lnarea_cubic_G3_c
		
reg ln_flow ln_area_j* ln_jrc_cost ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX*,cluster(pairid) robust
est store spline_lnarea1_c
		
reg ln_flow ln_area_pc* ln_jrc_cost ln_dif_remun ln_dif_unemployment ln_dif_density intra inter UEM _COc_iX* _CDc_jX*,cluster(pairid) robust
est store spline_lnarea_pc1_c


outreg2[spline*_c] using tabla_spline_cost, excel replace keep(ln_area* ln_jrc_cost ln_dif* intra inter UEM) addtext(Country_i*time FE, YES, Country_i*time FE, YES)

		
restore

***************************************************************************
* KERNEL REGRESSIONS
***************************************************************************

preserve

drop if i==j
kernreg2 ln_flow ln_dist, k(4) np(100) bwidth(2.4) saving(kern_lndist_no_intrareg)
graph export kern_lndist_no_intrareg.png, replace width(800) height(600) 

kernreg2 ln_flow ln_jrc_time, k(4) np(100) bwidth(2.4) saving(kern_jrc_time_no_intrareg)
graph export kern_jrc_time_no_intrareg.png, replace width(800) height(600) 

kernreg2 ln_flow ln_jrc_cost,  k(4) np(100) bwidth(2.4)saving(kern_jrc_cost_no_intrareg)
graph export kern_jrc_cost_no_intrareg.png, replace width(800) height(600) 

kernreg2 ln_flow ln_area_j, k(4) np(100) bwidth(2.4) saving(kern_ln_area_j_no_intrareg)
graph export kern_ln_area_j_no_intrareg.png, replace width(800) height(600) 


restore

*******************************************************************************
*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX      THE END     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
********************************************************************************
