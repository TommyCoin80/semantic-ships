#required packages
library('shiny') # 1.5
library('shiny.semantic') # 0.4.0
library('leaflet') # 2.0.3

# scripts
source('preprocess.R')

options(semantic.themes = TRUE)

# constants
SHIP_CSV_PATH <- 'data/ships.csv'
SHIP_RDS_PATH <- 'data/ship_data.RDS'

#NOTE:
#I've included the RDS in the data folder but not the original csv, due to size
#Place the ships.csv in the data folder, and remove the RDS to run the data preprocess

# If data preprocessing has not been done, preprocess
if(!file.exists(SHIP_RDS_PATH)) preprocessShipData(SHIP_CSV_PATH,SHIP_RDS_PATH)

# import data object
shipData <- readRDS(SHIP_RDS_PATH)

# Ship Type - Name Module
shipNameByTypeUI <- function(id, choiceList) {
  ns <- NS(id)
  flow_layout(
    cell_width = '100%',
    row_gap = 15,
    label('Select a Type of Ship:'),
    dropdown_input(
      ns("ship_type"), 
      names(choiceList), 
      value = names(choiceList)[[1]]
    ),
    label('Select a Ship:'),
    dropdown_input(
      ns('ship_name'),
      names(choiceList[[1]]),
      value = names(choiceList[[1]])[[1]]
    )
  )
}

shipNameByTypeServer <- function(id, choiceLookup) {
  
  moduleServer(
    id,
    function(input,output,session) {
      observe({
        update_dropdown_input(
          session, 
          'ship_name', 
          choices = names(choiceLookup[[as.character(input$ship_type)]]),
          value = names(choiceLookup[[as.character(input$ship_type)]])[[1]]
        )
      })
      
      shipName <- reactive(choiceLookup[[input$ship_type]][[input$ship_name]])
      
      return(shipName)
      
    }
  )
}
