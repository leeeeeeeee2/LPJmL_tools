#!/usr/bin/env Rscript
# R script to to plot LPJmL results from Bangladesh model runs
# note area averages have been calculated first with cdo using the script calc_lpjml_area_avg.sh

# This script was developed using R version 3.4.4 (2018-03-15)
# package version 'raster' 2.9.22
# package version 'R.utils' 2.9.0
# package version 'ncdf4' ‘1.17’


# =====

#library(R.utils)
library(raster)
library(ncdf4)
library(chron)
library(scales) 

rcp8dir <- "/home/danke010/scratch/Bangladesh/output/run_39397929_GFDL_rcp85"

##### RIVER DISCHARGE #####
# Plots of river inflow per year in 2006-2099 compared to hist average (2 rivers) (barplot)
rivfile1 <- paste(rcp8dir, "mdischarge_brahmaputra_in_yearmean_rcp8_div_hist.nc",sep="/")
rivfile2 <- paste(rcp8dir, "mdischarge_ganges_in_yearmean_rcp8_div_hist.nc", sep="/")

# get the data
riv1 <- nc_open(rivfile1)
riv1data <- ncvar_get(riv1, "discharge")
riv1dataname <- ncatt_get(riv1, "discharge", "long_name") 

tim <- ncvar_get(riv1, "time")
tunits <- ncatt_get(riv1,"time","units")

# convert time -- split the time units string into fields
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth <- as.integer(unlist(tdstr)[2])
tday <- as.integer(unlist(tdstr)[3])
tyear <- as.integer(unlist(tdstr)[1])
tsteps <- chron(tim,origin=c(tmonth, tday, tyear), out.format=c(dates = "yyyy-m-d", times = "h:m:s"))
# this is not going correctly since we are dealing with a 365-day calendar, not a normal (365.25) one
# generate a new sequence
alltsteps <- seq.dates(tsteps[1],by="year", length=dim(tim))
alldates <- as.Date(alltsteps) # convert to normal date object

# create dataframe 
riv1df <- data.frame(date=alldates,discharge=riv1data)
nc_close(riv1)

# get second file
riv2 <- nc_open(rivfile2)
riv2data <- ncvar_get(riv2, "discharge")
riv2df <- data.frame(date=alldates,discharge=riv2data)
nc_close(riv2)

# create plot Brahmaputra
# first find out years with positive/negative anomalies
riv1df$pos <- riv1df$discharge >= 1.0
riv1df$anom <- riv1df$discharge - 1.0

# define colors for pos/neg values
mycolors=c("red", "darkblue")

ggplot(riv1df, aes(x = date, y = anom, fill = pos)) +
  geom_col(position = "identity", show.legend = FALSE) +
  scale_fill_manual(values = mycolors) + 
  scale_y_continuous(breaks=seq(-0.3,0.6,0.3),
    labels=c("-30", "avg", "+30", "+60")) + 
  xlab("Year") + 
  ylab("River flow anomaly (%)") + 
  ggtitle("Brahmaputra inflow (RCP8.5)") + 
  theme(plot.title = element_text(hjust = 0.5))

# to change legend labels
  #scale_fill_manual(name="",labels = c("Negative","Positive"), values = mycolors)

outfile <- paste(rcp8dir,"plots","mdischarge_brahmaputra_in_yearmean_rcp8_div_hist.png",sep="/")
ggsave(file=outfile, width=6, height=3, dpi=300)

# create plot Ganges
riv2df$pos <- riv2df$discharge >= 1.0
riv2df$anom <- riv2df$discharge - 1.0

ggplot(riv2df, aes(x = date, y = anom, fill = pos)) +
  geom_col(position = "identity", show.legend = FALSE) +
  scale_fill_manual(values = mycolors) + 
  scale_y_continuous(breaks=seq(-0.5,1.5,0.5),
    labels=c("-50", "avg", "+50", "+100", "+150")) + 
  xlab("Year") + 
  ylab("River flow anomaly (%)") + 
  ggtitle("Ganges inflow (RCP8.5)") + 
  theme(plot.title = element_text(hjust = 0.5))

# to change legend labels
  #scale_fill_manual(name="",labels = c("Negative","Positive"), values = mycolors)

outfile <- paste(rcp8dir,"plots","mdischarge_ganges_in_yearmean_rcp8_div_hist.png",sep="/")
ggsave(file=outfile, width=6, height=3, dpi=300)


##### PRECIPITATION #####
metdir <- "/home/danke010/scratch/Bangladesh/meteo/isimip2b"

histfile <- paste(metdir, "pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_ymonmean_1971-2000.nc", sep="/")
rcp8file <- paste(metdir, "pr_day_GFDL-ESM2M_rcp85_r1i1p1_EWEMBI_BD_mean_ymonmean_2070-2099.nc", sep="/")

# get the data - historical
prh <- nc_open(histfile)
prhdata <- ncvar_get(prh, "pr")
prhdataname <- ncatt_get(prh, "pr", "long_name") 

mon <- ncvar_get(prh, "time")
tunits <- ncatt_get(prh,"time","units")

# convert time -- split the time units string into fields
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth <- as.integer(unlist(tdstr)[2])
tday <- as.integer(unlist(tdstr)[3])
tyear <- as.integer(unlist(tdstr)[1])
tsteps <- chron(mon,origin=c(tmonth, tday, tyear), out.format=c(dates = "yyyy-m-d", times = "h:m:s"))
#tsteps <- chron(mon,origin=c(tmonth, tday, tyear), out.format=c(dates = "mmm"))
alldates <- as.Date(tsteps) # convert to normal date object
allmonths <- format(alldates, "%b")
ndays <- strtoi(format(alldates, "%d")) # since the date is on the last day of every month
ndays[2] <- 28

#midmon = format(alldates,format="%Y-%m")
midmon = as.Date(format(alldates,format="%Y-%m-15"))

# create dataframe 
prhdf <- data.frame(mon=midmon,precipitation=prhdata)
prhdf$pr_mm <- prhdf$precipitation * 3600*24*ndays
nc_close(prh)

# get the data - scenario
pr8 <- nc_open(rcp8file)
pr8data <- ncvar_get(pr8, "pr")
pr8df <- data.frame(mon=midmon,precipitation=pr8data)
pr8df$pr_mm <- pr8df$precipitation * 3600*24*ndays
nc_close(pr8)

# create plot
prhdf$pr_rcp8 <- pr8df$pr_mm
#ggplot(data=prhdf, aes(x=mon, y=pr_mm, group=1)) +
#  geom_line(color="darkgreen")+
#  geom_point()

ggplot(prhdf, aes(mon)) + 
  geom_line(aes(y = pr_mm, group=1, colour = "historical"),size=1.5) + 
  geom_line(aes(y = pr_rcp8, group=2, colour = "RCP8.5"),size=1.5) +
  #scale_x_continuous(labels=allmonths) + 
  scale_color_manual(name = "", values = c("historical" = "darkgreen", "RCP8.5" = "orange")) + 
  scale_x_date(date_labels = "%b",breaks = date_breaks("months")) +
  xlab("Month") + 
  ylab("Precipitation (mm/month)") + 
  ggtitle("Mean precipitation over Bangladesh") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme(legend.position = c(0.9, 0.9))

# save plot pr_day_GFDL-ESM2M_historical_r1i1p1_EWEMBI_BD_mean_ymonmean_1971-2000.nc
outfile <- paste(rcp8dir,"plots","pr_day_GFDL-ESM2M_ymonmean_1971-200_rcp85_2070-2099.png",sep="/")
ggsave(file=outfile, width=6, height=3, dpi=300)


##### IRRIGATION #####
#    Irrigation compared to hist (mirrig_bd_rcp8_div_hist.nc) (barplot)
irrfile <- paste(rcp8dir, "mirrig_bd_rcp8_div_hist.nc",sep="/")

# get the data
irr1 <- nc_open(irrfile)
irrdata <- ncvar_get(irr1, "irrig")
irrdataname <- ncatt_get(irr1, "irrig", "long_name") 

tim <- ncvar_get(irr1, "time")
tunits <- ncatt_get(irr1,"time","units")

# convert time -- split the time units string into fields
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth <- as.integer(unlist(tdstr)[2])
tday <- as.integer(unlist(tdstr)[3])
tyear <- as.integer(unlist(tdstr)[1])
tsteps <- chron(tim,origin=c(tmonth, tday, tyear), out.format=c(dates = "yyyy-m-d", times = "h:m:s"))
# this is not going correctly since we are dealing with a 365-day calendar, not a normal (365.25) one
# generate a new sequence
alltsteps <- seq.dates(tsteps[1],by="year", length=dim(tim))
alldates <- as.Date(alltsteps) # convert to normal date object

# create dataframe 
irrdf <- data.frame(date=alldates,irrig=irrdata)
nc_close(irr1)

# create plot irrigation
# first find out years with positive/negative anomalies
irrdf$pos <- irrdf$irrig >= 1.0
irrdf$anom <- irrdf$irrig - 1.0

# define colors for pos/neg values
mycolors=c("red", "darkblue")

ggplot(irrdf, aes(x = date, y = anom, fill = pos)) +
  geom_col(position = "identity", show.legend = FALSE) +
  scale_fill_manual(values = mycolors) + 
  scale_y_continuous(breaks=seq(-0.8,0.4,0.2),
    labels=c("-80", "-60", "-40", "-20", "avg", "+20", "+40")) + 
  xlab("Year") + 
  ylab("Irrigation anomaly (%)") + 
  ggtitle("Irrigation over Bangladesh (RCP8.5)") + 
  theme(plot.title = element_text(hjust = 0.5))

# to change legend labels
  #scale_fill_manual(name="",labels = c("Negative","Positive"), values = mycolors)

outfile <- paste(rcp8dir,"plots","mirrig_bd_rcp8_div_hist.nc.png",sep="/")
ggsave(file=outfile, width=6, height=3, dpi=300)


##### WATER WITHDRAWAL #####
#    Water withdrawal compared to hist: surface, gw
# Perhaps only use gw: mwd_gw_bd_rcp8_div_hist.nc
wdfile <- paste(rcp8dir, "mwd_gw_bd_rcp8_div_hist.nc",sep="/")

# get the data
wd1 <- nc_open(wdfile)
wddata <- ncvar_get(wd1, "wd_gw")
wddataname <- ncatt_get(wd1, "wd_gw", "long_name") 

tim <- ncvar_get(wd1, "time")
tunits <- ncatt_get(wd1,"time","units")

# convert time -- split the time units string into fields
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth <- as.integer(unlist(tdstr)[2])
tday <- as.integer(unlist(tdstr)[3])
tyear <- as.integer(unlist(tdstr)[1])
tsteps <- chron(tim,origin=c(tmonth, tday, tyear), out.format=c(dates = "yyyy-m-d", times = "h:m:s"))
# this is not going correctly since we are dealing with a 365-day calendar, not a normal (365.25) one
# generate a new sequence
alltsteps <- seq.dates(tsteps[1],by="year", length=dim(tim))
alldates <- as.Date(alltsteps) # convert to normal date object

# create dataframe 
wddf <- data.frame(date=alldates,withdrawal=wddata)
nc_close(wd1)

# create plot GW withdrawal
# first find out years with positive/negative anomalies
wddf$pos <- wddf$withdrawal >= 1.0
wddf$anom <- wddf$withdrawal - 1.0

# define colors for pos/neg values
mycolors=c("red", "darkblue")

ggplot(wddf, aes(x = date, y = anom, fill = pos)) +
  geom_col(position = "identity", show.legend = FALSE) +
  scale_fill_manual(values = mycolors) + 
  scale_y_continuous(breaks=seq(-0.8,0.4,0.2),
    labels=c("-80", "-60", "-40", "-20", "avg", "+20", "+40")) + 
  xlab("Year") + 
  ylab("GW withdrawal anomaly (%)") + 
  ggtitle("GW withdrawal over Bangladesh (RCP8.5)") + 
  theme(plot.title = element_text(hjust = 0.5))

# to change legend labels
  #scale_fill_manual(name="",labels = c("Negative","Positive"), values = mycolors)

outfile <- paste(rcp8dir,"plots","mwd_gw_bd_rcp8_div_hist.png",sep="/")
ggsave(file=outfile, width=6, height=3, dpi=300)


##### CROP YIELDS #####
#    Crop yields compared to hist: wheat and rice (going up); maize and trop cereals (going down)
# pft_harvest_bd_rcp8_div_hist.nc
yldfile <- paste(rcp8dir, "pft_harvest_bd_rcp8_div_hist.nc",sep="/")

# get the data
yld1 <- nc_open(yldfile)
ylddata <- ncvar_get(yld1, "harvest")
ylddataname <- ncatt_get(yld1, "harvest", "long_name") 

#dim(ylddata)
#[1] 32 94

pft <- yld1$dim['pft']$pft$vals

tim <- ncvar_get(yld1, "time")
tunits <- ncatt_get(yld1,"time","units")

# convert time -- note this time we only got years
tmonth <- rep(7, length(tim))
tday <- rep(15, length(tim))
alltsteps <- paste(tim, tmonth, tday,sep="-")
alldates <- as.Date(alltsteps) # convert to normal date object

# create dataframe 
# rainfed wheat: pft 1
# irrigated wheat: pft 17
# rainfed rice: pft 2
# irrigated rice: pft 18

# rainfed maize: pft 3
# rainfed trop cereals: pft 4
# irrigated maize: pft 19
# irrigated trop cereals: pft 20
#myylddata <- ylddata[c(1:4,17:20),]
#ylddf <- data.frame(date=alldates,yield=t(myylddata))
ylddf <- data.frame(date=alldates,yield=t(ylddata))
#myyldf <- ylddf[c("date","yield.1","yield.2","yield.3","yield.4",
#    "yield.17", "yield.18","yield.19","yield.20")]
nc_close(yld1)

# subset CFTs for plotting
#cftname <- "Wheat"
#myylddf <- ylddf[c("date", "yield.1", "yield.17")]
#cftname <- "Rice"
#myylddf <- ylddf[c("date", "yield.2", "yield.18")]
#cftname <- "Maize"
#myylddf <- ylddf[c("date", "yield.3", "yield.19")]
cftname <- "Tropical Cereals"
myylddf <- ylddf[c("date", "yield.4", "yield.20")]


# generic beyond this point
colnames(myylddf)[2] <- "yield.rainfed"
colnames(myylddf)[3] <- "yield.irrig"

# create plot of yields
# first convert the data to actual anomalies
myylddf$anom.rainfed <- myylddf$yield.rainfed - 1.0
myylddf$anom.irrig <- myylddf$yield.irrig - 1.0

# plot from multiple dataframes
#ggplot() + 
#geom_line(data=Data1, aes(x=A, y=B), color='green') + 
#geom_line(data=Data2, aes(x=C, y=D), color='red')

ggplot(myylddf, aes(date)) + 
  #geom_rect(data=NULL,aes(xmin=as.Date("2000-01-01"),xmax=max(myylddf$date),ymin=-Inf,ymax=0.0),
  #                  fill="darkgrey") +
  geom_ribbon(aes(ymin=-Inf, ymax=0), alpha=0.25) + 
  geom_line(aes(y = anom.rainfed, group=1, colour = "rainfed"),size=1.5) + 
  geom_line(aes(y = anom.irrig, group=2, colour = "irrigated"),size=1.5) +
  scale_color_manual(name = "", values = c("rainfed" = "blue", "irrigated" = "darkgreen")) + 
  scale_x_date(expand=c(0,0)) +
  scale_y_continuous(breaks=seq(-0.6,0.6,0.3), limits=c(-0.6,0.6),
    labels=c("-60", "-30", "avg", "+30", "+60")) + 
  xlab("Year") + 
  ylab("Yield anomaly (%)") + 
  ggtitle(paste(cftname, "mean yield anomaly over Bangladesh")) + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme(legend.position = c(0.1, 0.2)) + 
  theme(legend.background=element_rect(fill = alpha("white", 0.0)))


outfile <- paste(rcp8dir,"plots",paste(tolower(cftname), "harvest_bd_rcp8_div_hist.png", sep="_"),sep="/")
ggsave(file=outfile, width=6, height=3, dpi=300)

# what is the average anomaly at the end of century?
summary(myylddf[65:94,])