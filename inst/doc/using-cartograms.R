## ----fig.width=6, fig.height=7, message=FALSE, warning=FALSE-------------
library(leaflet)
library(sf)
library(htmlwidgets)
library(dplyr)
library(hansard)
library(mnis)
library(parlitools)
library(cartogram)

west_hex_map <- parlitools::west_hex_map

party_colour <- parlitools::party_colour

elect2017 <- parlitools::bes_2017

elect2017_win_colours <- left_join(elect2017, party_colour, by = c("winner_17" ="party_name")) #Join to current MP data

gb_hex_map <- right_join(west_hex_map, elect2017_win_colours, by = c("gss_code"="ons_const_id")) #Join colours to hexagon map

gb_hex_map <- as(gb_hex_map, "Spatial")

gb_hex_map <- as(gb_hex_map, "SpatialPolygonsDataFrame")

gb_hex_map$majority_17 <- round(gb_hex_map$majority_17, 2)

gb_hex_map$turnout_17 <- round(gb_hex_map$turnout_17, 2)

gb_hex_map$marginality <- (100-gb_hex_map$majority_17)^3

gp_hex_scaled <- cartogram(gb_hex_map, 'marginality')

# Creating map labels
labels <- paste0(
  "Constituency: ", gp_hex_scaled$constituency_name.y, "</br>",
  "Most Recent Winner: ", gp_hex_scaled$winner_17, "</br>",
  "Most Recent Majority: ", gp_hex_scaled$majority_17, "%","</br>",
  "Turnout: ", gp_hex_scaled$turnout_17, "%"
) %>% lapply(htmltools::HTML)

# Creating the map itself
leaflet(options=leafletOptions(
  dragging = FALSE, zoomControl = FALSE, tap = FALSE,
  minZoom = 6, maxZoom = 6, maxBounds = list(list(2.5,-7.75),list(58.25,50.0)),
  attributionControl = FALSE),
  gp_hex_scaled) %>%
  addPolygons(
    color = "grey",
    weight=0.75,
    opacity = 0.5,
    fillOpacity = 1,
    fillColor = ~party_colour,
    label=labels) %>% 
  htmlwidgets::onRender(
    "function(x, y) {
        var myMap = this;
        myMap._container.style['background'] = '#fff';
    }")%>% 
  mapOptions(zoomToLimits = "first")


