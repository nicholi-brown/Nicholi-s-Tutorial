#Install Novel Packages 
install.packages("ggmap")
install.packages("ggplot2")
install.packages("readxl")
install.packages("viridis")

#Load Packages 
library(tidyverse)
library(maps)
library(ggmap)
library(ggplot2) 
library(tidyr)
library(readxl)
library(viridisLite)

#Register Stadia Map with custom API key (see:https://client.stadiamaps.com/dashboard/#/property/27810/ )
register_stadiamaps( "#INSERTYOURAPIHERE", write = FALSE)

#Load Stadia Map into R
mockseal_map <- get_stadiamap(
  bbox = c(left = -78.0616, bottom = 24.1912, right = -77.9193, top = 24.269),
  maptype = "stamen_terrain",
  zoom = 15
)

#Load Terrain Visualization of Research Area 
ggmap(mockseal_map)

#Import Mock Seal Observation Dataset
Mock_Seal_Data <- read_excel("Mock_Seal_Data.xlsx")
#View Data to Verify Accuracy 
View(Mock_Seal_Data)

#Create new Data set with relevant columns 
Sealname_LocationMock <- Mock_Seal_Data [c("Seal","Date","GPS Coordinates")]
#View Data to Verify Accuracy 
View(Sealname_LocationMock)

#Separate Lattitude and Longitude into two new columns from the 'GPS Coordinates Column' 
Sealname_Location_separatedMock <- separate(Sealname_LocationMock, col = `GPS Coordinates`, into = c("Latitude", "Longitude"), sep = ",")
View(Sealname_Location_separatedMock)

# Convert the Data type in Latitude and Longitude Columns from character to numeric data
Sealname_Location_separatedMock$Longitude <- as.numeric(Sealname_Location_separatedMock$Longitude)
Sealname_Location_separatedMock$Latitude <- as.numeric(Sealname_Location_separatedMock$Latitude)

#Layer Latitude and Longitude data atop Terrain visualization 
ggmap(mockseal_map) +
  geom_point(data =Sealname_Location_separatedMock,
             aes(x =Longitude, y =Latitude, color= Seal, shape= Seal),
             size = 3) +
  labs( title= "Leopard Seal Sightings as Observed", x = "Longitude", y= "Lattitude" ) +
  #scale_color_viridis_d() +
  theme(
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold"),
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5)
  )
theme_minimal()

