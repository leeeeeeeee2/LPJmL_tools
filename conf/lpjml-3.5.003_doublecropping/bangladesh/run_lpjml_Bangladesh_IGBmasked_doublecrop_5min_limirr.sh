#!/bin/bash
#-----------------------------Mail address-----------------------------
#SBATCH --mail-user=rutger.dankers@wur.nl
#SBATCH --mail-type=ALL
#-----------------------------Output files-----------------------------
#SBATCH --output=output_%j.txt
#SBATCH --error=error_output_%j.txt
#-----------------------------Other information------------------------
#SBATCH --comment=5200046748
#SBATCH --job-name=lpjml_Bangladesh_IGBmasked_doublecrop_5min_limirr.conf
#-----------------------------Required resources-----------------------
#SBATCH --qos=std
#SBATCH --time=300
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=64000

#-----------------------------Environment, Operations and Job steps----
#load modules
module load slurm mpich/gcc/64/3.1.3
module load netcdf/gcc/64/4.3.3
module load udunits/gcc/64/2.2.25

 
export LPJROOT="/home/WUR/danke010/mycode/uzbekistan/lpjml-3.5.003"

mpirun "$LPJROOT/bin/lpjml" /home/WUR/danke010/mycode/uzbekistan/lpjml_runs/bangladesh/lpjml_Bangladesh_IGBmasked_doublecrop_5min_limirr.conf

# sbatch /home/WUR/danke010/mycode/uzbekistan/lpjml_runs/bangladesh/run_lpjml_Bangladesh_IGBmasked_doublecrop_5min_limirr.sh