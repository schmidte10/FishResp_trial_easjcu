# FishResp_trial_easjcu 

This directory contains R script for calculating SMR of fish using the R package FishResp. 

Details for the experiment performed are below: 

Fish were swam in a separate swim tunnel for ten minutes (five minutes ramp up speed, five minutes at max. aerobic speed). Max. aerobic speed was determined as the point where fish could just hold their position in the swim tunnel via pectoral swimming, but also had the option to engage in short bursts. If fish started to engage in long bursts, the speed of the swim tunnel was brought down. After spending ten minutes in the swim tunnel, fish were immediately transfered to a respiratory chamber. 

Once fish were transferred to a respiratory chamber (pyroscience DO probe/AquaResp software) oxygen content in water (measured as percent (%) air saturation) was measured for 240 seconds (4 minutes), after a five second wait period. The flushing period was set at 180 seconds (3 seconds) 

tl;dr 5s wait, 240s measure, 180s flush 

Trials were stopped and started between fish. For example once a fish had reach its max aerobic swim speed in the swim tunnel (i.e. at the end of the ramp up period), the researcher would walk over to the computer hooked up to the respiratory chambers and stop AquaResp (on a flush period, not during a measurement cycle). Once the fish in the swim tunnel was put into one of the respirometry chambers after its swim period, the researcher would start AquaResp again. AquaResp was run for ~3.5 hours after the last fish was placed in a respiratory chamber. From what I believe throughout the duration of the experiment in ./Oxygen data raw/Firesting.txt file recoreded by the pyroscience DO probes (i.e. raw data) never stopped.  

Background respiration was recoreded for before the first fish entered a respiratory. Background respiration was recorded at the beginning of the experiment, but not the end. 

Within each file, saved by date and time, AquaResp creates a separate .txt file containing the summary information of each chamber. Additional files created are the .txt for each cycle (found in ./All slopes/), as well as the raw oxygen data. 

