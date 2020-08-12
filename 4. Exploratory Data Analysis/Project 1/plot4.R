data <- read.table("household_power_consumption.txt", stringsAsFactors = F, header = T, sep = ";")

subsetdata <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]

timedate <- strptime(paste(subsetdata$Date, subsetdata$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
subsetdata <- cbind(subsetdata, timedate)

subsetdata$Global_active_power <- as.numeric(subsetdata$Global_active_power)
subsetdata$Voltage <- as.numeric(powerdata$Voltage)
subsetdata$Sub_metering_1 <- as.numeric(subsetdata$Sub_metering_1)
subsetdata$Sub_metering_2 <- as.numeric(subsetdata$Sub_metering_2)
subsetdata$Sub_metering_3 <- as.numeric(subsetdata$Sub_metering_3)

png("plot4.png", width=480, height=480)
par(mfrow=c(2,2))
with(subsetdata, plot(timedate, Global_active_power, type="l", xlab="", ylab="Global Active Power"))
with(subsetdata, plot(timedate, Voltage, type = "l", xlab="datetime", ylab="Voltage"))
with(subsetdata, plot(timedate, Sub_metering_1, type="l", xlab="", ylab="Energy sub metering"))
lines(subsetdata$timedate, subsetdata$Sub_metering_2,type="l", col= "red")
lines(subsetdata$timedate, subsetdata$Sub_metering_3,type="l", col= "blue")
legend(c("topright"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty= 1, lwd=2, col = c("black", "red", "blue"))
with(subsetdata, plot(timedate, Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power"))
dev.off()