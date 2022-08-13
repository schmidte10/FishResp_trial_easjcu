#--- load libraries ---# 
library(tidyverse) 
library(FishResp) 

#--- set working directory ---# 
setwd("C:/Users/jc527762/OneDrive - James Cook University/PhD dissertation/Data/Resp")

#--- experiment information ---# 
# Fish mass (kg)
Fish1.Mass = 0.03170 
Fish2.Mass = 0.03792 
Fish3.Mass = 0.04005 
Fish4.Mass = 0.02880 
Fish.Mass = c(Fish1.Mass,Fish2.Mass,Fish3.Mass,Fish4.Mass)

Fish1.ID = "LCKM165" 
Fish2.ID = "CTON069" 
Fish3.ID = "LKES143"
Fish4.ID = "LCKM174" 
Fish.ID = c(Fish1.ID,Fish2.ID,Fish3.ID,Fish4.ID)

Chamber.volume = rep(1.5, 4)

#--- get path to date files ---# 
pyroscience.path = "C:/Users/jc527762/OneDrive - James Cook University/PhD dissertation/Data/Resp/Dell/Experiment_ 01 August 2022 11 37AM/Oxygen data raw/Firesting.txt"
aquaresp.path = "C:/Users/jc527762/OneDrive - James Cook University/PhD dissertation/Data/Resp/Dell/Experiment_ 01 August 2022 11 37AM/Summary data resp 4.txt"

#--- convert data file type ---# 
# data file will be saved in the working directory
pyroscience.aquaresp(pyroscience.file = pyroscience.path, 
                     aquaresp.file = aquaresp.path, 
                     fishresp.file = "fishresp.txt", 
                     date.format = "DMY", 
                     n.chamber = 4, 
                     wait.phase = 5, 
                     measure.phase = 214) 

#--- convert units data is in ---# 
convert.respirometry("fishresp.txt", "fishresp_cnvrt.txt", 
            n.chamber = 4, 
            logger = "FishResp", 
            from = "percent_a.s.", 
            to = "mg_per_l") 


#--- in put information about fish and chambers ---#  
#double check your entered information is correct
info <- input.info(DO.unit = "mg/L", 
                   ID = Fish.ID, 
                   Mass = Fish.Mass, 
                   Volume = Chamber.volume)

#--- load files containing background respiration ---# 
# remember that you will first have to convert the file type to make FishResp happy
pyroscience.pre.path = "C:/Users/jc527762/OneDrive - James Cook University/PhD dissertation/Data/Resp/Dell/Experiment_ 01 August 2022 09 19AM/Oxygen data raw/Firesting.txt"
aquaresp.pre.path = "C:/Users/jc527762/OneDrive - James Cook University/PhD dissertation/Data/Resp/Dell/Experiment_ 01 August 2022 09 19AM/Summary data resp 4.txt"

pyroscience.aquaresp(pyroscience.file = pyroscience.pre.path, 
                     aquaresp.file = aquaresp.pre.path, 
                     fishresp.file = "Background_fishresp.txt", 
                     date.format = "DMY", 
                     n.chamber = 4, 
                     wait.phase = 5, 
                     measure.phase = 214) 

convert.respirometry("Background_fishresp.txt", "Background_fishresp_cnvrt.txt", 
                     n.chamber = 4, 
                     logger = "FishResp", 
                     from = "percent_a.s.", 
                     to = "mg_per_l") 

pre <- import.test("Background_fishresp_cnvrt.txt", info.data =info, 
                   logger="FishResp",n.chamber = 4)
#--- measureing standard metabolic rate ---# 
SMR.path = "C:/Users/jc527762/OneDrive - James Cook University/PhD dissertation/Data/Resp/fishresp_cnvrt.txt"

# you will need to know when measurments started and ended in the next chunk 
# to automate this load in Cycle1 and as well as the last Cycle from each 
# folder/date 
cycle.first <- read.csv("C:/Users/jc527762/OneDrive - James Cook University/PhD dissertation/Data/Resp/Dell/Experiment_ 01 August 2022 11 37AM/All slopes/Cycle_1.txt", sep=";") 
cycle.last <- read.csv("C:/Users/jc527762/OneDrive - James Cook University/PhD dissertation/Data/Resp/Dell/Experiment_ 01 August 2022 11 37AM/All slopes/Cycle_33.txt", sep=";") 
start.time <- cycle.first[1,1] 
stop.time <- tail(cycle.last, n=1)[1]
 

SMR.raw <- import.meas(SMR.path, info.data = info, 
                       logger = "FishResp", 
                       n.chamber = 4, 
                       start.measure = start.time, 
                       stop.measure = stop.time, 
                       plot.oxygen = TRUE) 
#--- cleaning data ---# 
SMR.clean <- correct.meas(info.data = info, pre.data = pre, 
                          meas.data = SMR.raw, method = "pre.test")

#--- visualize data before and after cleaning ---# 
QC.meas(SMR.clean, "Total.O2.phases")
QC.meas(SMR.clean, "Corrected.O2.phases") 
QC.meas(SMR.clean, "Total.O2.chambers")
QC.meas(SMR.clean, "Corrected.O2.chambers")

#--- Extraction and visualization of results ---#  
# Use this code to extract the lowest 10 slopes
SMR.slope <- extract.slope(SMR.clean, 
                           method="min",
                           n.slope=10,
                           r2=0.98, 
                           length = 60)

# use this code to visualize the residuals of the lowest 10 slopes
QC.slope(SMR.slope, SMR.clean, 
         chamber = "CH1",
         residuals = TRUE)

# if everything looks okay then use the code below to get the mean of the lowest ten slopes
SMR.slope.10 <- extract.slope(SMR.clean, 
                              method="calcSMR.low10",
                              r2=0.98)  

#--- results ---#
#first look at df without average values to look for outliers
SMR.1 <- calculate.MR(SMR.slope) %>% 
  mutate(`MgO2/hr` = MR.mass * Mass)

SMR.2 <- calculate.MR(SMR.slope.10) %>% 
  mutate(`MgO2/hr` = MR.mass * Mass)

#--- export results ---# 
write.csv(SMR.2, "./results_dell_01_08_2022_AM.csv", row.names = FALSE)
