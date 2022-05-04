#!/bin/bash
# script to calculate area averages of ISIMIP2b climate data
# using CDO
#module load cdo/gcc/64/1.9.3

# for the regridding to work correctly without HDF errors
module load cdo/gcc/64/1.6.8

climdir='/lustre/backup/WUR/ESG/data/CLIMATE_DATA/ISIMIP/ISIMIP2b/landonly'
outdir='/lustre/scratch/WUR/ESG/danke010/ISIMIP2b/landonly/GFDL-ESM2M'

cd $outdir

# calculate monthly, seasonal, annual averages 
# calculate areal averages for GB basin and BD
# for hist and rcp85
# for temp and precip

#cdo remapnn,bangladesh.nc $climdir/tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_landonly_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_19500101-20051231.nc

# first generate weights
cdo gennn,bangladesh.nc $climdir/tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_landonly_19500101-20051231.nc GFDL-ESM2M_remapnn_weights.nc

######## TEMPERATURE

# remap the input file to this grid (entire modelling area)
cdo remap,bangladesh.nc,GFDL-ESM2M_remapnn_weights.nc $climdir/tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_landonly_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_19500101-20051231.nc

# calculate average over BD only
cdo ifthen bangladesh.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_masked_19500101-20051231.nc
cdo fldmean tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_masked_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc
# yearly, seasonal means etc.
cdo yearmean tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_yearmean_19500101-20051231.nc
cdo seasmean tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_seasmean_19500101-20051231.nc
# select 1971-2000 as climate normal period
cdo selyear,1971/2000 tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000.nc
cdo ymonmean tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_ymonmean_1971-2000.nc
cdo timmean tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000_timmean.nc
cdo sub tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_yearmean_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000_timmean.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_yearmean_1950-2005_anom_from_1971-2000.nc


# calculate average over GB-bd basin only
cdo ifthen GB_bangladesh.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_19500101-20051231.nc
cdo fldmean tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc
# yearly, seasonal means etc.
cdo yearmean tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_yearmean_19500101-20051231.nc
cdo seasmean tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_seasmean_19500101-20051231.nc
# select 1971-2000 as climate normal period
cdo selyear,1971/2000 tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_1971-2000.nc
cdo ymonmean tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_1971-2000.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_ymonmean_1971-2000.nc
cdo timmean tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_1971-2000.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_1971-2000_timmean.nc
cdo sub tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_yearmean_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_1971-2000_timmean.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_yearmean_1950-2005_anom_from_1971-2000.nc


# repeat for scenario
# remap the input file to this grid (entire modelling area)
cdo remap,bangladesh.nc,GFDL-ESM2M_remapnn_weights.nc $climdir/tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_landonly_20060101-20991231.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_20060101-20991231.nc
# calculate average over BD only
cdo ifthen bangladesh.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_20060101-20991231.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_masked_20060101-20991231.nc
cdo fldmean tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_masked_20060101-20991231.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_20060101-20991231.nc
# yearly, seasonal means etc.
cdo yearmean tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_20060101-20991231.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_yearmean_20060101-20991231.nc
# select 2070-2099 as climate normal period
cdo selyear,2070/2099 tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_20060101-20991231.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_2070-2099.nc
cdo ymonmean tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_2070-2099.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_ymonmean_2070-2099.nc
# anomalies from 1971-2000
cdo sub tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_yearmean_20060101-20991231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000_timmean.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_yearmean_2006-2099_anom_from_1971-2000.nc
cdo cat tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_yearmean_1950-2005_anom_from_1971-2000.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_yearmean_2006-2099_anom_from_1971-2000.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_yearmean_1950-2099_anom_from_1971-2000.nc

# calculate average over GB-bd basin only
cdo ifthen GB_bangladesh.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_20060101-20991231.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_20060101-20991231.nc
cdo fldmean tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_20060101-20991231.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_20060101-20991231.nc
# yearly, seasonal means etc.
cdo yearmean tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_20060101-20991231.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_yearmean_20060101-20991231.nc
# select 2070-2099 as climate normal period
cdo selyear,2070/2099 tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_20060101-20991231.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_2070-2099.nc
cdo ymonmean tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_2070-2099.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_ymonmean_2070-2099.nc
# anomalies from 1971-2000
cdo sub tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_yearmean_20060101-20991231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_1971-2000_timmean.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_yearmean_2006-2099_anom_from_1971-2000.nc
cdo cat tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_yearmean_1950-2005_anom_from_1971-2000.nc tas_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_yearmean_2006-2099_anom_from_1971-2000.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_yearmean_1950-2099_anom_from_1971-2000.nc



######## PRECIPITATION
# remap the input file to this grid (entire modelling area)
cdo remap,bangladesh.nc,GFDL-ESM2M_remapnn_weights.nc $climdir/pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_landonly_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_19500101-20051231.nc

# calculate average over BD only
cdo ifthen bangladesh.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_masked_19500101-20051231.nc
cdo fldmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_masked_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc
# yearly, seasonal means etc.
cdo yearmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_yearmean_19500101-20051231.nc
cdo seasmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_seasmean_19500101-20051231.nc
cdo monmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_monmean_19500101-20051231.nc
# select 1971-2000 as climate normal period
cdo selyear,1971/2000 pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000.nc
cdo ymonmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_ymonmean_1971-2000.nc

# calculate average over GB-bd basin only
cdo ifthen GB_bangladesh.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_19500101-20051231.nc
cdo fldmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc
# yearly, seasonal means etc.
cdo yearmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_yearmean_19500101-20051231.nc
cdo seasmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_seasmean_19500101-20051231.nc
cdo monmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_monmean_19500101-20051231.nc
# select 1971-2000 as climate normal period
cdo selyear,1971/2000 pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_1971-2000.nc
cdo ymonmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_1971-2000.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_ymonmean_1971-2000.nc

# spatial patterns
cdo selyear,1971/2000 pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_1971-2000.nc
cdo timmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_1971-2000.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_timmean_1971-2000.nc
cdo yseasmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_1971-2000.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_yseasmean_1971-2000.nc
cdo ymonmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_1971-2000.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_ymonmean_1971-2000.nc

# repeat for scenario
# remap the input file to this grid (entire modelling area) (-s for avoiding numerous messages)
cdo -s remap,bangladesh.nc,GFDL-ESM2M_remapnn_weights.nc $climdir/pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_landonly_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_20060101-20991231.nc
# calculate average over BD only
cdo ifthen bangladesh.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_masked_20060101-20991231.nc
cdo fldmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_masked_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_20060101-20991231.nc
# yearly, seasonal means etc.
cdo yearmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_yearmean_20060101-20991231.nc
cdo seasmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_seasmean_20060101-20991231.nc
cdo monmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_monmean_20060101-20991231.nc
# select 2070-2099 as climate normal period
cdo selyear,2070/2099 pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_2070-2099.nc
cdo ymonmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_2070-2099.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_ymonmean_2070-2099.nc

# calculate average over GB-bd basin only
cdo ifthen GB_bangladesh.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_20060101-20991231.nc
cdo fldmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_20060101-20991231.nc
# yearly, seasonal means etc.
cdo yearmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_yearmean_20060101-20991231.nc
cdo seasmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_seasmean_20060101-20991231.nc
cdo monmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_monmean_20060101-20991231.nc
# select 2070-2099 as climate normal period
cdo selyear,2070/2099 pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_2070-2099.nc
cdo ymonmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_2070-2099.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_ymonmean_2070-2099.nc
# 2006-2035 as "current" climate
cdo selyear,2006/2035 pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_2006-2035.nc
cdo ymonmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_2006-2035.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_mean_ymonmean_2006-2035.nc

# spatial patterns
cdo selyear,2006/2035 pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_2006-2035.nc
cdo timmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_2006-2035.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_timmean_2006-2035.nc
cdo yseasmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_2006-2035.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_yseasmean_2006-2035.nc
cdo ymonmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_2006-2035.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_ymonmean_2006-2035.nc

cdo selyear,2070/2099 pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_20060101-20991231.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_2070-2099.nc
cdo timmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_2070-2099.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_timmean_2070-2099.nc
cdo yseasmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_2070-2099.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_yseasmean_2070-2099.nc
cdo ymonmean pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_2070-2099.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_ymonmean_2070-2099.nc

# precipitation anomalies
cdo div pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_timmean_2070-2099.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_timmean_1971-2000.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_timmean_2070-2099_div_1971-2000.nc
cdo div pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_timmean_2006-2035.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_timmean_1971-2000.nc pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_GB_masked_timmean_2006-2035_div_1971-2000.nc