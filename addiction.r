##########
# How to make a grouped bar chart in R with the lattice package
#
# We are comparing the percentage of normal internet users
# versus the internet addicts
# separated by main reasons for using the internet
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
addiction_table <- read.table(text = "Reason_For_Using_The_Internet, Problem, Percent_of_users
Anonymity, Normal internet use, 1.8
Anonymity, Internet addiction tendency, 2.7
Simplified communication, Normal internet use, 3.4
Simplified communication, Internet addiction tendency, 3.9
Emotional support, Normal internet use, 2.25
Emotional support, Internet addiction tendency, 3
Social compensation, Normal internet use, 1.55
Social compensation, Internet addiction tendency, 2.3
Escapism, Normal internet use, 1.4
Escapism, Internet addiction tendency, 3.1
",

  # we want to tell the read table that we have headers
  header = TRUE,
  # we want to set the separater value
  sep = ","
)

addiction_table


# Let's make the bar chart
# We are going to plot the number of dances choreographed (y axis)
# by the gender of the choreographers (x axis)
# grouped by problem of users (Problem)

# in my experience, lattice doesn't like it when you declare color in side the barplot function
# so we have to declare it outside

colors = c("goldenrod1", "forestgreen")


# sort the User column by descending order
# in the bar charts, we want "walthrough" on the left, and then "participant 1 and 2"
# but that is not alphabetical
# so we have to reverse sort it
addiction_table$Problem <- factor(addiction_table$Problem,
                                               levels = unique( as.character(addiction_table$Problem) ) )
addiction_table

# Core wrapping function
wrap.it <- function(x, len)
{ 
  sapply(x, function(y) paste(strwrap(y, len), 
                              collapse = "\n"), 
         USE.NAMES = FALSE)
}


# Call this function with a list or vector
wrap.labels <- function(x, len)
{
  if (is.list(x))
  {
    lapply(x, wrap.it, len)
  } else {
    wrap.it(x, len)
  }
}

addiction_table$Reason_For_Using_The_Internet <- wrap.labels(addiction_table$Reason_For_Using_The_Internet, 10)

# open up a blank image that we want to save our chart in
png(filename = "addiction_chart.png",
    width = 10,
    height = 10,
    units = "in",
    res = 600)


barchart(
  names.arg = wrap.labels,
  
  
  # Input the data in
  data = addiction_table,
  
  # y axis by x axis
  Percent_of_users ~ Reason_For_Using_The_Internet,
  
  # set the groups
  # This is what the x axis is grouped by
  groups = Problem,
  
  # Turn the graph 90 degrees
  horizontal = FALSE,
  
  # Add a title to our graph
  # I want the font of the title to be bigger
  main = list(
    
    label = "Motives for using the Internet and Internet addiction",
    cex = 2.2
  ),
  
  
  # label the x axis
  # make the font bigger
  xlab = list (
    label = "Motives for using the Internet",
    cex = 1.5
  ),
  
  # label the y axis
  # make the font bigger
  ylab = list(
    label = "Percent of users",
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
    columns = 2,
    title = "Psychological problem",
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
