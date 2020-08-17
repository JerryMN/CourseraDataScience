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

combustion <- grepl("comb", NEISCC$SCC.Level.One, ignore.case = T)
coal <- grepl("coal", NEISCC$SCC.Level.Four, ignore.case = T)
coalcomb <- (combustion & coal)
coalsub <- NEISCC[coalcomb, ]
totals <- aggregate(Emissions ~ year, coalsub, sum)

png("plot4.png", width = 500, height = 500)

library(ggplot2)
ggplot(totals, aes(factor(year), Emissions)) + 
        geom_bar(stat="identity") +
        labs(x = "year", y = "PM2.5 emissions (tons)", title = "PM2.5 emissions from coal sources from 1999 to 2008")
dev.off()