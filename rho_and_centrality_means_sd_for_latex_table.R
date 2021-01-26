file <- 'E:/datasets_scores_avg/merge/output_scores_avg.csv'
dataset_full <- read.table(file, header=TRUE, sep=",")
scoring_measure <- 'binary_rs1'


orientation   <- unique(dataset_full$orientation)   #list("g", "in", "out", "rf")
orientation   <- setdiff(orientation, "rf") # getting all centralities that are not "rf"
# centralities <- unique(dataset_full$centrality) #list("katz", "eigen", "str", "rf")
centralities <- c("katz", "eigen", "str")
noises       <- unique(dataset_full$noise) #list(5,10,20,40)
rs           <- unique(dataset_full$R) #1,2,4,8,16..1024

# noi = 5
for (noi in noises){
  data_list <- list()
  for (r in rs){
    data_row <- c(as.character(r))
    dataset_subset <- subset(dataset_full, R == r & noise == noi)
    for(cent in centralities){ #C
      for(ori in orientation){ #D
        data_subset_subset <- subset(dataset_subset, centrality == cent & orientation == ori)
        mean_value <- mean(data_subset_subset$ranking_score_1_avg)
        sd_value   <- sd(data_subset_subset$ranking_score_1_avg)
        data_row   <- c(data_row, mean_value, sd_value)
      }
    }
    data_subset_subset <- subset(dataset_subset, centrality == 'rf')
    mean_value <- mean(data_subset_subset$ranking_score_1_avg)
    sd_value   <- sd(data_subset_subset$ranking_score_1_avg)
    data_row   <- c(data_row, mean_value, sd_value)
  
    data_list[[length(data_list)+1]] <- data_row
  }
  
  df= as.data.frame(t(as.data.frame(data_list)))
  rownames(df)<-NULL
  
  col_names = c('R','eig_g_mean','eig_g_sd','eig_in_mean','eig_in_sd','eig_out_mean','eig_out_sd','katz_g_mean','katz_g_sd','katz_in_mean','katz_in_sd','katz_out_mean','katz_out_sd','str_g_mean','str_g_sd','str_in_mean','str_in_sd','str_out_mean','str_out_sd', 'rf_mean','rf_sd')
  colnames(df) <- col_names
  
  new_file_path <- paste("E:/datasets_scores_avg/merge/rho_centrality_means_sd_",noi,"noise_table.csv", sep="")
  write.csv(df,new_file_path, row.names = FALSE)
}
