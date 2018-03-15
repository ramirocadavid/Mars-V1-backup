# Login to Salesforce
library(RForcecom)
password <- "gfutzmars2018n0ljYwQQqYVWfu9RIfPqWIn8"
session <- rforcecom.login("admin@utzmars.org", password)

# Retrieve meta data
objects <- rforcecom.getObjectList(session)
objectsExclude <- c("ActivityHistory", "AggregateResult")
objects <- objects[!(objects$name %in% objectsExclude), ]
metadata <- list()
for(i in seq_along(objects)) {
      metadata[[i]] <- rforcecom.getObjectDescription(session, objects$name[i])
      names(metadata)[i] <- as.character(objects$name[i])
}

# Retrieve data
data <- list()
for(i in seq_along(metadata)) {
      data[[i]] <- rforcecom.retrieve(session, names(metadata)[i], metadata[[i]]$name)
      names(data)[i] <- as.character(names(metadata)[i])
}

# Save data in RDS
saveRDS(objects, "objects.RDS")
saveRDS(metadata, "metadata.RDS")
saveRDS(data, "data.RDS")

# Save data in Excel file
library(xlsx)
currDate <- Sys.Date()
# Objects
fileNameObjects <- paste("objects_backup_", currDate, ".xlsx", sep = "")
write.xlsx(objects, paste("objects", file.name, sep = ""), sheetName = "objects")
# Meta data

# Data
for(i in seq_along(metadata)) {
      write.xlsx(data[[i]], paste("data", file.name, ), 
                 sheetName = as.character(objects$name[i]),
                 append = TRUE)
}
