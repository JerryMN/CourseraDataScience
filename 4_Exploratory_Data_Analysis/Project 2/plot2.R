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

baltimore <- NEI[NEI$fips == "24510",]
totals_baltimore <- aggregate(Emissions ~ year, baltimore, sum)

png("plot2.png", width = 500, height = 500)
barplot(totals_baltimore$Emissions, names.arg = totals_baltimore$year,
        xlab = "Year", ylab = "PM2.5 emissions (tons)",
        main = "Total PM2.5 Emissions in Baltimore, MD")
dev.off()