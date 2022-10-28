#!/bin/bash
# script to calculate area averages of LPJmL model output
# using CDO
#module load cdo/gcc/64/1.9.3

# for the regridding to work correctly without HDF errors
#module load cdo/gcc/64/1.6.8

# mask for calculating areal averages
bdmask='/home/danke010/scratch/Bangladesh/bangladesh.nc'


########## MRI HISTORICAL RUN ##########

#histdir='/home/danke010/scratch/Bangladesh/output/igbmasked_mri-esm2-0_hist/'
#histdir='/home/danke010/scratch/Bangladesh/output/igbmasked_ukesm1-0-ll_hist/'
#histdir='/home/danke010/scratch/Bangladesh/output/igbmasked_ipsl-cm6a-lr_hist/'
#histdir='/home/danke010/scratch/Bangladesh/output/igbmasked_mpi-esm1-2-hr_hist/'
histdir='/home/danke010/scratch/Bangladesh/output/igbmasked_gfdl-esm4_hist/'
cd $histdir

# calculate areal averages of monthly water balance
#cdo ifthen $bdmask mirrig.nc mirrig_bd.nc
#cdo fldmean mirrig_bd.nc mirrig_bd_fldmean.nc
# in one go using operator chaining
cdo fldmean -ifthen $bdmask mirrig.nc mirrig_bd_fldmean.nc
cdo fldmean -ifthen $bdmask mevap.nc mevap_bd_fldmean.nc
# cdo fldmean -ifthen $bdmask mtransp.nc mtransp_bd_fldmean.nc
# cdo fldmean -ifthen $bdmask minterc.nc minterc_bd_fldmean.nc
# cdo fldmean -ifthen $bdmask mrunoff.nc mrunoff_bd.nc
# cdo fldmean -ifthen $bdmask mswc1.nc mswc1_bd.nc
# cdo fldmean -ifthen $bdmask mswc2.nc mswc2_bd.nc
cdo fldmean -ifthen $bdmask mwateramount.nc mwateramount_bd.nc # could be the amount required for irrigation?

# cdo fldmean -ifthen $bdmask mwd_return.nc mwd_return_bd.nc # all zero
# cdo fldmean -ifthen $bdmask mwd_res.nc mwd_res_bd.nc # all zero
# cdo fldmean -ifthen $bdmask mwd_neighb.nc mwd_neighb_bd.nc 
# cdo fldmean -ifthen $bdmask mwd_local.nc mwd_local_bd.nc
# cdo fldmean -ifthen $bdmask mwd_gw.nc mwd_gw_bd.nc
# cdo fldmean -ifthen $bdmask mwd_unsust.nc mwd_unsust_bd.nc # all zero

cdo fldmean -ifthen $bdmask pft_harvest.grid.bin pft_harvest_bd.nc

# extract river discharge at suitable point
# brahmaputra entry point: i=198, j=50, first value = 516.37, Nov.'79 = 886.116
# NB you have to add 1 to the row/column nrs read in ncview
#cdo selindexbox,199,199,51,51  mdischarge.nc mdischarge_brahmaputra_in.nc
# lat/lon from QGIS
cdo remapnn,lon=89.903/lat=25.875 mdischarge.nc mdischarge_brahmaputra_in.nc
# ganges 175.25 50.537 25.256
cdo remapnn,lon=88.075/lat=24.609 mdischarge.nc mdischarge_ganges_in.nc

# select 1981-2010 as climate normal period

# irrigation
cdo timmean -selyear,1981/2010 mirrig_bd_fldmean.nc mirrig_bd_1981-2010_timmean.nc 
#cdo timmean mwd_neighb_bd.nc mwd_neighb_bd_1979-2005_timmean.nc
#cdo timmean mwd_local_bd.nc mwd_local_bd_1979-2005_timmean.nc
#cdo timmean mwd_gw_bd.nc mwd_gw_bd_1979-2005_timmean.nc

# harvest
cdo timmean -selyear,1981/2010 pft_harvest_bd.nc pft_harvest_bd_1981-2010_timmean.nc
# discharge
cdo timmean -selyear,1981/2010 -yearmean mdischarge_brahmaputra_in.nc mdischarge_brahmaputra_in_1981-2010_timmean.nc
cdo timmean -selyear,1981/2010 -yearmean mdischarge_ganges_in.nc mdischarge_ganges_in_1981-2010_timmean.nc

#cdo selyear,1971/2000 tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_19500101-20051231.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000.nc
#cdo ymonmean tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_1971-2000.nc tas_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_ymonmean_1971-2000.nc

# yearly, seasonal means etc.
#cdo yearmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_yearmean_19500101-20051231.nc
#cdo seasmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_seasmean_19500101-20051231.nc
#cdo monmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_mean_monmean_19500101-20051231.nc

# spatial patterns
cdo timmean -selyear,1981/2010 -ifthen $bdmask mirrig.nc mirrig_bd_masked_1981-2010_timmean.nc
#cdo selyear,1971/2000 pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_19500101-20051231.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_1971-2000.nc
#cdo timmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_1971-2000.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_timmean_1971-2000.nc
#cdo yseasmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_1971-2000.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_yseasmean_1971-2000.nc
#cdo ymonmean pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_1971-2000.nc pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_GB_masked_ymonmean_1971-2000.nc


########## MRI SSP585 RUN ##########

#rcp8dir='/home/danke010/scratch/Bangladesh/output/igbmasked_mri-esm2-0_ssp585'
#rcp8dir='/home/danke010/scratch/Bangladesh/output/igbmasked_ukesm1-0-ll_ssp585'
#rcp8dir='/home/danke010/scratch/Bangladesh/output/igbmasked_ipsl-cm6a-lr_ssp585'
#rcp8dir='/home/danke010/scratch/Bangladesh/output/igbmasked_mpi-esm1-2-hr_ssp585'
rcp8dir='/home/danke010/scratch/Bangladesh/output/igbmasked_gfdl-esm4_ssp585'
cd $rcp8dir

# calculate areal averages of monthly water balance
#cdo ifthen $bdmask mirrig.nc mirrig_bd.nc
#cdo fldmean mirrig_bd.nc mirrig_bd_fldmean.nc
# in one go using operator chaining
cdo fldmean -ifthen $bdmask mirrig.nc mirrig_bd_fldmean.nc
cdo fldmean -ifthen $bdmask mevap.nc mevap_bd_fldmean.nc
#cdo fldmean -ifthen $bdmask mtransp.nc mtransp_bd_fldmean.nc
#cdo fldmean -ifthen $bdmask minterc.nc minterc_bd_fldmean.nc
#cdo fldmean -ifthen $bdmask mrunoff.nc mrunoff_bd.nc
#cdo fldmean -ifthen $bdmask mswc1.nc mswc1_bd.nc
#cdo fldmean -ifthen $bdmask mswc2.nc mswc2_bd.nc
cdo fldmean -ifthen $bdmask mwateramount.nc mwateramount_bd.nc # could be the amount required for irrigation?

# cdo fldmean -ifthen $bdmask mwd_return.nc mwd_return_bd.nc # all zero
# cdo fldmean -ifthen $bdmask mwd_res.nc mwd_res_bd.nc # all zero
# cdo fldmean -ifthen $bdmask mwd_neighb.nc mwd_neighb_bd.nc 
# cdo fldmean -ifthen $bdmask mwd_local.nc mwd_local_bd.nc
# cdo fldmean -ifthen $bdmask mwd_gw.nc mwd_gw_bd.nc
# cdo fldmean -ifthen $bdmask mwd_unsust.nc mwd_unsust_bd.nc # all zero

# relative to historical run
cdo div -yearavg mirrig_bd_fldmean.nc $histdir/mirrig_bd_1981-2010_timmean.nc mirrig_bd_ssp8_div_hist.nc
#cdo div -yearavg mwd_neighb_bd.nc $histdir/mwd_neighb_bd_1979-2005_timmean.nc mwd_neighb_bd_rcp8_div_hist.nc
#cdo div -yearavg mwd_local_bd.nc $histdir/mwd_local_bd_1979-2005_timmean.nc mwd_local_bd_rcp8_div_hist.nc
#cdo div -yearavg mwd_gw_bd.nc $histdir/mwd_gw_bd_1979-2005_timmean.nc mwd_gw_bd_rcp8_div_hist.nc

cdo fldmean -ifthen $bdmask pft_harvest.grid.bin pft_harvest_bd.nc
# relative to historical run
cdo div pft_harvest_bd.nc $histdir/pft_harvest_bd_1981-2010_timmean.nc pft_harvest_bd_ssp8_div_hist.nc
# display average change in 2035-2064
cdo infon -timmean -selyear,2036/2065 pft_harvest_bd_ssp8_div_hist.nc


# extract river discharge at suitable point
# lat/lon from QGIS
cdo remapnn,lon=89.903/lat=25.875 mdischarge.nc mdischarge_brahmaputra_in.nc
cdo remapnn,lon=88.075/lat=24.609 mdischarge.nc mdischarge_ganges_in.nc
# relative to historical run
cdo div -yearmean mdischarge_brahmaputra_in.nc $histdir/mdischarge_brahmaputra_in_1981-2010_timmean.nc mdischarge_brahmaputra_in_yearmean_ssp8_div_hist.nc
cdo div -yearmean mdischarge_ganges_in.nc $histdir/mdischarge_ganges_in_1981-2010_timmean.nc mdischarge_ganges_in_yearmean_ssp8_div_hist.nc

# spatial patterns
cdo timmean -selyear,2071/2100 -ifthen $bdmask mirrig.nc mirrig_bd_masked_2071-2100_timmean.nc
cdo div mirrig_bd_masked_2071-2100_timmean.nc $histdir/mirrig_bd_masked_1981-2010_timmean.nc mirrig_bd_masked_2071-2100_ssp8_div_hist.nc

