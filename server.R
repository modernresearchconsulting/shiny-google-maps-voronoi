library(deldir)
library(shiny)

shinyServer(function(input, output, session) {
  
  markers <- reactiveValues(
    label = numeric(0),
    lat = numeric(0),
    lng = numeric(0)
  )
  
  observe({
    req(input$add_point)
    
    message(' -- adding point')
    
    markers$lat <- isolate(c(markers$lat, input$add_point$lat))
    markers$lng <- isolate(c(markers$lng, input$add_point$lng))
    markers$label <- isolate(c(markers$label, input$add_point$label))
  })
  
  observe({
    req(input$update_point)
    
    message(' -- updating point')

    index <- which(isolate(markers$label) == input$update_point$label)
    
    markers$lat[index] <- input$update_point$lat
    markers$lng[index] <- input$update_point$lng
  })
  
  observe({
    req(input$remove_point)
    
    message(' -- removing point')
    
    index <- which(isolate(markers$label) == input$remove_point$label)
    
    markers$lat <- isolate(markers$lat[-index])
    markers$lng <- isolate(markers$lng[-index])
    markers$label <- isolate(markers$label[-index])
  })
  
  observe({
    if (length(markers$lat) >= 2) {
      
      message(' -- drawing voronoi')
      
      voronoi <- deldir::deldir(markers$lng, markers$lat)
      
      point_arrays <- voronoi$dirsgs[c('x1', 'y1', 'x2', 'y2')]
      
      session$sendCustomMessage('draw_voronoi', message = list(
        points = point_arrays,
        geodesic = input$geodesic
      ))
    }
  })
  
  observeEvent(input$clear_all, {
    
    message(' -- clearing all markers')
    
    session$sendCustomMessage('clear_all', message = TRUE)
    
    markers$lat <- numeric(0)
    markers$lng <- numeric(0)
    markers$label <- numeric(0)
  })
})
  
  