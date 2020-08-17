data <- read.table("household_power_consumption.txt", stringsAsFactors = F, header = T, sep = ";")

subsetdata <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]

timedate <- strptime(paste(subsetdata$Date, subsetdata$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
subsetdata$Global_active_power <- as.numeric(subsetdata$Global_active_power)

png("plot2.png", width=480, height=480)
with(subsetdata, plot(timedate, Global_active_power, type="l", xlab="Day", ylab="Global Active Power (kilowatts)"))
dev.off()