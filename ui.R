#
#    This Shiny App allows you to explore the treedataset from Vienna City Council. The original dataset includes data about 197.444 individual trees in Vienna. 
#
#    erik.pinter@gmail.com
#    
#

library(shiny)
library(shinythemes)

# Define UI
shinyUI(fluidPage(theme = shinytheme("cosmo"),
  
  # Application title
  #titlePanel("Trees in Vienna City, Austria"),
  
  # Sidebar with a sliders and plots 
  sidebarLayout(
    sidebarPanel( h2(tags$strong('Trees in Vienna City, Austria')),
            tags$i(tags$a(href="mailto:erik.pinter@gmail.com" , "by Erik Pinter, 21.03.2017")),
        p("This Shiny App allows you to explore the", tags$a(href = "https://www.data.gv.at/katalog/dataset/c91a4635-8b7d-43fe-9b27-d95dec8392a7", "treedataset from Vienna City Council"), ". The original dataset includes data about 197.444 individual trees in Vienna."),
        p("In order to limit the number of individual trees, the output in this app is limited to a total 108.387 complete cases and can be viewed on a per-district-basis."),
        p(tags$strong("Please make your selections below."), " The changes on the map will be reflected, as soon as you click the ", tags$i("button"), " below. On the map you can get ", tags$i("further information"), " for every single tree (e.g. Species,...)."),
        # selectInput("street", "Streetname:", sort(unique(cleantable$Street)), multiple = TRUE),
        selectInput("district", "District:", sort(unique(cleantable$District)), selected = 1, multiple = FALSE),
        # selectInput("species", "Species:", sort(unique(cleantable$Species)), multiple = TRUE),        
       sliderInput("height",
                   "Height of trees:",
                   min = 0,
                   max = 40,
                   step = 5,
                   value = c(15,30),
                   post = 'm'),
       sliderInput("crown_diameter",
                   "Crown diameter of trees:",
                   min = 0,
                   max = 24,
                   value = c(6,18),
                   step = 3,
                   post ='m'),
       sliderInput("year_planted", 
                   "Trees planted in years:",
                   min = 1800,
                   max = 2016,
                   value = c(1800, 2016),
                   step = 10,
                   pre ='yr '),

verbatimTextOutput('info'),
tags$head(tags$style("#info{color: red; font-weight: bold; }")),
actionButton('Plotbtn', 'Plot selected trees on map', icon = icon('map')),
tags$hr(),
plotOutput('histogram1', height = '200px'),
plotOutput('histogram2', height = '200px')),
    # Show a plot of the generated distribution
    mainPanel(div(class="outer",
#                  tags$style(type = "text/css", ".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                  leafletOutput('map', width="100%", height="900px"))
          
    )
  )
))
