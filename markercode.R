library(readODS)
library(dplyr)

file_path <- "path/"
copepods_on_land <- read_ods(file_path)

# Values in marker code column
cat("Unique values in markercode column:\n")
print(unique(copepods_on_land$markercode))

# Blank values
na_count <- sum(is.na(copepods_on_land$markercode))
blank_count <- sum(copepods_on_land$markercode == "", na.rm = TRUE)
cat("NA values:", na_count, "\n")
cat("Blank values:", blank_count, "\n")

coi_5p_copepods <- copepods_on_land %>% 
  filter(!is.na(markercode) & tolower(trimws(markercode)) == "coi-5p")

# How many records were found
cat("Total records in original file:", nrow(copepods_on_land), "\n")
cat("Records with markercode 'COI-5P':", nrow(coi_5p_copepods), "\n")

output_path <- "Path/copepods_coi_5p_only.ods"
write_ods(coi_5p_copepods, output_path)
