library(shiny)
all2017Data <- read.csv("RevVolume.csv", na.strings=c("-"))
cn <- c("isRegion", "area", "revenue", "mcf", "bbls", "date")
colnames(all2017Data) = cn
all2017Data$area <- gsub('\\s+', '', all2017Data$area)
l = unique(all2017Data$area)

shinyUI(pageWithSidebar(
  headerPanel("Revenue vs Volume Plot by Area"),
  sidebarPanel(
    p('Pick an area to see how volume relates to revenue.'),
    selectInput('area','Select an Area', l),
    p('Use the slider to change the predicted revenue as determined by volume.'),
    uiOutput("slider"),
    tags$small('Slider default is the average.'),
    uiOutput("table")
  ),
  mainPanel(
    plotOutput('areaPlot')
    
  )
))
