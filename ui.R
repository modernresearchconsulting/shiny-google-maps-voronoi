library(shiny)

source('api_key.R', local = TRUE)

shinyUI(fluidPage(
  
  fluidRow(
    
    column(2,
      
      tags$img(src = 'mrc_logo.png'),
      
      tags$hr(),
      
      h4('Voronoi Creator'),
      
      tags$ol(
        tags$li('Click points on the map to add markers. When there are at least two markers, Voronoi diagram will appear.'),
        tags$li('Drag markers around to update the Voronoi.'),
        tags$li('Double-click markers to remove them (the Voronoi will update).')
      ),
      
      checkboxInput(
        inputId = 'geodesic',
        label   = 'Use geodesic lines (follow curve of earth, instead of straight lines on map)'
      ),
      
      actionButton(
        inputId = 'clear_all',
        label   = 'Clear all markers'
      )
    ),
    
    column(10,
           
      div(
        id = 'map'
      )
    )
  ),

  includeScript('www/app.js'),
  includeScript(sprintf('https://maps.googleapis.com/maps/api/js?key=%s', api_key)),
  includeCSS('www/app.css')
  
))
