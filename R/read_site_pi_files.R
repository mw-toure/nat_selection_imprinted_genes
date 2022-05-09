read_site_pi_files <- function(raw_data_path) {
  # Get list of full file paths to raw data sheets
  file_list <- list.files(raw_data_path, full.names = TRUE)
  
  # get indices of matched files
  pi_file_idx <- grep("sites\\.pi", file_list)
  
  pi_files <- file_list[pi_file_idx]
  
  # Initialize empty data frame
  dataset <- data.frame()
  
  # Loop which reads each data file, 
  # formats each data file, and
  # attaches it to the bottom of the master data sheet `dataset`
  for (i in 1:length(pi_files)) {
    temp_data <- read.table(pi_files[i],
                            sep = "\t",
                            header = TRUE)
    dataset <- rbind(dataset, temp_data)
  }
  
  # Explicit call to return the full data sheet necessary due to the loop
  return(dataset)
}

