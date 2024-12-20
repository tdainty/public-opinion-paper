***Analyzing Data for Presentation and Final Draft***

*set cd to main folder this file is in (e.g., "public-opinion-paper)
*unzip the compiled_dataset folder and move the file to the larger "data" folder that the zip is originally found within before running.

use "data/compiled_dataset.dta", clear


***Preliminary Visualizations - Oppose Migrant Neighbors

recode sex (1=0) (2=1), gen(female)
recode employment (1=1) (2/8 = 0), gen(e_dummy)
recode marital_status (1=1) (2/6 = 0), gen(m_dummy)

* Egypt is specially coded to be a 4 since it is in Africa
gen region1 = .
replace region1 = 1 if state1 >= 1 & state1 <= 99
replace region1 = 2 if state1 >= 100 & state1 <= 199
replace region1 = 3 if state1 >= 200 & state1 <= 400
replace region1 = 4 if state1 >= 401 & state1 <= 627
replace region1 = 5 if state1 >= 628
replace region1 = 4 if state1 == 651

label define oppose_label 0 "Did not mention" 1 "Mentioned"

label values oppose_migrant_neighbors oppose_label

gen statewide_ordinal = 1 if statewide_xi < -1
replace statewide_ordinal = 2 if statewide_xi < 0 & statewide_xi > -1
replace statewide_ordinal = 3 if statewide_xi < 1 & statewide_xi > 0
replace statewide_ordinal = 4 if statewide_xi > 1 
 
label define ordinal_label 1 "LM < -1" 2 "-1 < LM < 0" 3 "0 < LM < 1" 4 "1 < LM", replace

label values statewide_ordinal ordinal_label

label var statewide_xi "Statewide Border Orientation"

label define ordinal_label2 1 "Police Presence < 10" 2 "10 < PP < 20" 3 "20 < PP < 30", replace

label define ordinal_dist 1 "D < 25%" 2 "25% < D < 50%" 3 "50% < D < 75%" 4 "75% < D", replace

sum near_dist, detail
gen dist_ordinal = 1 if near_dist <= r(p25) & near_dist != .
replace dist_ordinal = 2 if near_dist > r(p25) & near_dist <= r(p50) & near_dist != .
replace dist_ordinal = 3 if near_dist > r(p50) & near_dist <= r(p75) & near_dist != .
replace dist_ordinal = 4 if near_dist > r(p75) & near_dist != .

label values dist_ordinal ordinal_dist

sum statewide_pol_orientation, detail
gen pol_ordinal = 1 if statewide_pol_orientation < 10
replace pol_ordinal = 2 if statewide_pol_orientation < 20 & statewide_pol_orientation > 10
replace pol_ordinal = 3 if statewide_pol_orientation < 30 & statewide_pol_orientation > 20

label values pol_ordinal ordinal_label2

label define ordinal_label3 1 "SI < 1.5" 2 "1.5 < SI < 2" 3 "2 < SI < 2.5" 4 "2.5 < SI", replace

gen index_ordinal = 1 if statewide_index < 1.5
replace index_ordinal = 2 if statewide_index < 2 & statewide_index > 1.5
replace index_ordinal = 3 if statewide_index < 2.5 & statewide_index > 2
replace index_ordinal = 4 if statewide_index > 2.5

label values index_ordinal ordinal_label3

label define wall_label 0 "No Border Wall" 1 "At least 1 Wall Present", replace

label values statewide_cp_wall wall_label

graph bar (mean) oppose_migrant_neighbors, over(statewide_ordinal) ytitle("Proportion of Respondents" "Who Mention Migrants as Unwanted Neighbors") bar(1, color(red%60))

graph rename bc_1, replace

graph bar (mean) oppose_migrant_neighbors, over(index_ordinal) ytitle("") bar(1, color(red%60))

graph rename bc_2, replace

graph bar (mean) oppose_migrant_neighbors, over(pol_ordinal) ytitle("") bar(1, color(red%60))

graph rename bc_3, replace

graph bar (mean) oppose_migrant_neighbors, over(dist_ordinal) ytitle("") bar(1, color(red%60))

graph rename bc_4, replace

graph combine bc_1 bc_2 bc_3 bc_4, cols(2) ycommon title("Mixed Evidence for More Fortified States" "Consistently Impacting Immigration Attitudes", size(medium)) note("Note: LM = Latent Measure for Border Orientation" "SI = Statewide Index" "D = Distance" "Distance broken into percentiles")

graph export "figures/barchart_1.png", width(3000) replace

***Preliminary Visualizations - Pro-Immigration Policy

graph bar (mean) pro_immigrant_policy, over(statewide_ordinal) ytitle("Proportion of Respondents" "Who Support Pro-Immigration Policies")

graph rename bc_1, replace

graph bar (mean) pro_immigrant_policy, over(index_ordinal) ytitle("")

graph rename bc_2, replace

graph bar (mean) pro_immigrant_policy, over(pol_ordinal) ytitle("")

graph rename bc_3, replace

graph bar (mean) pro_immigrant_policy, over(dist_ordinal) ytitle("")

graph rename bc_4, replace

graph combine bc_1 bc_2 bc_3 bc_4, cols(2) ycommon title("Mixed Evidence for More Fortified States" "Consistently Impacting Immigration Attitudes", size(medium)) note("Note: LM = Latent Measure for Border Orientation" "Distance broken into percentiles")

graph export "figures/barchart_2.png", width(3000) replace


***Analysis - Oppose Migrant Neighbors

recode age (0/25 = 1) (26/50 = 2) (51/65 = 3) (66/108 = 4), gen(age_ordinal)

xtset state1

xtlogit oppose_migrant_neighbors statewide_xi trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m1

xtlogit oppose_migrant_neighbors statewide_xi lag_xi trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m1_a

xtlogit oppose_migrant_neighbors statewide_index trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m2

xtlogit oppose_migrant_neighbors statewide_index lag_index trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m2_a

xtlogit oppose_migrant_neighbors statewide_pol_orientation trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m3

xtlogit oppose_migrant_neighbors statewide_pol_orientation lag_pol_orientation trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m3_a

xtlogit oppose_migrant_neighbors c.near_dist##c.xi trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m4

xtlogit oppose_migrant_neighbors c.near_dist##c.statewide_xi trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m4_a

xtlogit oppose_migrant_neighbors c.near_dist##c.political_orientation trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale politics_interest gov_gdp_pc i.year i.region1, re
estimates store m5

****Results and Post-estimation Visualizations****

**Coefficient Plots

*m1-m3

coefplot (m1, label("Average Latent Border Orientation") mcolor("103 0 31") msymbol(circle)  ciopts(lcolor("178 24 43" "253 219 199") lwidth(medthick medthick))) ///
 (m2, label("Average Infrastructure Index") mcolor("0 68 27") msymbol(triangle) ciopts(lcolor("62 168 91" "192 230 185") lwidth(medthick medthick))) ///
 (m3, label("Average Police Border Presence") mcolor("114 13 191") msymbol(square) ciopts(lcolor("93 11 156" "197 169 219") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios of the effect of each variable on opposing migrant neighbors" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 xtitle ("Effect on Opposing Migrant Neighbors") lcolor(black) ///
 order(statewide_xi lag_xi statewide_index lag_index statewide_pol_orientation lag__pol_orientation near_dist female age m_dummy education e_dummy income_scale political_orientation politics_interest trust_in_people freedom_of_choice) ///
 coeflabels(statewide_xi = "Average Latent Border Orientation" lag_xi = "Border Orientation (t-1)" statewide_index = "Average Infrastructure Index" lag_index = "Index (t-1)" statewide_pol_orientation = "Average Police Presence near Border" lag_pol_orientation = "Police Presence (t-1)" trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(statewide_xi="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" political_orientation="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1) ylab(, labsize(2.5)) ///
    caption("N = 108,608 for Models 1 + 2" "N = 104,284 for Model 3", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform

  graph export "figures/border_orientation_figure1.png", width(3000) replace

  
  coefplot (m1_a, label("Average Latent Border Orientation") mcolor("103 0 31") msymbol(circle)  ciopts(lcolor("178 24 43" "253 219 199") lwidth(medthick medthick))) ///
 (m2_a, label("Average Infrastructure Index") mcolor("0 68 27") msymbol(triangle) ciopts(lcolor("62 168 91" "192 230 185") lwidth(medthick medthick))) ///
 (m3_a, label("Average Police Border Presence") mcolor("114 13 191") msymbol(square) ciopts(lcolor("93 11 156" "197 169 219") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios of the effect of each variable on opposing migrant neighbors" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 xtitle ("Effect on Opposing Migrant Neighbors") lcolor(black) ///
 order(statewide_xi lag_xi statewide_index lag_index statewide_pol_orientation lag__pol_orientation near_dist female age m_dummy education e_dummy income_scale political_orientation politics_interest trust_in_people freedom_of_choice) ///
 coeflabels(statewide_xi = "Average Latent Border Orientation" lag_xi = "Border Orientation (t-1)" statewide_index = "Average Infrastructure Index" lag_index = "Index (t-1)" statewide_pol_orientation = "Average Police Presence near Border" lag_pol_orientation = "Police Presence (t-1)" trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(statewide_xi="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" political_orientation="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1) ylab(, labsize(2.5)) ///
    caption("N = 108,608 for Models 1 + 2" "N = 104,284 for Model 3", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform title("Models 1-3")

  graph export "figures/border_orientation_figure1_a1.png", width(3000) replace

  coefplot (m1_a, label("Average Latent Border Orientation") mcolor("103 0 31") msymbol(circle)  ciopts(lcolor("178 24 43" "253 219 199") lwidth(medthick medthick))) ///
 (m2_a, label("Average Infrastructure Index") mcolor("0 68 27") msymbol(triangle) ciopts(lcolor("62 168 91" "192 230 185") lwidth(medthick medthick))) ///
 (m3_a, label("Average Police Border Presence") mcolor("114 13 191") msymbol(square) ciopts(lcolor("93 11 156" "197 169 219") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios of the effect of each variable on opposing migrant neighbors" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 xtitle ("Effect on Opposing Migrant Neighbors") lcolor(black) ///
 order(statewide_xi lag_xi statewide_index lag_index statewide_pol_orientation lag__pol_orientation near_dist female age m_dummy education e_dummy income_scale political_orientation politics_interest trust_in_people freedom_of_choice) ///
 coeflabels(statewide_xi = "Average Latent Border Orientation" lag_xi = "Border Orientation (t-1)" statewide_index = "Average Infrastructure Index" lag_index = "Index (t-1)" statewide_pol_orientation = "Average Police Presence near Border" lag_pol_orientation = "Police Presence (t-1)" trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(statewide_xi="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" political_orientation="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1 statewide_index) ylab(, labsize(2.5)) ///
    caption("N = 108,608 for Models 1 + 2" "N = 104,284 for Model 3", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform

  graph export "figures/border_orientation_figure1_a2.png", width(3000) replace

  
  *m4-5
  
coefplot (m4, label("Distance to Border x Border-specific Orientation") mcolor("47 61 222") msymbol(o) ciopts(lcolor("14 26 158" "148 154 224") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 order(near_dist xi *.xi statewide_xi *.statewide_xi female age m_dummy education e_dummy income_scale politics_interest political_orientation trust_in_people freedom_of_choice) ///
 coeflabels(near_dist = "Distance to Border" xi = "Latent Border Orientation" statewide_xi = "Average Latent Border Orientation"  *.xi = "Distance x Border Orientation" *.political_orientation = "Distance x Political Leaning" *.statewide_xi = "Distance x Average Border Or." trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(near_dist="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" politics_interest="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1) ylab(, labsize(2.5)) ///
   caption("N = 13,642", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform title("Model 4a")

  graph rename m4, replace
  
graph export "figures/border_orientation_figure2.png", width(3000) replace
  
  coefplot (m4_a, label("Distance to Border x Average Border Orientation") mcolor("0 68 27") msymbol(triangle) ciopts(lcolor("62 168 91" "192 230 185") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 xtitle ("Effect on Opposing Migrant Neighbors") lcolor(black) ///
 order(near_dist xi *.xi statewide_xi *.statewide_xi female age m_dummy education e_dummy income_scale politics_interest political_orientation trust_in_people freedom_of_choice) ///
 coeflabels(near_dist = "Distance to Border" xi = "Latent Border Orientation" statewide_xi = "Average Latent Border Orientation"  *.xi = "Distance x Border Orientation" *.political_orientation = "Distance x Political Leaning" *.statewide_xi = "Distance x Average Border Or." trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(near_dist="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" politics_interest="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1) ylab(, labsize(2.5)) ///
  caption("N = 28,717", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform title("Model 4b")

  graph rename m4a, replace
  
  graph export "figures/border_orientation_figure3.png", width(3000) replace

  coefplot (m5, label("Distance to Border x Political Leaning") mcolor("213 23 227") msymbol(diamond) ciopts(lcolor("217 146 222" "127 12 135") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 xtitle ("Effect on Opposing Migrant Neighbors") lcolor(black) ///
 order(near_dist xi *.xi political_orientation *.political_orientation statewide_xi *.statewide_xi female age m_dummy education e_dummy income_scale politics_interest trust_in_people freedom_of_choice) ///
 coeflabels(near_dist = "Distance to Border" xi = "Latent Border Orientation" statewide_xi = "Average Latent Border Orientation"  *.xi = "Distance x Border Orientation" *.political_orientation = "Distance x Political Leaning" *.statewide_xi = "Distance x Average Border Or." trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(near_dist="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" politics_interest="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1) ylab(, labsize(2.5)) ///
 caption("N = 38,287", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform title("Model 5")

  graph rename m5, replace
  
graph export "figures/border_orientation_figure4.png", width(3000) replace
  
  
  **Model 4 Marginal Effects
  estimates restore m4
  *margins
margins, dydx(near_dist) at(xi=(-2(.5)1.5)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(ltblue%40)) title("") ytitle("Opposition to Migrant Neighbors") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Distance to Border") pos(6)) yline(0) plotregion(margin(large)) note("Margins with all other variables" "at their means")
graph rename pt1, replace

margins, dydx(xi) at(near_dist=(0(.5)7)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(red%40)) plotopts(mcolor(red) lcolor(red)) title("") ytitle("") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Border Orientation") pos(6)) yline(0) plotregion(margin(large))
graph rename pt2, replace

graph combine pt1 pt2

graph export "figures/m4_marginal_1.png", width(3000) replace

*margins, at(near_dist=(0(.5)7) xi=(-2(.5)1.5)) atmeans saving(m4_contour, replace)

  
  **Model 4a Marginal Effects
    estimates restore m4_a

 margins, dydx(near_dist) at(statewide_xi=(-1.5(.5)1.3)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(ltblue%40)) title("") ytitle("Opposition to Migrant Neighbors") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Distance to Border") pos(6)) yline(0) plotregion(margin(large)) note("Margins with all other variables" "at their means")
graph rename pt1, replace

margins, dydx(statewide_xi) at(near_dist=(0(.5)7)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(red%40)) plotopts(mcolor(red) lcolor(red)) title("") ytitle("") legend(on label(1 "95% Confidence Interval") label(2 "Effect of Statewide" "Border Orientation") pos(6)) yline(0) plotregion(margin(large))
graph rename pt2, replace

graph combine pt1 pt2

graph export "figures/m4a_marginal_1.png", width(3000) replace

*quietly margins, at(near_dist=(0(.5)7) statewide_xi=(-1.5(.5)1.3)) atmeans saving(m4_a_contour, replace)


  **Model 5 Marginal Effects
      estimates restore m5

 margins, dydx(near_dist) at(political_orientation=(1(1)10)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(ltblue%40)) title("") ytitle("Opposition to Migrant Neighbors") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Distance to Border") pos(6)) yline(0) plotregion(margin(large)) note("Margins with all other variables" "at their means")
graph rename pt1, replace

margins, dydx(political_orientation) at(near_dist=(0(.5)7)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(red%40)) plotopts(mcolor(red) lcolor(red)) title("") ytitle("") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Political Leaning") pos(6)) yline(0) plotregion(margin(large))
graph rename pt2, replace

graph combine pt1 pt2

graph export "figures/m5_marginal_1.png", width(3000) replace

*quietly margins, at(near_dist=(0(.5)7) political_orientation=(1(1)10)) atmeans saving(m5_contour, replace)

    **Model 6 Marginal Effects
xtlogit oppose_migrant_neighbors c.political_orientation##c.statewide_xi trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale politics_interest gov_gdp_pc i.year i.region1, re
estimates store m6

 margins, dydx(statewide_xi) at(political_orientation=(1(1)10)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(ltblue%40)) title("") ytitle("Opposition to Migrant Neighbors") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Border Orientation") pos(6)) yline(0) plotregion(margin(large)) note("Margins with all other variables" "at their means")
graph rename pt1, replace

margins, dydx(political_orientation) at(statewide_xi=(-1.5(.5)1.3)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(red%40)) plotopts(mcolor(red) lcolor(red)) title("") ytitle("") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Political Leaning") pos(6)) yline(0) plotregion(margin(large))
graph rename pt2, replace

graph combine pt1 pt2

graph export "figures/m6_marginal_1.png", width(3000) replace


  
***Analysis - Pro-Immigrant Policy
estimates clear

xtset state1

xtlogit pro_immigrant_policy statewide_xi trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m1

xtlogit pro_immigrant_policy statewide_xi lag_xi trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m1_a

xtlogit pro_immigrant_policy statewide_index trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m2

xtlogit pro_immigrant_policy statewide_index lag_index trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m2_a

xtlogit pro_immigrant_policy statewide_pol_orientation trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m3

xtlogit pro_immigrant_policy statewide_pol_orientation lag_pol_orientation trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m3_a

xtlogit pro_immigrant_policy c.near_dist##c.xi trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m4

xtlogit pro_immigrant_policy c.near_dist##c.statewide_xi trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale political_orientation politics_interest gov_gdp_pc i.year i.region1, re
estimates store m4_a

xtlogit pro_immigrant_policy c.near_dist##c.political_orientation trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale politics_interest gov_gdp_pc i.year i.region1, re
estimates store m5

****Results and Post-estimation Visualizations****

**Coefficient Plots

*m1-m3

coefplot (m1, label("Average Latent Border Orientation") mcolor("103 0 31") msymbol(circle)  ciopts(lcolor("178 24 43" "253 219 199") lwidth(medthick medthick))) ///
 (m2, label("Average Infrastructure Index") mcolor("0 68 27") msymbol(triangle) ciopts(lcolor("62 168 91" "192 230 185") lwidth(medthick medthick))) ///
 (m3, label("Average Police Border Presence") mcolor("114 13 191") msymbol(square) ciopts(lcolor("93 11 156" "197 169 219") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios of the effect of each variable on opposing migrant neighbors" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 xtitle ("Effect on Supporting Pro-Immigration Policy") lcolor(black) ///
 order(statewide_xi lag_xi statewide_index lag_index statewide_pol_orientation lag__pol_orientation near_dist female age m_dummy education e_dummy income_scale political_orientation politics_interest trust_in_people freedom_of_choice) ///
 coeflabels(statewide_xi = "Average Latent Border Orientation" lag_xi = "Border Orientation (t-1)" statewide_index = "Average Infrastructure Index" lag_index = "Index (t-1)" statewide_pol_orientation = "Average Police Presence near Border" lag_pol_orientation = "Police Presence (t-1)" trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(statewide_xi="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" political_orientation="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1) ylab(, labsize(2.5)) ///
    caption("N = 108,608 for Models 1 + 2" "N = 104,284 for Model 3", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform

  graph export "figures/border_orientation_policy_figure1.png", width(3000) replace

  
  coefplot (m1_a, label("Average Latent Border Orientation") mcolor("103 0 31") msymbol(circle)  ciopts(lcolor("178 24 43" "253 219 199") lwidth(medthick medthick))) ///
 (m2_a, label("Average Infrastructure Index") mcolor("0 68 27") msymbol(triangle) ciopts(lcolor("62 168 91" "192 230 185") lwidth(medthick medthick))) ///
 (m3_a, label("Average Police Border Presence") mcolor("114 13 191") msymbol(square) ciopts(lcolor("93 11 156" "197 169 219") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios of the effect of each variable on opposing migrant neighbors" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 xtitle ("Effect on Supporting Pro-Immigration Policy") lcolor(black) ///
 order(statewide_xi lag_xi statewide_index lag_index statewide_pol_orientation lag__pol_orientation near_dist female age m_dummy education e_dummy income_scale political_orientation politics_interest trust_in_people freedom_of_choice) ///
 coeflabels(statewide_xi = "Average Latent Border Orientation" lag_xi = "Border Orientation (t-1)" statewide_index = "Average Infrastructure Index" lag_index = "Index (t-1)" statewide_pol_orientation = "Average Police Presence near Border" lag_pol_orientation = "Police Presence (t-1)" trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(statewide_xi="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" political_orientation="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1) ylab(, labsize(2.5)) ///
    caption("N = 108,608 for Models 1 + 2" "N = 104,284 for Model 3", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform title("Models 1-3")

  graph export "figures/border_orientation_policy_figure1_a1.png", width(3000) replace

  coefplot (m1_a, label("Average Latent Border Orientation") mcolor("103 0 31") msymbol(circle)  ciopts(lcolor("178 24 43" "253 219 199") lwidth(medthick medthick))) ///
 (m2_a, label("Average Infrastructure Index") mcolor("0 68 27") msymbol(triangle) ciopts(lcolor("62 168 91" "192 230 185") lwidth(medthick medthick))) ///
 (m3_a, label("Average Police Border Presence") mcolor("114 13 191") msymbol(square) ciopts(lcolor("93 11 156" "197 169 219") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios of the effect of each variable on opposing migrant neighbors" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 xtitle ("Effect on Supporting Pro-Immigration Policy") lcolor(black) ///
 order(statewide_xi lag_xi statewide_index lag_index statewide_pol_orientation lag__pol_orientation near_dist female age m_dummy education e_dummy income_scale political_orientation politics_interest trust_in_people freedom_of_choice) ///
 coeflabels(statewide_xi = "Average Latent Border Orientation" lag_xi = "Border Orientation (t-1)" statewide_index = "Average Infrastructure Index" lag_index = "Index (t-1)" statewide_pol_orientation = "Average Police Presence near Border" lag_pol_orientation = "Police Presence (t-1)" trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(statewide_xi="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" political_orientation="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1 statewide_index) ylab(, labsize(2.5)) ///
    caption("N = 108,608 for Models 1 + 2" "N = 104,284 for Model 3", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform

  graph export "figures/border_orientation_policy_figure1_a2.png", width(3000) replace

  
  *m4-5
  
coefplot (m4, label("Distance to Border x Border-specific Orientation") mcolor("47 61 222") msymbol(o) ciopts(lcolor("14 26 158" "148 154 224") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 xtitle ("Effect on Supporting Pro-Immigration Policy") lcolor(black) ///
 order(near_dist xi *.xi statewide_xi *.statewide_xi female age m_dummy education e_dummy income_scale politics_interest political_orientation trust_in_people freedom_of_choice) ///
 coeflabels(near_dist = "Distance to Border" xi = "Latent Border Orientation" statewide_xi = "Average Latent Border Orientation"  *.xi = "Distance x Border Orientation" *.political_orientation = "Distance x Political Leaning" *.statewide_xi = "Distance x Average Border Or." trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(near_dist="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" politics_interest="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1) ylab(, labsize(2.5)) ///
   caption("N = 13,642", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform title("Model 4a")

  graph rename m4, replace
  
graph export "figures/border_orientation_policy_figure2.png", width(3000) replace
  
  coefplot (m4_a, label("Distance to Border x Average Border Orientation") mcolor("0 68 27") msymbol(triangle) ciopts(lcolor("62 168 91" "192 230 185") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 xtitle ("Effect on Supporting Pro-Immigration Policy") lcolor(black) ///
 order(near_dist xi *.xi statewide_xi *.statewide_xi female age m_dummy education e_dummy income_scale politics_interest political_orientation trust_in_people freedom_of_choice) ///
 coeflabels(near_dist = "Distance to Border" xi = "Latent Border Orientation" statewide_xi = "Average Latent Border Orientation"  *.xi = "Distance x Border Orientation" *.political_orientation = "Distance x Political Leaning" *.statewide_xi = "Distance x Average Border Or." trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(near_dist="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" politics_interest="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1) ylab(, labsize(2.5)) ///
  caption("N = 28,717", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform title("Model 4b")

  graph rename m4a, replace
  
  graph export "figures/border_orientation_policy_figure3.png", width(3000) replace

  coefplot (m5, label("Distance to Border x Political Leaning") mcolor("213 23 227") msymbol(diamond) ciopts(lcolor("217 146 222" "127 12 135") lwidth(medthick medthick))), note("Note: Coefficients are logistic regression coefficients expressed in odds ratios" "Year and region-level fixed effects omitted from the plot" "Light Bars are 90% CIs, Dark Bars extend to 95% CIs", size(vsmall) span) xline(1, lcolor(gold)) msize(medsmall) levels(95 90) ///
 xtitle ("Effect on Supporting Pro-Immigration Policy") lcolor(black) ///
 order(near_dist xi *.xi political_orientation *.political_orientation statewide_xi *.statewide_xi female age m_dummy education e_dummy income_scale politics_interest trust_in_people freedom_of_choice) ///
 coeflabels(near_dist = "Distance to Border" xi = "Latent Border Orientation" statewide_xi = "Average Latent Border Orientation"  *.xi = "Distance x Border Orientation" *.political_orientation = "Distance x Political Leaning" *.statewide_xi = "Distance x Average Border Or." trust_in_people = "Level of General Trust in People" freedom_of_choice = "Belief in Freedom of Choice" female = "Female" age = "Age" m_dummy="Married" education = "Education" e_dummy = "Employment" income_scale = "Income" political_orientation = "Political Leaning" politics_interest = "Interest in Politics") ///
 headings(near_dist="{bf: Border Characteristics}" female="{bf: Demographics & S.E.S.}" politics_interest="{bf:Political Worldview}", gap(1)) ///
 drop(_cons *.year *.region1) ylab(, labsize(2.5)) ///
 caption("N = 38,287", size(vsmall) span) ///
  legend(size(small) pos(6) cols(2)) eform title("Model 5")

  graph rename m5, replace
  
graph export "figures/border_orientation_policy_figure4.png", width(3000) replace
  
  
  **Model 4 Marginal Effects
  estimates restore m4
  *margins
margins, dydx(near_dist) at(xi=(-2(.5)1.5)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(ltblue%40)) title("") ytitle("Support for Pro-Immigration Policy") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Distance to Border") pos(6)) yline(0) plotregion(margin(large)) note("Margins with all other variables" "at their means")
graph rename pt1, replace

margins, dydx(xi) at(near_dist=(0(.5)7)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(red%40)) plotopts(mcolor(red) lcolor(red)) title("") ytitle("") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Border Orientation") pos(6)) yline(0) plotregion(margin(large))
graph rename pt2, replace

graph combine pt1 pt2

graph export "figures/m4_policy_marginal_1.png", width(3000) replace

*margins, at(near_dist=(0(.5)7) xi=(-2(.5)1.5)) atmeans saving(m4_contour, replace)

  
  **Model 4a Marginal Effects
    estimates restore m4_a

 margins, dydx(near_dist) at(statewide_xi=(-1.5(.5)1.3)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(ltblue%40)) title("") ytitle("Support for Pro-Immigration Policy") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Distance to Border") pos(6)) yline(0) plotregion(margin(large)) note("Margins with all other variables" "at their means")
graph rename pt1, replace

margins, dydx(statewide_xi) at(near_dist=(0(.5)7)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(red%40)) plotopts(mcolor(red) lcolor(red)) title("") ytitle("") legend(on label(1 "95% Confidence Interval") label(2 "Effect of Statewide" "Border Orientation") pos(6)) yline(0) plotregion(margin(large))
graph rename pt2, replace

graph combine pt1 pt2

graph export "figures/m4a_policy_marginal_1.png", width(3000) replace

*quietly margins, at(near_dist=(0(.5)7) statewide_xi=(-1.5(.5)1.3)) atmeans saving(m4_a_contour, replace)


  **Model 5 Marginal Effects
      estimates restore m5

 margins, dydx(near_dist) at(political_orientation=(1(1)10)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(ltblue%40)) title("") ytitle("Support for Pro-Immigration Policy") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Distance to Border") pos(6)) yline(0) plotregion(margin(large)) note("Margins with all other variables" "at their means")
graph rename pt1, replace

margins, dydx(political_orientation) at(near_dist=(0(.5)7)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(red%40)) plotopts(mcolor(red) lcolor(red)) title("") ytitle("") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Political Leaning") pos(6)) yline(0) plotregion(margin(large))
graph rename pt2, replace

graph combine pt1 pt2

graph export "figures/m5_policy_marginal_1.png", width(3000) replace

*quietly margins, at(near_dist=(0(.5)7) political_orientation=(1(1)10)) atmeans saving(m5_contour, replace)

    **Model 6 Marginal Effects
xtlogit pro_immigrant_policy c.political_orientation##c.statewide_xi trust_in_people freedom_of_choice female age m_dummy education e_dummy income_scale politics_interest gov_gdp_pc i.year i.region1, re
estimates store m6

 margins, dydx(statewide_xi) at(political_orientation=(1(1)10)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(ltblue%40)) title("") ytitle("Support for Pro-Immigration Policy") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Border Orientation") pos(6)) yline(0) plotregion(margin(large)) note("Margins with all other variables" "at their means")
graph rename pt1, replace

margins, dydx(political_orientation) at(statewide_xi=(-1.5(.5)1.3)) atmeans

marginsplot, recastci(rarea) ciopts(acolor(red%40)) plotopts(mcolor(red) lcolor(red)) title("") ytitle("") legend(on label(1 "95% Confidence Interval") label(2 "Effect of" "Political Leaning") pos(6)) yline(0) plotregion(margin(large))
graph rename pt2, replace

graph combine pt1 pt2

graph export "figures/m6_policy_marginal_1.png", width(3000) replace
