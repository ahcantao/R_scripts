#reads my dataset file and make subsets based on the noise (5,10,20,40) and dataset name 
#   and do the calculations for each dataset name then save a
#   new dataset file containing the 97 dataset names on the rows and each centrality 
#   mean and standard deviation on the columns

file_path <- "E:/datasets_scores_avg/merge/output_scores_avg.csv"
output_scores_avg <- read.table(file_path, header=TRUE, sep=",")

dim(output_scores_avg)
head(output_scores_avg)

datasets <- unique(output_scores_avg$dataset) #remover [1:2]
centralities <- c('eigen','katz','str')
orientations <- c('g','in','out')
noi <- 40  #'all'

data_list <- list()
for(dataset_name in datasets){
  data_row <- c(dataset_name)
  one_dataset <- subset(output_scores_avg, dataset == dataset_name & noise == noi) # & noise == noi

  for(cent in centralities){
    
    for(ori in orientations){
      data_subset = subset(one_dataset, centrality == cent & orientation == ori)
      mean_value <- mean(data_subset$ranking_score_1_avg)
      sd_value   <- sd(data_subset$ranking_score_1_avg)
      data_row   <- c(data_row, mean_value, sd_value)
      # data_row <- c(data_row, mean_value)
      
    }
  }
  data_subset = subset(one_dataset, centrality == 'rf')
  mean_value <- mean(data_subset$ranking_score_1_avg)
  sd_value   <- sd(data_subset$ranking_score_1_avg)
  data_row   <- c(data_row, mean_value, sd_value)
  # data_row   <- c(data_row, mean_value)
  
  data_list[[length(data_list)+1]] <- data_row
  # print(data_row)
}
  
df= as.data.frame(t(as.data.frame(data_list)))
rownames(df)<-NULL
# col_names = c('dataset','eig_g','eig_in','eig_out','katz_g','katz_in','katz_out','str_g','str_in','str_out', 'rf')
col_names = c('dataset','eig_g_mean','eig_g_sd','eig_in_mean','eig_in_sd','eig_out_mean','eig_out_sd','katz_g_mean','katz_g_sd','katz_in_mean','katz_in_sd','katz_out_mean','katz_out_sd','str_g_mean','str_g_sd','str_in_mean','str_in_sd','str_out_mean','str_out_sd', 'rf_mean','rf_sd')

colnames(df) <- col_names
# df
new_file_path <- paste("E:/datasets_scores_avg/merge/datasets_means_sd_",noi,"noise_table.csv", sep="")
write.csv(df,new_file_path, row.names = FALSE)
