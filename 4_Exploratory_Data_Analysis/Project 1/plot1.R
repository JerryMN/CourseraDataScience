data <- read.table("household_power_consumption.txt", stringsAsFactors = F, header = T, sep = ";")

subsetdata <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]

subsetdata$Global_active_power <- as.numeric(subsetdata$Global_active_power)

png("plot1.png", width=480, height=480)
hist(subsetdata$Global_active_power, col="red", border="black", main ="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency")
dev.off()