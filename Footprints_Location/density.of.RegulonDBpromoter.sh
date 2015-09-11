#!/bin/bash

#bedops -e -50% lessThan60bp/phaseE.footprints.adjusted.filtered.bed transcriptionDetection/compareSigma/PromoterSigmaAll.bed | wc -l

#bedops -e -50% lessThan120bp/phaseE.footprints.adjusted.filtered.bed transcriptionDetection/compareSigma/PromoterSigmaAll.bed | wc -l

awk '{sum+=($3-$2)}END{print sum}' lessThan60bp/phaseE.footprints.adjusted.filtered.bed

awk '{sum+=($3-$2)}END{print sum}' lessThan120bp/phaseE.footprints.adjusted.filtered.bed

bedops -m lessThan60bp/phaseE.footprints.adjusted.filtered.bed lessThan120bp/phaseE.footprints.adjusted.filtered.bed | awk '{sum+=($3-$2)}END{print sum}'

bedops -e -1 transcriptionDetection/compareSigma/PromoterSigmaAll.bed lessThan60bp/phaseE.footprints.adjusted.filtered.bed | wc -l

bedops -e -1 transcriptionDetection/compareSigma/PromoterSigmaAll.bed lessThan120bp/phaseE.footprints.adjusted.filtered.bed | wc -l

bedops -m lessThan60bp/phaseE.footprints.adjusted.filtered.bed lessThan120bp/phaseE.footprints.adjusted.filtered.bed | bedops -e -1 transcriptionDetection/compareSigma/PromoterSigmaAll.bed - | wc -l

bedops -e -1 Cho.2009.STable4.TSS.promoter.bed lessThan60bp/phaseE.footprints.adjusted.filtered.bed | wc -l

bedops -e -1 Cho.2009.STable4.TSS.promoter.bed lessThan120bp/phaseE.footprints.adjusted.filtered.bed | wc -l

bedops -m lessThan60bp/phaseE.footprints.adjusted.filtered.bed lessThan120bp/phaseE.footprints.adjusted.filtered.bed |  bedops -e -1 Cho.2009.STable4.TSS.promoter.bed - | wc -l
echo"range 200"
bedops --range 200 -e -1 Cho.2009.STable4.TSS.promoter.bed lessThan60bp/phaseE.footprints.adjusted.filtered.bed | wc -l

bedops --range 200 -e -1 Cho.2009.STable4.TSS.promoter.bed lessThan120bp/phaseE.footprints.adjusted.filtered.bed | wc -l

echo"range 500"
bedops --range 500 -e -1 Cho.2009.STable4.TSS.promoter.bed lessThan60bp/phaseE.footprints.adjusted.filtered.bed | wc -l

bedops --range 500 -e -1 Cho.2009.STable4.TSS.promoter.bed lessThan120bp/phaseE.footprints.adjusted.filtered.bed | wc -l

exit



