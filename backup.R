# Login to Salesforce
library(RForcecom)
password <- "gfutzmars2018*hn5OC4tzSecOhgHKnUtZL05C"
session <- rforcecom.login("admin@utzmars.org", password)

# Cached data
metadata <- readRDS("metadata.RDS")
data <- readRDS("data.RDS")

# Objects to retrieve
activities.objects <- c("FDP_submission__c", "farmer__c", "farmer_BL__c", "Farm__c", 
                        "Farm_BL__c", "plot__c", "AODiagnostic__c",
                        "Adoption_observations__c", "PL_FDP__c", "FDP_calendar__c",
                        "User_performance__c", "Performance_detail__c")
setup.objects <- c("Contact", "User", "village__c", "district__c", "country__c", 
                   "Recommendation_and_volumes__c", "recommendation__c",
                   "recommendationActivities__c", "inputs__c", "activity__c")
all.objects <- c(activities.objects, setup.objects)

# Retrieve meta data
metadata <- list()
for(i in seq_along(all.objects)) {
      metadata[[i]] <- rforcecom.getObjectDescription(session, all.objects[i])
      names(metadata)[i] <- as.character(all.objects[i])
}

# Retrieve data
data <- list()
for(i in seq_along(all.objects)) {
      data[[i]] <- rforcecom.retrieve(session, all.objects[i], metadata[[i]]$name)
      names(data)[i] <- as.character(names(metadata)[i])
}

# Export metadata
# Create folder
currDate <- Sys.Date()
md.dir.name <- paste("MetaData_export_", currDate, sep = "")
dir.create(md.dir.name)
# Export metadata
for(i in seq_along(all.objects)) {
      file.name.temp <- paste(md.dir.name, "/", i, "_", all.objects[i], ".csv", sep = "")
      write.csv(metadata[[i]], file.name.temp)
      rm(file.name.temp)
}
saveRDS(metadata, paste(md.dir.name, "/metadata.RDS", sep = ""))

# Data
data.dir.name <- paste("Data_export_", currDate, sep = "")
dir.create(data.dir.name)
for(i in seq_along(all.objects)) {
      file.name.temp <- paste(data.dir.name, "/", i, "_", all.objects[i], ".csv", sep = "")
      write.csv(data[[i]], file.name.temp, row.names = FALSE, quote = TRUE)
}
saveRDS(data, paste(data.dir.name, "/data.RDS", sep = ""))
