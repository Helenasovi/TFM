library(sf)           
library(rnaturalearth) 
library(readODS)      
library(dplyr)        
library(tidyr)        
library(ggplot2)      

file_path <- "Path/"
copepod_data <- read_ods(file_path)

missing_coords <- sum(is.na(copepod_data$lat) | is.na(copepod_data$lon))
cat("Number of rows with missing coordinates:", missing_coords, "\n")

copepod_data_clean <- copepod_data %>%
  filter(!is.na(lat) & !is.na(lon))

cat("Original number of rows:", nrow(copepod_data), "\n")
cat("Number of rows after removing missing coordinates:", nrow(copepod_data_clean), "\n")

# (spatial points)
copepod_points <- st_as_sf(copepod_data_clean, 
                           coords = c("lon", "lat"),
                           crs = 4326)

# land polygons from Natural Earth
land <- ne_countries(scale = "medium", returnclass = "sf")

# Only the points that intersect with land polygons
points_on_land <- st_intersection(copepod_points, st_union(land))

output_path <- "Path/copepods_on_land.ods"
write_ods(as.data.frame(st_drop_geometry(points_on_land)), output_path)

ggplot() +
  geom_sf(data = land, fill = "lightgrey", color = "darkgrey") +
  geom_sf(data = copepod_points, color = "red", size = 0.5, alpha = 0.5) +
  geom_sf(data = points_on_land, color = "blue", size = 0.5) +
  labs(title = "Copepod Data Points",
       subtitle = "All points (red) vs Points on land (blue)") +
  theme_minimal()

ggsave("Path/copepod_map.png", 
       width = 10, height = 6, dpi = 300)

cat("Total number of valid points:", nrow(copepod_points), "\n")
cat("Number of points on land:", nrow(points_on_land), "\n")
cat("Percentage of points on land:", round(nrow(points_on_land)/nrow(copepod_points)*100, 1), "%\n")