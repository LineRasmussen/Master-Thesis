***********************************************************************************************************************************************************************************************************************************************************************************************************
********************************************************************************************************************EMPIRICAL ANALYSIS*********************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************************************************************************************
*2007 all*
***********************************************************************************************************************************************************************************************************************************************************************************************************
clear
***Read in data***
use "/Users/Line/Desktop/Speciale/Data/GitHub data/df_2007_empirical_analysis.dta", clear
	
****
*Table 1 - Summary statistics for repeated cross-sectional data
****
bysort Year: outreg2 using Out\Tables\Table_1_1, excel replace sum(log) eqkeep(N mean sd min max) keep(Female Age Year_in_program Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Mathematics_score Reading_score Baseline Treatment_intermediate Treatment_longer)

***Age standardise scores for mathematics and reading***
foreach x in Mathematics_score Reading_score {
                             egen junk = mean(`x'), by(Age)
                             gen `x'_temp = `x' - junk
                             egen `x'_sd=sd(`x'), by(Age)
    drop junk
    }                                                                                   
gen Mathematics_score_z = Mathematics_score_temp/Mathematics_score_sd
gen Reading_score_z = Reading_score_temp/Reading_score_sd
drop *_sd *_temp
drop Mathematics_score
drop Reading_score

***Creating variables
gen Cohort = Year_of_birth
gen count = 1

***Collapsing data, c.f. Deaton
g help = 1
egen N = sum(help), by(Municipality Year Cohort)
collapse (mean) Female Year_in_program Working_beside_studying Help_with_homework Grade Rural Indigenous Mother_read Father_read Mathematics_score_z Reading_score_z Baseline Treatment_intermediate Control_intermediate Treatment_longer Control_longer Municipality_no N  [pweight=N], by(Municipality Year Cohort) 
label var N "Number of observations per municipality, cohort, year"

****
*Figure 3 - Frequency of students in each cohort in the year 2007, 2010 and 2013 
****
tab Cohort

***********
*Table 2  * Summary statistics for pseudo panel data
***********
bysort Year: outreg2 using Out\Tables\Table_3_1, excel replace sum(log) eqkeep(N mean sd min max) keep(Female Year_in_program Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Mathematics_score Reading_score Baseline Treatment_intermediate Treatment_longer)

***********************************************************************************************************************************************************************************************************************************************************************************************************
*2010 all*
***********************************************************************************************************************************************************************************************************************************************************************************************************

clear
***Read in data***
use "/Users/Line/Desktop/Speciale/Data/GitHub data/df_2010_empirical_analysis.dta", clear
	
****
*Table 1 - Summary statistics for repeated cross-sectional data
****
generate Group1=0
replace Group1=1 if Treatment_intermediate==1
replace Group1=2 if Control_intermediate==1

bysort Group1: outreg2 using Out\Tables\Table_1_2, excel replace sum(log) eqkeep(N mean sd min max) keep(Female Age Year_in_program Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Mathematics_score Reading_score Baseline Treatment_intermediate Treatment_longer)


***Age standardise scores for mathematics and reading***
foreach x in Mathematics_score Reading_score {
                             egen junk = mean(`x'), by(Age)
                             gen `x'_temp = `x' - junk
                             egen `x'_sd=sd(`x'), by(Age)
    drop junk
    }                                                                                   
gen Mathematics_score_z = Mathematics_score_temp/Mathematics_score_sd
gen Reading_score_z = Reading_score_temp/Reading_score_sd
drop *_sd *_temp
drop Mathematics_score
drop Reading_score

***Creating variables
gen Cohort = Year_of_birth
gen count = 1


***Collapsing data, c.f. Deaton
g help = 1
egen N = sum(help), by(Municipality Year Cohort)
collapse (mean) Female Year_in_program Working_beside_studying Help_with_homework Grade Rural Indigenous Mother_read Father_read Mathematics_score_z Reading_score_z Baseline Treatment_intermediate Control_intermediate Treatment_longer Control_longer Municipality_no N Share[pweight=N], by(Municipality Year Cohort) 
label var N "Number of observations per municipality, cohort, year"

****
*Figure 3 - Frequency of students in each cohort in the year 2007, 2010 and 2013 
****
tab Cohort


***********
*Table 2  * Summary statistics for pseudo panel data
***********
generate Group2=0
replace Group2=1 if Treatment_intermediate==1
replace Group2=2 if Control_intermediate==1

bysort Group2: outreg2 using Out\Tables\Table_3_2, excel replace sum(log) eqkeep(N mean sd min max) keep(Female Year_in_program Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Mathematics_score Reading_score Baseline Treatment_intermediate Treatment_longer)

*Generate cluster variable
gen muniyear = Municipality_no+Year

*****
*Treatment_intermediate
*****
****Reading - table 4	
reg Reading_score_z Treatment_intermediate if Cohort >=1993
	outreg2 using Out\Tables\Table_4, excel dec(3) keep (Treatment_intermediate) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Reading_score_z Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_4, excel dec(3) keep (Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
reg Reading_score_z Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_4, excel dec(3) keep (Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

areg Reading_score_z i.Treatment_intermediate##c.Share i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_4, excel dec(3) keep (i.Treatment_intermediate) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Treatment_intermediate##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_4, excel dec(3) keep (i.Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Year_in_program##c.Share Female  Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_4, excel dec(3) keep (i.Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 
	
****Mathematics - table 5
reg Mathematics_score_z Treatment_intermediate if Cohort >=1993
	outreg2 using Out\Tables\Table_5, excel dec(3) keep (Treatment_intermediate) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Mathematics_score_z Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_5, excel dec(3) keep (Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
reg Mathematics_score_z Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_5, excel dec(3) keep (Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

areg Mathematics_score_z i.Treatment_intermediate##c.Share i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_5, excel dec(3) keep (i.Treatment_intermediate) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Treatment_intermediate##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_5, excel dec(3) keep (i.Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Year_in_program##c.Share Female  Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_5, excel dec(3) keep (i.Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 	
	
*****
*Placebo 2010
*****
****Reading - table 14	
reg Reading_score_z Treatment_intermediate if Cohort <=1992
	outreg2 using Out\Tables\Table_14, excel dec(3) keep (Treatment_intermediate) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Reading_score_z Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort <=1992
	outreg2 using Out\Tables\Table_14, excel dec(3) keep (Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
areg Reading_score_z i.Treatment_intermediate##c.Share i.Cohort if Cohort <=1992 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_14, excel dec(3) keep (i.Treatment_intermediate) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Treatment_intermediate##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort <=1992 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_14, excel dec(3) keep (i.Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

****Mathematics - table 15
reg Mathematics_score_z Treatment_intermediate if Cohort <=1992
	outreg2 using Out\Tables\Table_15, excel dec(3) keep (Treatment_intermediate) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Mathematics_score_z Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort <=1992
	outreg2 using Out\Tables\Table_15, excel dec(3) keep (Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
areg Mathematics_score_z i.Treatment_intermediate##c.Share i.Cohort if Cohort <=1992 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_15, excel dec(3) keep (i.Treatment_intermediate) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Treatment_intermediate##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort <=1992 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_15, excel dec(3) keep (i.Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

***********************************************************************************************************************************************************************************************************************************************************************************************************
*2010 3rd grade*
***********************************************************************************************************************************************************************************************************************************************************************************************************

clear
***Read in data***
use "/Users/Line/Desktop/Speciale/Data/GitHub data/df_2010_3_empirical_analysis.dta", clear

***Age standardise scores for mathematics and reading***
foreach x in Mathematics_score Reading_score {
                             egen junk = mean(`x'), by(Age)
                             gen `x'_temp = `x' - junk
                             egen `x'_sd=sd(`x'), by(Age)
    drop junk
    }                                                                                   
gen Mathematics_score_z = Mathematics_score_temp/Mathematics_score_sd
gen Reading_score_z = Reading_score_temp/Reading_score_sd
drop *_sd *_temp
drop Mathematics_score
drop Reading_score

***Creating variables
gen Cohort = Year_of_birth
gen count = 1

***Collapsing data, c.f. Deaton
g help = 1
egen N = sum(help), by(Municipality Year Cohort)
collapse (mean) Female Year_in_program Working_beside_studying Help_with_homework Grade Rural Indigenous Mother_read Father_read Mathematics_score_z Reading_score_z Baseline Treatment_intermediate Control_intermediate Treatment_longer Control_longer Municipality_no N Share [pweight=N], by(Municipality Year Cohort) 
label var N "Number of observations per municipality, cohort, year"

*Generate cluster variable
gen muniyear = Municipality_no+Year

*****
*Treatment_intermediate
*****
****Reading - table 6	
reg Reading_score_z Treatment_intermediate if Cohort >=1993
	outreg2 using Out\Tables\Table_6, excel dec(3) keep (Treatment_intermediate) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Reading_score_z Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_6, excel dec(3) keep (Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
reg Reading_score_z Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_6, excel dec(3) keep (Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

areg Reading_score_z i.Treatment_intermediate##c.Share i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_6, excel dec(3) keep (i.Treatment_intermediate) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Treatment_intermediate##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_6, excel dec(3) keep (i.Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Year_in_program##c.Share Female  Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_6, excel dec(3) keep (i.Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 
	
****Mathematics - table 7
reg Mathematics_score_z Treatment_intermediate if Cohort >=1993
	outreg2 using Out\Tables\Table_7, excel dec(3) keep (Treatment_intermediate) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Mathematics_score_z Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_7, excel dec(3) keep (Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
reg Mathematics_score_z Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_7, excel dec(3) keep (Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

areg Mathematics_score_z i.Treatment_intermediate##c.Share i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_7, excel dec(3) keep (i.Treatment_intermediate) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Treatment_intermediate##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_7, excel dec(3) keep (i.Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Year_in_program##c.Share Female  Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_7, excel dec(3) keep (i.Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 	

***********************************************************************************************************************************************************************************************************************************************************************************************************
*2010 6th grade*
***********************************************************************************************************************************************************************************************************************************************************************************************************

clear
***Read in data***
use "/Users/Line/Desktop/Speciale/Data/GitHub data/df_2010_6_empirical_analysis.dta", clear

***Age standardise scores for mathematics and reading***
foreach x in Mathematics_score Reading_score {
                             egen junk = mean(`x'), by(Age)
                             gen `x'_temp = `x' - junk
                             egen `x'_sd=sd(`x'), by(Age)
    drop junk
    }                                                                                   
gen Mathematics_score_z = Mathematics_score_temp/Mathematics_score_sd
gen Reading_score_z = Reading_score_temp/Reading_score_sd
drop *_sd *_temp
drop Mathematics_score
drop Reading_score

***Creating variables
gen Cohort = Year_of_birth
gen count = 1

***Collapsing data, c.f. Deaton
g help = 1
egen N = sum(help), by(Municipality Year Cohort)
collapse (mean) Female Year_in_program Working_beside_studying Help_with_homework Grade Rural Indigenous Mother_read Father_read Mathematics_score_z Reading_score_z Baseline Treatment_intermediate Control_intermediate Treatment_longer Control_longer Municipality_no N Share [pweight=N], by(Municipality Year Cohort) 
label var N "Number of observations per municipality, cohort, year"


*Generate cluster variable
gen muniyear = Municipality_no+Year
	
*****
*Treatment_intermediate
*****
****Reading - table 8	
reg Reading_score_z Treatment_intermediate if Cohort >=1993
	outreg2 using Out\Tables\Table_8, excel dec(3) keep (Treatment_intermediate) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Reading_score_z Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_8, excel dec(3) keep (Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
reg Reading_score_z Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_8, excel dec(3) keep (Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

areg Reading_score_z i.Treatment_intermediate##c.Share i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_8, excel dec(3) keep (i.Treatment_intermediate) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Treatment_intermediate##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_8, excel dec(3) keep (i.Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Year_in_program##c.Share Female  Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_8, excel dec(3) keep (i.Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 
	
****Mathematics - table 9
reg Mathematics_score_z Treatment_intermediate if Cohort >=1993
	outreg2 using Out\Tables\Table_9, excel dec(3) keep (Treatment_intermediate) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Mathematics_score_z Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_9, excel dec(3) keep (Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
reg Mathematics_score_z Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_9, excel dec(3) keep (Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

areg Mathematics_score_z i.Treatment_intermediate##c.Share i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_9, excel dec(3) keep (i.Treatment_intermediate) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Treatment_intermediate##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_9, excel dec(3) keep (i.Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Year_in_program##c.Share Female  Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_9, excel dec(3) keep (i.Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 	
	
***********************************************************************************************************************************************************************************************************************************************************************************************************
*2013 all*
***********************************************************************************************************************************************************************************************************************************************************************************************************
clear
***Read in data***
use "/Users/Line/Desktop/Speciale/Data/GitHub data/df_empirical_analysis.dta", clear
****
*Table 1 - Summary statistics for repeated cross-sectional data
****
generate Group1=0
replace Group1=1 if Treatment_longer==1
replace Group1=2 if Control_longer==1

bysort Group1: outreg2 using Out\Tables\Table_1_3, excel replace sum(log) eqkeep(N mean sd min max) keep(Female Age Year_in_program Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Mathematics_score Reading_score Baseline Treatment_intermediate Treatment_longer)

***Age standardise scores for mathematics and reading***
foreach x in Mathematics_score Reading_score {
                             egen junk = mean(`x'), by(Age)
                             gen `x'_temp = `x' - junk
                             egen `x'_sd=sd(`x'), by(Age)
    drop junk
    }                                                                                   
gen Mathematics_score_z = Mathematics_score_temp/Mathematics_score_sd
gen Reading_score_z = Reading_score_temp/Reading_score_sd
drop *_sd *_temp
drop Mathematics_score
drop Reading_score

***Creating variables
gen Cohort = Year_of_birth
gen count = 1

***Collapsing data, c.f. Deaton
g help = 1
egen N = sum(help), by(Municipality Year Cohort)
collapse (mean) Female Year_in_program Working_beside_studying Help_with_homework Grade Rural Indigenous Mother_read Father_read Mathematics_score_z Reading_score_z Baseline Treatment_intermediate Control_intermediate Treatment_longer Control_longer Municipality_no N Share [pweight=N], by(Municipality Year Cohort) 
label var N "Number of observations per municipality, cohort, year"


****
*Figure 3 - Frequency of students in each cohort in the year 2007, 2010 and 2013 
****
tab Cohort

***********
*Table 2  * Summary statistics for pseudo panel data
***********
generate Group2=0
replace Group2=1 if Treatment_longer==1
replace Group2=2 if Control_longer==1

bysort Group2: outreg2 using Out\Tables\Table_3_3, excel replace sum(log) eqkeep(N mean sd min max) keep(Female Year_in_program Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Mathematics_score_z Reading_score_z Baseline Treatment_intermediate Treatment_longer)

*Generate cluster variable
gen muniyear = Municipality_no+Year

*****
*Treatment_longer
*****
****Reading - table 10
reg Reading_score_z Treatment_intermediate Treatment_longer if Cohort >=1993
	outreg2 using Out\Tables\Table_10, excel dec(3) keep (Treatment_intermediate Treatment_longer) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Reading_score_z Treatment_intermediate  Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_10, excel dec(3) keep (Treatment_intermediate Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
reg Reading_score_z Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_10, excel dec(3) keep (Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

areg Reading_score_z i.Treatment_intermediate##c.Share i.Treatment_longer##c.Share i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_10, excel dec(3) keep (i.Treatment_intermediate i.Treatment_longer) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Treatment_intermediate##c.Share i.Treatment_longer##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_10, excel dec(3) keep (i.Treatment_intermediate i.Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Year_in_program##c.Share Female  Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_10, excel dec(3) keep (i.Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 
	
****Mathematics - table 11
reg Mathematics_score_z Treatment_intermediate Treatment_longer if Cohort >=1993
	outreg2 using Out\Tables\Table_11, excel dec(3) keep (Treatment_intermediate Treatment_longer) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Mathematics_score_z Treatment_intermediate Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_11, excel dec(3) keep (Treatment_intermediate Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
reg Mathematics_score_z Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_11, excel dec(3) keep (Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

areg Mathematics_score_z i.Treatment_intermediate##c.Share i.Treatment_longer##c.Share i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_11, excel dec(3) keep (i.Treatment_intermediate i.Treatment_longer) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Treatment_intermediate##c.Share i.Treatment_longer##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_11, excel dec(3) keep (i.Treatment_intermediate i.Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Year_in_program##c.Share Female  Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_11, excel dec(3) keep (i.Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 	

*****
*Placebo 2013
*****
****Reading - table 16
reg Reading_score_z Treatment_intermediate  if Cohort <=1992
	outreg2 using Out\Tables\Table_16, excel dec(3) keep (Treatment_intermediate) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Reading_score_z Treatment_intermediate  Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort <=1992
	outreg2 using Out\Tables\Table_16, excel dec(3) keep (Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
areg Reading_score_z i.Treatment_intermediate##c.Share i.Cohort if Cohort <=1992 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_16, excel dec(3) keep (i.Treatment_intermediate) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Treatment_intermediate##c.Share  Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort <=1992 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_16, excel dec(3) keep (i.Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

****Mathematics - table 17
reg Mathematics_score_z Treatment_intermediate  if Cohort <=1992
	outreg2 using Out\Tables\Table_17, excel dec(3) keep (Treatment_intermediate ) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Mathematics_score_z Treatment_intermediate  Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort <=1992
	outreg2 using Out\Tables\Table_17, excel dec(3) keep (Treatment_intermediate  Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
areg Mathematics_score_z i.Treatment_intermediate##c.Share  i.Cohort if Cohort <=1992 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_17, excel dec(3) keep (i.Treatment_intermediate) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Treatment_intermediate##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort <=1992 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_17, excel dec(3) keep (i.Treatment_intermediate Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

***********************************************************************************************************************************************************************************************************************************************************************************************************
*2013 3rd grade*
***********************************************************************************************************************************************************************************************************************************************************************************************************
clear
***Read in data***
use "/Users/Line/Desktop/Speciale/Data/GitHub data/df_3_empirical_analysis.dta", clear

***Age standardise scores for mathematics and reading***
foreach x in Mathematics_score Reading_score {
                             egen junk = mean(`x'), by(Age)
                             gen `x'_temp = `x' - junk
                             egen `x'_sd=sd(`x'), by(Age)
    drop junk
    }                                                                                   
gen Mathematics_score_z = Mathematics_score_temp/Mathematics_score_sd
gen Reading_score_z = Reading_score_temp/Reading_score_sd
drop *_sd *_temp
drop Mathematics_score
drop Reading_score

***Creating variables
gen Cohort = Year_of_birth
gen count = 1

***Collapsing data, c.f. Deaton
g help = 1
egen N = sum(help), by(Municipality Year Cohort)
collapse (mean) Female Year_in_program Working_beside_studying Help_with_homework Grade Rural Indigenous Mother_read Father_read Mathematics_score_z Reading_score_z Baseline Treatment_intermediate Control_intermediate Treatment_longer Control_longer Municipality_no N  Share [pweight=N], by(Municipality Year Cohort) 
label var N "Number of observations per municipality, cohort, year"


*Generate cluster variable
gen muniyear = Municipality_no+Year

*****
*Treatment_longer
*****
****Reading - table 12	
reg Reading_score_z Treatment_intermediate Treatment_longer if Cohort >=1993
	outreg2 using Out\Tables\Table_12, excel dec(3) keep (Treatment_intermediate Treatment_longer) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Reading_score_z Treatment_intermediate  Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_12, excel dec(3) keep (Treatment_intermediate Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
reg Reading_score_z Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_12, excel dec(3) keep (Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

areg Reading_score_z i.Treatment_intermediate##c.Share i.Treatment_longer##c.Share i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_12, excel dec(3) keep (i.Treatment_intermediate i.Treatment_longer) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Treatment_intermediate##c.Share i.Treatment_longer##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_12, excel dec(3) keep (i.Treatment_intermediate i.Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Reading_score_z i.Year_in_program##c.Share Female  Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_12, excel dec(3) keep (i.Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 
	
****Mathematics - table 13
reg Mathematics_score_z Treatment_intermediate Treatment_longer if Cohort >=1993
	outreg2 using Out\Tables\Table_13, excel dec(3) keep (Treatment_intermediate Treatment_longer) replace ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

reg Mathematics_score_z Treatment_intermediate Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_13, excel dec(3) keep (Treatment_intermediate Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)
	
reg Mathematics_score_z Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade Year Cohort if Cohort >=1993
	outreg2 using Out\Tables\Table_13, excel dec(3) keep (Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(OLS) addtext(Cohort FE, No, Year FE, No)

areg Mathematics_score_z i.Treatment_intermediate##c.Share i.Treatment_longer##c.Share i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_13, excel dec(3) keep (i.Treatment_intermediate i.Treatment_longer) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Treatment_intermediate##c.Share i.Treatment_longer##c.Share Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_13, excel dec(3) keep (i.Treatment_intermediate i.Treatment_longer Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 

areg Mathematics_score_z i.Year_in_program##c.Share Female  Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read Grade i.Cohort if Cohort >=1993 [pw=N], absorb(Year) cl(muniyear)
	outreg2 using Out\Tables\Table_13, excel dec(3) keep (i.Year_in_program Female Working_beside_studying Help_with_homework Rural Indigenous Mother_read Father_read) append ctitle(Fixed effects) addtext(Cohort FE, Yes, Year FE, Yes) 	
	
