library(shiny)
all2017Data <- read.csv("RevVolume.csv", na.strings=c("-"))
cn <- c("isRegion", "area", "revenue", "mcf", "bbls", "date")
colnames(all2017Data) = cn
all2017Data$area <- gsub('\\s+', '', all2017Data$area)
l = unique(all2017Data$area)

shinyUI(pageWithSidebar(
  headerPanel("Plot by Area"),
  sidebarPanel(
    sliderInput('slideValue', 'Predict Revnue',value = 300000, min = 0, max = 1000000, step = 50000,),
    selectInput('area','Select an Area', l)
  ),
  mainPanel(
    plotOutput('areaPlot'),
    h3('predict value'),
    verbatimTextOutput("summary")
  )
))
