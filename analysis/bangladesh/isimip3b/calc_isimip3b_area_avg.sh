#!/bin/bash
# script to calculate area averages of ISIMIP3b climate data
# using CDO
#module load cdo/gcc/64/1.9.3

# for the regridding to work correctly without HDF errors
module load cdo/gcc/64/1.6.8

climrootdir='/lustre/backup/WUR/ESG/data/CLIMATE_DATA/ISIMIP/ISIMIP3b/landonly/'
outrootdir='/lustre/scratch/WUR/ESG/danke010/ISIMIP3b/landonly/'
scen='historical' #'ssp585' 'ssp370' 'ssp126'
model='MRI-ESM2-0' # 'UKESM1-0-LL' 'IPSL-CM6A-LR' 'MPI-ESM1-2-HR' 'GFDL-ESM4'
modelname=${model,,} # to lowercase
ens='r1i1p1f1' # r1i1p1f2

outdir=${outrootdir}${model}


cd $outdir

# calculate monthly, seasonal, annual averages 
# calculate areal averages for GB basin and BD
# for hist and ssp585
# for temp and precip

# first generate weights
climdir=${climrootdir}${scen}/${model}
var='tas'
cdo gennn,$outrootdir/bangladesh.nc $climdir/${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_1850_1850.nc ${modelname}_remapnn_weights.nc


######## TEMPERATURE

var='tas'
scen='historical' #'ssp585' 'ssp370' 'ssp126'
climdir=${climrootdir}${scen}/${model}
years=( 1981 1991 2001 )
ys=1981
ye=2010

# ~~~~~~
# remap the input file to this grid (entire modelling area)
for y1 in "${years[@]}"
do
   y2=$((y1+9)) 
   echo $y1 $y2
   cdo remap,$outrootdir/bangladesh.nc,${modelname}_remapnn_weights.nc $climdir/${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${y1}_${y2}.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${y1}_${y2}_BD.nc
done

# concatenate 
cdo mergetime ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_[${years[0]}-${years[-1]}]*_BD.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD.nc
# remove unnecessary files
for y1 in "${years[@]}"
do
   y2=$((y1+9)) 
   echo $y1 $y2
   rm ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${y1}_${y2}_BD.nc
done

# calculate average over BD only
cdo ifthen $outrootdir/bangladesh.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_masked.nc
cdo fldmean ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_mean.nc
# yearly, seasonal means etc.
cdo yearmean ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_mean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_mean_yearmean.nc
cdo seasmean ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_mean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_mean_seasmean.nc
# select ${ys}-${ye}0 as climate normal period
#cdo selyear,1971/2000 ${var}_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc ${var}_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000.nc
cdo ymonmean ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_mean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_mean_ymonmean.nc


# calculate average over GB-bd basin only
cdo ifthen $outrootdir/GB_bangladesh.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc
cdo fldmean ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_mean.nc
# yearly, seasonal means etc.
cdo yearmean ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_mean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_mean_yearmean.nc
cdo seasmean ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_mean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_mean_seasmean.nc
# select ${ys}-${ye}0 as climate normal period
#cdo selyear,1971/2000 ${var}_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc ${var}_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000.nc
cdo ymonmean ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_mean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_mean_ymonmean.nc
# ~~~~~~


# repeat for scenario
scen='ssp585'
climdir=${climrootdir}${scen}/${model}
years=( 2021 2031 2041 2051 2061 2071 2081 2091 )
ys=2021
ye=2100

# ~~~~~~ repeat code above
# select 2071-2100 as climate normal period
cdo -ymonmean -selyear,2071/2100 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_mean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_BD_mean_ymonmean.nc
cdo -ymonmean -selyear,2071/2100 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_mean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_mean_ymonmean.nc




######## PRECIPITATION

var='pr'
scen='historical' #'ssp585' 'ssp370' 'ssp126'
climdir=${climrootdir}${scen}/${model}
years=( 1981 1991 2001 )
ys=1981
ye=2010

# ~~~~~~ repeat code above
# spatial patterns
cdo timmean ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked_timmean.nc
cdo yseasmean ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked_yseasmean.nc
cdo ymonmean ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked_ymonmean.nc
# nr of rain days above threshold
# NB cdo assumes rain data in mm/d, so convert threshold value first
thresh1=$(echo "1./(60.*60.*24.)" | bc -l) # 1 mm/day in kg/m2/s
thresh5=$(echo "5./(60.*60.*24.)" | bc -l) # 5 mm/day
cdo eca_rr1,$thresh1 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked_rr1.nc
cdo eca_rr1,$thresh5 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked_rr5.nc

# repeat for scenario
scen='ssp585'
climdir=${climrootdir}${scen}/${model}
years=( 2021 2031 2041 2051 2061 2071 2081 2091 )
ys=2021
ye=2100

# ~~~~~~ repeat code above
# select 2071-2100 as climate normal period
cdo -ymonmean -selyear,2071/2100 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_mean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_BD_mean_ymonmean.nc
cdo -ymonmean -selyear,2071/2100 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_mean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_mean_ymonmean.nc
# spatial patterns
cdo -timmean -selyear,2071/2100 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_masked_timmean.nc
cdo -yseasmean -selyear,2071/2100 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_masked_yseasmean.nc
cdo -ymonmean -selyear,2071/2100 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_masked_ymonmean.nc
cdo -eca_rr1,$thresh1 -selyear,2071/2100 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_masked_rr1.nc
cdo -eca_rr1,$thresh5 -selyear,2071/2100 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_GB_masked.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_masked_rr5.nc

# select period 2031-2050
cdo -ymonmean -selyear,2031/2050 ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_${ys}-${ye}_BD_mean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2031-2050_BD_mean_ymonmean.nc


# precipitation anomalies
# note values symmetrical around zero, 0.5 = +50% etc.
cdo -div -sub ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_masked_timmean.nc ${modelname}_${ens}_w5e5_historical_${var}_landonly_daily_1981-2010_GB_masked_timmean.nc ${modelname}_${ens}_w5e5_historical_${var}_landonly_daily_1981-2010_GB_masked_timmean.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_masked_timmean_div_historical.nc
cdo sub ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_masked_rr1.nc ${modelname}_${ens}_w5e5_historical_${var}_landonly_daily_1981-2010_GB_masked_rr1.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_masked_rr1_sub_historical.nc
cdo sub ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_masked_rr5.nc ${modelname}_${ens}_w5e5_historical_${var}_landonly_daily_1981-2010_GB_masked_rr5.nc ${modelname}_${ens}_w5e5_${scen}_${var}_landonly_daily_2071-2100_GB_masked_rr5_sub_historical.nc


