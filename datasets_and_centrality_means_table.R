file_path <- "E:/datasets_scores_avg/merge/output_scores_avg.csv"
output_scores_avg <- read.table(file_path, header=TRUE, sep=",")

dim(output_scores_avg)
head(output_scores_avg)


data_list <- list()
datasets <- unique(output_scores_avg$dataset) #remover [1:2]
centralities <- c('eigen','katz','str')
orientations <- c('g','in','out')

for(dataset_name in datasets){
  data_row <- c(dataset_name)
  one_dataset <- subset(output_scores_avg, dataset == dataset_name & noise == 40)

  for(cent in centralities){
    
    for(ori in orientations){
      data_subset = subset(one_dataset, centrality == cent & orientation == ori)
      mean_value <- mean(data_subset$ranking_score_1_avg)
      data_row <- c(data_row, mean_value)
      
    }
  }
  data_subset = subset(one_dataset, centrality == 'rf')
  mean_value <- mean(data_subset$ranking_score_1_avg)
  data_row <- c(data_row, mean_value)
  
  data_list[[length(data_list)+1]] <- data_row
  # print(data_row)
}
  
df= as.data.frame(t(as.data.frame(data_list)))
rownames(df)<-NULL
col_names = c('dataset','eig_g','eig_in','eig_out','katz_g','katz_in','katz_out','str_g','str_in','str_out', 'rf')

colnames(df) <- col_names
# df

write.csv(df,"E:/datasets_scores_avg/merge/datasets_means_40noise_for_table.csv", row.names = FALSE)
