*CTDC Data

*Load Data from CTDC
clear
import excel "/Users/canaan/Desktop/Semester 6/IOM Research/The Global Dataset 3 Sept 2018.xlsx", firstrow

*destring variables
destring minor, replace ignore(B)
destring IntimatePartner, replace ignore(B)
destring Friend, replace ignore(B)
destring Family, replace ignore(B)
destring RelationOther, replace ignore(B)
destring Threats, replace ignore(B)
destring TakesEarnings, replace ignore(B)
destring PsychologicalAbuse, replace ignore(B)
destring PhysicalAbuse, replace ignore(B)
destring SexualAbuse, replace ignore(B)

*summary statistics
capture ssc install estout
estpost summarize female minor IntimatePartner Friend Family RelationOther RelationUnknown developping conflict degreeofvulnerability, detail
esttab . using sumstat.rtf, ///
   cells("mean(fmt(%5.2f) label(Mean)) sd(label(SD)) min(label(Min)) max(label(Max))  count(fmt(%9.0f) label(N))") ///
   noobs label nonum replace mlabels(none) title(Summary Statistics)

capture ssc install estout
estpost summarize Threats TakesEarnings PsychologicalAbuse PhysicalAbuse SexualAbuse degreeofvulnerability, detail
esttab . using sumstat1.rtf, ///
   cells("mean(fmt(%5.2f) label(Mean)) sd(label(SD)) min(label(Min)) max(label(Max))  count(fmt(%9.0f) label(N))") ///
   noobs label nonum replace mlabels(none) title(Summary Statistics for Types of Vulnerability)
  
*regressions
reg degreeofvulnerability female minor
reg degreeofvulnerability IntimatePartner Friend Family RelationOther RelationUnknown
reg degreeofvulnerability developping conflict
reg degreeofvulnerability female minor IntimatePartner Friend Family RelationOther RelationUnknown developping conflict

. ssc install estout, replace
eststo A : reg degreeofvulnerability female minor
eststo B : reg degreeofvulnerability IntimatePartner Friend Family RelationOther RelationUnknown
eststo C : reg degreeofvulnerability developping conflict
eststo D : reg degreeofvulnerability female minor IntimatePartner Friend Family RelationOther RelationUnknown developping conflict
esttab A B C D using OLS.doc, se r2

. ssc install estout, replace
eststo A : reg degreeofvulnerability female minor, fe
eststo B : reg degreeofvulnerability IntimatePartner Friend Family RelationOther RelationUnknown, fe
eststo C : reg degreeofvulnerability developping conflict, fe
eststo D : reg degreeofvulnerability female minor IntimatePartner Friend Family RelationOther RelationUnknown developping conflict, fe
esttab A B C D using FE.doc, se r2

. ssc install estout, replace
eststo A : xtreg degreeofvulnerability female minor, re
eststo B : xtreg degreeofvulnerability IntimatePartner Friend Family RelationOther RelationUnknown, re
eststo C : xtreg degreeofvulnerability developping conflict, re
eststo D : xtreg degreeofvulnerability female minor IntimatePartner Friend Family RelationOther RelationUnknown developping conflict, re
esttab A B C D using RE.doc, se r2
