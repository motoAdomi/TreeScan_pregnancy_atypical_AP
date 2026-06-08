## Example code to run permutationTBSS with node-specific washout.
## Author: Motohiko Adomi
## Last update: June 7, 2026

## this R script contains function that can be directly implemented with parallelization. 
## For 9999 iterations, I used 20 clusters each with 495 iterations + one cluster with 99 iterations -> 9999 iterations

myfunction <- function(index) {
  #start.time1 <- Sys.time()
  
  library(TBSS)
  library(data.table)
  library(dplyr)
  library(parallel)
  
  tree_original <- fread("/directory/tree_file.csv")
  cohort1 <- fread("/directory/cohort.csv")
  diagnosis_table2 <- fread("/directory/diagnosis_file.csv")
  
  dat <- fread("/directory/node_duplicate_identifier.csv")
  dat1 <- dat[dat$to_be_excluded==1,]
  dat2 <- dat1[, c("variable")]
  
  char_vec <- as.character( dat2$variable )
  rm(dat, dat2, dat1)
  
  scan_permutation_B1 = permutationTBSS(cohort = cohort1,
                                        diagnosis_table = diagnosis_table2,
                                        tree = tree_original,
                                        min_events = 2,
                                        B = 495,
                                        parallel = FALSE,
                                        #ncpus = 8,
                                        nodeToRemove = char_vec,
                                        direction = "positive",
                                        offset = "unscaled",
                                        seed = index)
  

  ## with 495 iteration each, 
  #Computation took approximately 14.884 seconds 
  #Applying node-specific washout, this can take some time...Done. 
  #Computation took approximately 14869.183 seconds 
  
  #Starting permutation algorithm...Done. 
  #Computation took approximately 143441.584 seconds

  #end.time1 <- Sys.time()
  #time.taken1 <- round(end.time1 - start.time1,2)
  #time.taken1
  
  #summary(mod_icd_cohort1) |> filter(pvalue < 0.05)
  write.csv(summary( scan_permutation_B1), 
            file = paste0('/directory/overlap_w_no_wo_495_ite_', index, '.csv'))
  
  
}