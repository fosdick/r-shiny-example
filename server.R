library(shiny)
library(UsingR)
data(galton)
library(ggplot2)
all2017Data <- read.csv("RevVolume.csv", na.strings=c("-"))
cn <- c("isRegion", "area", "revenue", "mcf", "bbls", "date")
colnames(all2017Data) = cn
all2017Data$revenue <- as.numeric(gsub('[$,]', '', all2017Data$revenue))
all2017Data$mcf <- as.numeric(gsub('[$,]', '', all2017Data$mcf))
all2017Data$bbls <- as.numeric(gsub('[$,]', '', all2017Data$bbls))
all2017Data$area <- gsub('\\s+', '', all2017Data$area)

predRev <- function(data, input) {
  lf = lm(revenue ~ mcf, data=data)
  rev = predict(lf, newdata = data.frame(mcf = input$slideValue))
  return(rev)
}
shinyServer(
  function(input, output) {

      output$slider <- renderUI({
        
        areaData <- all2017Data[all2017Data$area == input$area,]
        m <- round(mean(areaData$mcf),0)
        sliderInput('slideValue', 'Volume (mcf)',value = m, min = round(min(areaData$mcf)*0.5,0), 
                    max = round(max(areaData$mcf)*1.5,0), step = m/20)
       
      })
  output$table <- renderUI({
    areaData <- all2017Data[all2017Data$area == input$area,]
    rev <- predRev(areaData, input)
     p(paste("Revenue:",  format(round(rev,0), big.mark=",")))
  })
    output$areaPlot <- renderPlot({
      areaData <- all2017Data[all2017Data$area == input$area,]
      rev <- predRev(areaData, input)
     # output$slideValue = input$slideValue
     # output$predictValue = rev
      g = ggplot(areaData, aes(x = mcf, y = revenue, colour = area))
      g = g + xlab("Volume per day (mcf)")
      g = g + ylab("Revenue")
      g = g + geom_smooth(method = "lm", colour = "black")
      #g = g + geom_point(size = 1, colour = "black", alpha=0.5)
      g = g + geom_point(size = 2, alpha=0.9)
      g = g + geom_point(aes(x=input$slideValue, y=rev), colour="blue")
      g
    })
    
    output$summary <- renderPrint({
      areaData <- all2017Data[all2017Data$area == input$area,]
      rev <- predRev(areaData, input)
      summary(rev)
    })

    
  }
)