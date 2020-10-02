function(input, output, session) {
  # Ship selecter module provides data
  ship <- shipNameByTypeServer("ship_name_by_type", shipData)
  
  output$shipMap <- renderLeaflet({
    req(ship()) # do not render without data
    leaflet() %>%
      addProviderTiles(
        providers$Stamen.TonerLite,
        options = providerTileOptions(noWrap = TRUE)
      ) %>% addPolylines( # Line of travel
        lng = ship()$LONS, 
        lat = ship()$LATS
      ) %>%  addMarkers( # marker with popup at destination
        ship()$LON, 
        ship()$LAT, 
        popup = ship()$POPUP,
      ) 
  })
  
}