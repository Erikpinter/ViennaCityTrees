# PGA 04 
# Erik Pinter, 2017

library(leaflet)
library(dplyr)
library(data.table)


# load the dataset
# Viennatreedata <- read.csv('http://data.wien.gv.at/daten/geo?service=WFS&request=GetFeature&version=1.1.0&typeName=ogdwien:BAUMKATOGD&srsName=EPSG:4326&outputFormat=csv')
# write.csv(Viennatreedata, './data/Viennatreedata.csv')
Viennatreedata <- fread('./data/Viennatreedata.csv')

# Create proper Lat / Lon coordinates from the SHAPES-column
TEMP_lat_lon <- gsub(".*\\(", "", Viennatreedata$SHAPE)
TEMP_lat_lon <- gsub("\\)", "", TEMP_lat_lon)
Viennatreedata$LON <- as.numeric(gsub(" .*", "", TEMP_lat_lon))
Viennatreedata$LAT <- as.numeric(gsub(".* ", "", TEMP_lat_lon))

# 
Viennatreedata[Viennatreedata == "nicht bekannt"] <- NA

# calculate the mean height of each heightclass
Viennatreedata$BAUMHOEHE[Viennatreedata$BAUMHOEHE == 0]  <-  NA
Viennatreedata$BAUMHOEHEMEAN <- Viennatreedata$BAUMHOEHE * 5 - 2 

# limit years from year 1800 to year 2016
Viennatreedata$PFLANZJAHR[Viennatreedata$PFLANZJAHR <= 1800 | Viennatreedata$PFLANZJAHR >= 2016] <- NA

# calculate the mean height of each heightclass
Viennatreedata$KRONENDURCHMESSER[Viennatreedata$KRONENDURCHMESSER == 0]  <-  NA
Viennatreedata$KRONENDURCHMESSERMEAN <- Viennatreedata$KRONENDURCHMESSER * 3 - 1 

# add information for the labels on the map
Viennatreedata$Info <- paste(sep = " ", "Height:", Viennatreedata$BAUMHOEHE_TXT, "| Crown:", Viennatreedata$KRONENDURCHMESSER_TXT, "| Year:", Viennatreedata$PFLANZJAHR, "| Species:", Viennatreedata$GATTUNG_ART)


# create a tidy dataset
cleantable <- Viennatreedata %>%
        select(
                Tree_ID = BAUM_ID,
                District = BEZIRK,
                Street = OBJEKT_STRASSE,
                Species = GATTUNG_ART,
                year_planted = PFLANZJAHR,
                height = BAUMHOEHEMEAN,
                crown_diameter = KRONENDURCHMESSERMEAN,
                Lat = LAT,
                Long = LON,
                Info = Info
        )
