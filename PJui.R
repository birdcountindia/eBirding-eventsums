# adapted from https://github.com/paintedstork/birdsurveycrunch

library(shiny)
library(plotly)

shinyUI <- fluidPage(
  
  titlePanel("Bird Survey Report"),
  
  sidebarPanel(
    
    helpText(h4("Just upload your data in exactly the same format (zip) that you got it from eBird; we'll unzip it for you. You can upload the unzipped '.csv' file as well")),
    fileInput('zipfile', h3('Upload',accept = c('.zip','.csv'))),
    
    
    helpText(h4("Select the forest division for which you would like to analyse data")),
    selectInput('forestDivision', 'Forest Division', choices = divisions, selected = 'Periyar Tiger Reserve'),
    
    # value is always yyyy-mm-dd, even if the display format is different
    # Start date for the survey
    helpText(h4("Select the start and end dates of the survey")),
    dateInput("startdate", "Start Date of Survey", value = "2019-01-01", format = "dd/mm/yy"),
    
    # value is always yyyy-mm-dd, even if the display format is different
    # End date for the survey
    dateInput("enddate", "End Date of Survey", value = "2019-04-04", format = "dd/mm/yy"), 
    
    helpText(h4("Check this box if you would like to generate indicator species summary per range")),
    checkboxInput("indicaterspeciesperrange", label = "Generete per Range", value = FALSE),
    checkboxInput("pickalllists", label = "Pick All Lists", value = TRUE)
    
  ),
  
  downloadButton('downloadData', 'Download Report'),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Summary", tableOutput('summary')),
      tabPanel("Maps",
               fluidRow( 
                 column( 4,
                         helpText(h4("Configure Maps")),
                         selectInput( 'gridsize', 'Grid Size (km)', choices = c(2, 3, 4, 5), selected = 4, width = "130px"),
                         selectInput( 'cutoff', 'Minimum Lists/Grid', choices = c(2, 3, 4, 5, 6, 7, 8, 9, 10), selected = 3, width = "130px"),
                         checkboxInput("smooth", label = "Smooth Maps", value = TRUE),
                         checkboxInput("empty",  label = "Show Unsampled Grids", value = FALSE),
                         br(),
                         selectInput( 'noofspecies', 'No of species for Maps', choices = c(5, 10, 15, 20, 25, 30, 40, 50, 75, 100), selected = 10, width = "130px"),
                         downloadButton('downloadMaps', 'Download Maps')
                 ),
                 column( 5,
                         selectInput( 'speciesname', 'Show map of Birds', choices = species$English.India, width = "400px" )
                 ),
                 plotOutput("surveymaps") 
               )
      ),
      tabPanel("About", 
               br(), h1("About Bird Survey Report Generator"), 
               br(), p("Bird surveys are conducted in various forest areas with the help of bird-watchers."), 
               br(), p("Bird-watchers use eBird enter their observations as multiple lists."), 
               br(), p("This app helps in analysing the eBird data and create summaries for a bird survey report:"),
               br(), p("Added configuration for Maps: 03 March 2019:")
      )
    )
  )
)