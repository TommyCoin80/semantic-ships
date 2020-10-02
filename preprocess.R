library('geosphere') # 1.5-10 for distance calculation
 
preprocessShipData <- function(csvPath, rdsPath) {
  
  # get vector lagged by 1
  getPrevious <- function(x, first = NA) c(first, x[-length(x)])
  
  #buid html for popup
  getPopupHtml <- function(lons, lats, shipName, mtrs) {
    paste0(
      "<b>",shipName,"</b><br />",
      "Traveled ", round(mtrs), " meters<br />",
      "From  [", round(lats[[1]],4), ", ", round(lats[[2]],4),"] To [", 
      round(lons[[1]],4), ", ", round(lons[[2]],4), "]"
    )
  }
  
  # calculate travel distances and select max by ship
  maxTraveled <- function(df) {
    df$PREV_LON <- getPrevious(df$LON, as.double(NA))
    df$PREV_LAT <- getPrevious(df$LAT, as.double(NA))
    df$METERS_TRVLD <- with(df,distHaversine(cbind(LON, LAT), cbind(PREV_LON, PREV_LAT))
    )
    df <- df[!is.na(df$METERS_TRVLD),]
    ship <- NULL
    if(nrow(df)) {
      ship <- as.list(df[which.max(df$METERS_TRVLD),])
      ship$LONS <- c(ship$PREV_LON, ship$LON)
      ship$LATS <- c(ship$PREV_LAT, ship$LAT)
      ship$POPUP <- getPopupHtml(ship$LONS, ship$LATS, ship$SHIPNAME, ship$METERS_TRVLD) 
    }
    return(ship)
  }
  
  df <- read.csv(csvPath, stringsAsFactors = F, check.names = F) # read csv to df
  df$DATETIME <- as.POSIXct(df$DATETIME) # convert datetimes to posix
  df <- df[order(df$ship_type, df$SHIPNAME, df$DATETIME),] # order rows by ship and time
  
  # split by ship type and name
  dfSplit <- lapply(split(df, df$ship_type), function(df) split(df, df$SHIPNAME))
  shipSplit <- lapply(dfSplit, lapply, maxTraveled)
  shipSplit <- Filter(function(x) !is.null(x), shipSplit) #remove invalid data
  
  saveRDS(shipSplit, rdsPath) # save
  return()

}

