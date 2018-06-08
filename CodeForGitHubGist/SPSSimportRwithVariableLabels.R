library(foreign)

mydata <- read.spss("mydata.sav", use.value.labels = TRUE, to.data.frame = TRUE)

VariableLabels <- as.data.frame(attr(mydata, "variable.labels"))
VariableLabels$original <- rownames(VariableLabels)

VariableLabels$label[VariableLabels$label ==""] <- NA 
VariableLabels$colname <- VariableLabels$original

VariableLabels$colname[!is.na(VariableLabels$label)] <- as.vector(VariableLabels$label[!is.na(VariableLabels$label)])

names(mydata) <- VariableLabels$colname