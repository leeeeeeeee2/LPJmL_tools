#!/bin/bash
#----------------------------------------------------------
# script for creating the .conf files and output directories
# for LPJmL ISIMIP3b runs split over decades
# Rutger Dankers, August 2022
#----------------------------------------------------------

dumpyear=2010  #2000
beginyear=2011  #2001
endyear=2014  #2010

# use double quotes to allow environment variables in sed search strings
sed "s/BEGINYEAR/$beginyear/g; s/ENDYEAR/$endyear/g; s/DUMPYEAR/$dumpyear/g" lpjml_Bangladesh_IGBmasked_MRI-ESM2-0_hist_5min_limirr.conf > lpjml_run.conf
sed "s/BEGINYEAR/$beginyear/g; s/ENDYEAR/$endyear/g" input_Bangladesh_IGBmasked_MRI-ESM2-0_hist_5min_limirr.conf > input_run.conf
mkdir /lustre/scratch/WUR/ESG/danke010/LPJmL/output/bangladesh/limirr/igbmasked_mri-esm2-0_hist/$beginyear

# run the model
sbatch /home/WUR/danke010/mycode/lpjml_tools/conf/lpjml-3.5.003_doublecropping/bangladesh/isimip3b/run_lpjml_Bangladesh_IGBmasked_MRI-ESM2-0_hist_5min_limirr.sh

# check output
mv output_*.txt error_output_*.txt /lustre/scratch/WUR/ESG/danke010/LPJmL/output/bangladesh/limirr/igbmasked_mri-esm2-0_hist/$beginyear/

# replace begin- and end year for the next run


#### SCENARIO RUNS
dumpyear=2090  #2020
beginyear=2091  #2021
endyear=2100  #2030

# use double quotes to allow environment variables in sed search strings
sed "s/BEGINYEAR/$beginyear/g; s/ENDYEAR/$endyear/g; s/DUMPYEAR/$dumpyear/g" lpjml_Bangladesh_IGBmasked_MRI-ESM2-0_ssp585_5min_limirr.conf > lpjml_run.conf
sed "s/BEGINYEAR/$beginyear/g; s/ENDYEAR/$endyear/g" input_Bangladesh_IGBmasked_MRI-ESM2-0_ssp585_5min_limirr.conf > input_run.conf
mkdir /lustre/scratch/WUR/ESG/danke010/LPJmL/output/bangladesh/limirr/igbmasked_mri-esm2-0_ssp585/$beginyear

# run the model
# we can run the same script as for historical, since it calls the temporary lpjml_run.conf file
sbatch /home/WUR/danke010/mycode/lpjml_tools/conf/lpjml-3.5.003_doublecropping/bangladesh/isimip3b/run_lpjml_Bangladesh_IGBmasked_MRI-ESM2-0_hist_5min_limirr.sh

# check output
mv output_*.txt error_output_*.txt /lustre/scratch/WUR/ESG/danke010/LPJmL/output/bangladesh/limirr/igbmasked_mri-esm2-0_ssp585/$beginyear/
