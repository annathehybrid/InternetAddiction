##########
# How to make a grouped bar chart in R with the lattice package
#
# We are comparing the reasons for using the internet
# among normal people and addicts
# Step 1
# Put your data into Excel into the right format

# Step 2
# import the package "lattice"
library(lattice)

# Step 3
# import your data in, in the right format (usually comma separated)
# the table will be tab-separated in Excel, so we have to convert to comma-separated for R
# Convert the windows endline (/r/n) to newline (/n)
# convert all the "\t" to ", "
# and put it into a table variable
addiction_table <- read.table(text = "Problem, Reason_For_Using_The_Internet, Percent_of_users
Normal internet user, Anonymity, 1.8
Normal internet user, Simplified communication, 3.4
Normal internet user, Emotional support, 2.25
Normal internet user, Social compensation, 1.55
Normal internet user, Escapism, 1.4
Internet addict, Anonymity, 2.7
Internet addict, Simplified communication, 3.9
Internet addict, Emotional support, 3
Internet addict, Social compensation, 2.3
Internet addict, Escapism, 3.1
(Addicts - Normal) How much more internet addicts use the internet for this reason, Anonymity, 0.9
(Addicts - Normal) How much more internet addicts use the internet for this reason, Simplified communication, 0.5
(Addicts - Normal) How much more internet addicts use the internet for this reason, Emotional support, 0.75
(Addicts - Normal) How much more internet addicts use the internet for this reason, Social compensation, 0.75
(Addicts - Normal) How much more internet addicts use the internet for this reason, Escapism, 1.7
",
                              
                              # we want to tell the read table that we have headers
                              header = TRUE,
                              # we want to set the separater value
                              sep = ","
)

addiction_table

addiction_table$Reason_For_Using_The_Internet <- wrap.labels(addiction_table$Reason_For_Using_The_Internet, 10)
addiction_table$Problem <- wrap.labels(addiction_table$Problem, 20)


# Let's make the bar chart
# We are going to plot the number of dances choreographed (y axis)
# by the gender of the choreographers (x axis)
# grouped by problem of users (Problem)

# in my experience, lattice doesn't like it when you declare color in side the barplot function
# so we have to declare it outside

colors = c("mediumorchid", "forestgreen", "goldenrod1", "mediumblue", "deeppink4")

# sort the User column by descending order
# in the bar charts, we want "walthrough" on the left, and then "participant 1 and 2"
# but that is not alphabetical
# so we have to reverse sort it
addiction_table$Problem <- factor(addiction_table$Problem,
                                  levels = unique( as.character(addiction_table$Problem) ) )
addiction_table


# open up a blank image that we want to save our chart in
png(filename = "addiction_chart_new.png",
    width = 10,
    height = 10,
    units = "in",
    res = 600)




barchart(
  names.arg = wrap.labels,
  
  
  # Input the data in
  data = addiction_table,
  
  # y axis by x axis
  Percent_of_users ~ Problem,
  
  # set the groups
  # This is what the x axis is grouped by
  groups = Reason_For_Using_The_Internet,
  
  # Turn the graph 90 degrees
  horizontal = FALSE,
  
  # Add a title to our graph
  # I want the font of the title to be bigger
  main = list(
    
    label = "Why Internet addicts use the Internet\nvs. normal people",
    cex = 2.2
  ),
  
  
  # label the x axis
  # make the font bigger
  xlab = list (
    label = "Types of people",
    cex = 1.5
  ),
  
  # label the y axis
  # make the font bigger
  ylab = list(
    label = "Percent of users who use the\ninternet for this reason",
    cex = 1.5
  ),
  
  # Let's change the scale tick marks font size
  # x and y axis marks
  # we want to make their font a little bigger
  scales = list (
    x = list (
      # if you want to rotate your values
      # rot = 90
      cex = 1.2
    ),
    
    y = list (
      # if you want to rotate your values
      # rot = 90
      cex = 1.2
    )
  ),
  
  # add a legend
  auto.key = list (
    space = list (space = "top"),
    columns = 3,
    title = "Reasons that they use the internet",
    cex.title = 1.1
  ),
  
  # set the origin so that values start at 0
  origin = 0,
  
  # set colors
  par.settings = list(superpose.polygon = list(col = colors)),
  
  pretty = FALSE
  
)


# save our image
dev.off()




