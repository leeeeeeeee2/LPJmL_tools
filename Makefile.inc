#################################################################################
##                                                                             ##
##          M  a  k  e  f  i  l  e  .  m  p  i  c  h                           ##
##                                                                             ##
##   Make include file for compiler and os specific settings                   ##
##   Compile and link options for Gnu compiler gcc                             ##
##   Parallel MPI is enabled using MPICH                                       ##
##                                                                             ##
## (C) Potsdam Institute for Climate Impact Research (PIK), see COPYRIGHT file ##
## authors, and contributors see AUTHORS file                                  ##
## This file is part of LPJmL and licensed under GNU AGPL Version 3            ##
## or later. See LICENSE file or go to http://www.gnu.org/licenses/            ##
## Contact: https://github.com/PIK-LPJmL/LPJmL                                 ##
##                                                                             ##
#################################################################################

CC	= mpicc
DEBUGFLAGS  = -g
OPTFLAGS= -O3
WFLAG	= -Wall -m64
LPJFLAGS  = -DUSE_RAND48 -DUSE_MPI -DSAFE -DWITH_FPE -DUSE_NETCDF -DUSE_UDUNITS -DUSE_NETCDF4 
NETCDF_INC      = -I/cm/shared/apps/netcdf/gcc/64/4.3.3/include -I/cm/shared/apps/udunits/gcc/64/2.2.25/include
NETCDF_LIB      = /cm/shared/apps/netcdf/gcc/64/4.3.3/lib
UDUNITS_LIB      = /cm/shared/apps/udunits/gcc/64/2.2.25/lib

O	= o
A	= a
E	=
AR	= ar
ARFLAGS	= r 
RM	= rm 
RMFLAGS	= -f
#LIBS	= -lm 
LIBS    = -lm -L$(NETCDF_LIB) -lnetcdf -L$(UDUNITS_LIB) -ludunits2
LINKMAIN= mpicc
LINK	= cc -m64
MKDIR	= mkdir -p
SLASH	= /
VIEWPRG	= lpjserver
CFLAGS	= $(WFLAG) $(LPJFLAGS)  $(OPTFLAGS)
LNOPTS	= $(WFLAG) $(OPTFLAGS) -o 
LPJROOT = /home/WUR/danke010/LPJml_v4.0.002/LPJmL
