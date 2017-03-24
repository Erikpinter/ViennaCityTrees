#
# This is the server logic of a Shiny web application. 
#

library(leaflet)
library(dplyr)
library(htmltools)


# create the basemap using leaflet
map = leaflet()  %>% 
        addProviderTiles("BasemapAT.grau", options = providerTileOptions(minZoom = 1, maxZoom = 23, maxNativeZoom = 19))  %>%
        setView(lng = 16.37, lat = 48.20, zoom =11) 


shinyServer(function(input, output) {
        
        # Reactive expression for the data subsetted to what the user selected
        cleantable_subset <- reactive({
                subset(cleantable, height > min(input$height) & height < max(input$height) & District == input$district & crown_diameter > min(input$crown_diameter) & crown_diameter < max(input$crown_diameter) & year_planted > min(input$year_planted) & year_planted < max(input$year_planted))})
        
        output$map <- renderLeaflet({map})
        
        output$histogram1 <- renderPlot({
                hist(cleantable_subset()$height,
                     xlim = c(min(cleantable$height, na.rm = TRUE), max(cleantable$height, na.rm = TRUE)), 
 #                    ylim = c(0, 2000),
                     breaks = seq(0, 40, by = 5),
                     labels = c("0-5 m", "6-10 m", "11-15 m", "16-20 m", "21-25 m", "26-30 m", "31-35 m", "> 35 m"),
                     main = 'Height of the selected trees',
                     freq = FALSE,
                        xlab = 'height in m',
                     col = "green4")
        })

        output$histogram2 <- renderPlot({
                hist(cleantable_subset()$year_planted,
                     xlim = c(min(cleantable$year_planted, na.rm = TRUE), max(cleantable$year_planted, na.rm = TRUE)), 
#                     ylim = c(0, 2000),
                     breaks = seq(1800, 2020, by=10),
                     main = 'Histogram of years in which the selected trees were planted',
                     freq = FALSE,
                     xlab = 'year',   
                     col = "green4")
        })
        
        observeEvent(input$Plotbtn, {
                if (nrow(cleantable_subset()) != 0) {
                leafletProxy("map", data = cleantable_subset()) %>%
                        clearGroup(group = "Custom") %>%
                        setView(lng = mean(cleantable_subset()$Long), lat = mean(cleantable_subset()$Lat), zoom = 12) %>%
                        addCircles(group = "Custom", lng = ~Long, lat = ~Lat, radius =(~crown_diameter / 2), stroke = TRUE, weight = 2, opacity = 0.4, fill = TRUE, color = "red", label = ~htmlEscape(Info)) %>% 
                        fitBounds(~min(Long), ~min(Lat), ~max(Long), ~max(Lat))} 
        })
        
        output$info = renderText({paste('Number of trees found based on selection:', nrow(cleantable_subset()))})
        
})
