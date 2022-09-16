#!/bin/bash
# script to concatenate LPJmL output files from multiple periods
# using CDO
module load cdo/gcc/64/1.9.3

#myfile="mdischarge.nc"
#myfile="mirrig.nc"
#myfile="mevap.nc"
#mtransp.nc
#minterc.nc
#mrunoff.nc
#mswc1.nc
#mswc2.nc
#myfile="mwateramount.nc"
myfile="pft_harvest.grid.bin"

histdir="/lustre/scratch/WUR/ESG/danke010/LPJmL/output/bangladesh/limirr/igbmasked_mri-esm2-0_hist"
#allyears=($(seq 1951 10 2011))
sspdir="/lustre/scratch/WUR/ESG/danke010/LPJmL/output/bangladesh/limirr/igbmasked_mri-esm2-0_ssp585"

# merge files from hist run
cdo mergetime ${histdir}/1951/${myfile} ${histdir}/1961/${myfile} ${histdir}/1971/${myfile} ${histdir}/1981/${myfile} ${histdir}/1991/${myfile} ${histdir}/2001/${myfile} ${histdir}/2011/${myfile} ${histdir}/${myfile}

# merge files from SSP run
cdo mergetime ${sspdir}/2015/${myfile} ${sspdir}/2021/${myfile} ${sspdir}/2031/${myfile} ${sspdir}/2041/${myfile} ${sspdir}/2051/${myfile} ${sspdir}/2061/${myfile} ${sspdir}/2071/${myfile} ${sspdir}/2081/${myfile} ${sspdir}/2091/${myfile} ${sspdir}/${myfile}
