if(!file.exists("summarySCC_PM25.rds") && !file.exists("Source_Classification_Code.rds")){
        if(!file.exists("exdata_data_NEI_data.zip")){
                zipurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
                download.file(url=zipurl, destfile ="exdata_data_NEI_data.zip")
        }
        unzip("exdata_data_NEI_data.zip")
}

if(!exists("NEI") && !exists("SCC") && !exists("NEISCC")){
        NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("Source_Classification_Code.rds")
        NEISCC <- merge(NEI, SCC, by="SCC")
}

vehicles <- grepl("vehicle", NEISCC$SCC.Level.Two, ignore.case = T)
vehiclesub <- NEISCC[vehicles, ]
baltimore <- vehiclesub[vehiclesub$fips == "24510", ]
baltimore$city <- "Baltimore"
losangeles <- vehiclesub[vehiclesub$fips == "06037", ]
losangeles$city <- "Los Angeles"

cities <- rbind(losangeles, baltimore)

png("plot6.png", width = 500, height = 500)

library(ggplot2)
ggplot(cities, aes(factor(year), Emissions, fill = city)) +
        geom_bar(stat="identity") +
        facet_grid(.~city) +
        guides(fill = F) +
        labs(x="Year", y="PM2.5 emissions (tons)", title = "PM2.5 Motor Vehicle Emissions in Baltimore & LA, 1999-2008")
dev.off()