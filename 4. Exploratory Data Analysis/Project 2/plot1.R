if(!file.exists("summarySCC_PM25.rds") && !file.exists("Source_Classification_Code.rds")){
        if(!file.exists("exdata_data_NEI_data.zip")){
                zipurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
                download.file(url=zipurl, destfile ="exdata_data_NEI_data.zip")
        }
        unzip("exdata_data_NEI_data.zip")
}

if(!exists("NEI") && !exists("SCC")){
        NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("Source_Classification_Code.rds")
}


totals <- aggregate(Emissions ~ year, NEI, sum)

png("plot1.png", width = 500, height = 500)
barplot((totals$Emissions/10^6), names.arg = totals$year,
        xlab = "Year", ylab = "PM2.5 emissions in millions of tons",
        main = "Total PM2.5 Emissions in the US")
dev.off()