ui <- semanticPage(
  title = "Ships",
  theme = 'spacelab',
  sidebar_layout(
    sidebar_panel(shipNameByTypeUI('ship_name_by_type', shipData)),
    main_panel(
      header('Longest Distance Sailed Between Updates', 'Click the Marker for More Info...'),
      leafletOutput("shipMap", width = '100%'))
  )
)