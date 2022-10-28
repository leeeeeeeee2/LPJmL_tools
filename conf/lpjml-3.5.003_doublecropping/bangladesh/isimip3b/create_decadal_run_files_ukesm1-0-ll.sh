#!/bin/bash
#----------------------------------------------------------
# script for creating the .conf files and output directories
# for LPJmL ISIMIP3b runs split over decades
# Rutger Dankers, August 2022
#----------------------------------------------------------

modelname='GFDL-ESM4' #'MPI-ESM1-2-HR' #'IPSL-CM6A-LR'  #"UKESM1-0-LL"  
modelstr=${modelname,,}
scen="ssp585"

dumpyear=2010  #1950  #2010 
beginyear=2011 #1951  #2011
endyear=2014   #1960  #2014

# use double quotes to allow environment variables in sed search strings
sed "s/BEGINYEAR/$beginyear/g; s/ENDYEAR/$endyear/g; s/DUMPYEAR/$dumpyear/g" lpjml_Bangladesh_IGBmasked_${modelname}_hist_5min_limirr.conf > lpjml_run.conf
sed "s/BEGINYEAR/$beginyear/g; s/ENDYEAR/$endyear/g" input_Bangladesh_IGBmasked_${modelname}_hist_5min_limirr.conf > input_run.conf
mkdir /lustre/scratch/WUR/ESG/danke010/LPJmL/output/bangladesh/limirr/igbmasked_${modelstr}_hist/$beginyear

# run the model
sbatch /home/WUR/danke010/mycode/lpjml_tools/conf/lpjml-3.5.003_doublecropping/bangladesh/isimip3b/run_lpjml_Bangladesh_IGBmasked_MRI-ESM2-0_hist_5min_limirr.sh

# check output
mv output_*.txt error_output_*.txt /lustre/scratch/WUR/ESG/danke010/LPJmL/output/bangladesh/limirr/igbmasked_${modelstr}_hist/$beginyear/

# replace begin- and end year for the next run


#### SCENARIO RUNS
dumpyear=2060  # 2014 #2020
beginyear=2061  #2015 #2021
endyear=2070  #2020 #2030

# use double quotes to allow environment variables in sed search strings
sed "s/BEGINYEAR/$beginyear/g; s/ENDYEAR/$endyear/g; s/DUMPYEAR/$dumpyear/g" lpjml_Bangladesh_IGBmasked_${modelname}_${scen}_5min_limirr.conf > lpjml_run.conf
sed "s/BEGINYEAR/$beginyear/g; s/ENDYEAR/$endyear/g" input_Bangladesh_IGBmasked_${modelname}_${scen}_5min_limirr.conf > input_run.conf
mkdir /lustre/scratch/WUR/ESG/danke010/LPJmL/output/bangladesh/limirr/igbmasked_${modelstr}_${scen}/$beginyear

# run the model
# we can run the same script as for historical, since it calls the temporary lpjml_run.conf file
sbatch /home/WUR/danke010/mycode/lpjml_tools/conf/lpjml-3.5.003_doublecropping/bangladesh/isimip3b/run_lpjml_Bangladesh_IGBmasked_MRI-ESM2-0_hist_5min_limirr.sh

# check output
mv output_*.txt error_output_*.txt /lustre/scratch/WUR/ESG/danke010/LPJmL/output/bangladesh/limirr/igbmasked_${modelstr}_${scen}/$beginyear/
