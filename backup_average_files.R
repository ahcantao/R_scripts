#change the base_path_from and base_path_to
#this script automates the copy of files going throught many folders 
#and copying only the files on the "average" folder.
#----------------------------------------------------------------
base_path_from <- "C:/temp/dataset_test"
base_path_to <- paste0(base_path_from,"/dataset_averages")
#create a list of folders named "*_noisy" in the script directory... ie: "*_noisy_" is not in the list
dataset_names <- list.files(path = base_path_from, pattern = "_noisy$")
cat(length(dataset_names), 'datasets found\n')
#dataset names can also be given manually (bellow)
#dataset_names <- list("blobs_c3_d2")
#kfolds and noisy_features are the folders I need to go throught
kfolds <- list("001","002","003","004","005","006","007","008","009","010")
noisy_features <- list("001", "002", "004", "008", "016", "032", "064","128","256","512","1024")
for (dataset_name in dataset_names){
  for(kfold in kfolds){
    for (noise in noisy_features){
      folder_path_to <- paste0(base_path_to,"/",dataset_name,"/",kfold,"/",noise,"/average/")
      folder_path_from <- paste0(base_path_from,"/",dataset_name,"/",kfold,"/",noise,"/average/")
      if(!dir.exists(file.path(folder_path_to))){
        dir.create(file.path(folder_path_to), recursive=TRUE)
        #print(paste0("directory created: ", folder_path_to))
        #get all file names from the source folder
        files_average = list.files(path=folder_path_from)
        for(file_average in files_average){
          file.copy(paste0(folder_path_from,file_average), folder_path_to)
        }
      }
    }
  }
  cat('\nbackup done: ',dataset_name)
}