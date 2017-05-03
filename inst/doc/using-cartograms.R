## ----fig.width= 8, fig.height=4, message=FALSE, warning=FALSE------------
library(leaflet)
library(sf)
library(dplyr)
library(hansard)
library(mnis)
library(parlitools)
library(cartogram)

west_hex_map <- parlitools::west_hex_map

party_colour <- parlitools::party_colour

elect2015 <- parlitools::bes_2015

elect2015_win_colours <- left_join(elect2015, party_colour, by = c("winner_15" ="party_name")) #Join to current MP data

gb_hex_map <- right_join(west_hex_map, elect2015_win_colours, by = c("gss_code"="onsconst_id")) #Join colours to hexagon map

gb_hex_map <- as(gb_hex_map, "Spatial")

gb_hex_map <- as(gb_hex_map, "SpatialPolygonsDataFrame")

gb_hex_map$majority_15 <- round(gb_hex_map$majority_15, 2)

gb_hex_map$turnout_15 <- round(gb_hex_map$turnout_15, 2)

gp_hex_scaled <- cartogram(gb_hex_map, 'majority_15')

# Creating map labels
labels <- paste0(
  "<strong>", "Constituency: ", gp_hex_scaled$constituency_name.y, "</strong>", "</br>",
  'Turnout: ', gp_hex_scaled$turnout_15, "</br>",
  "2015 Winner: ", gp_hex_scaled$winner_15, "</br>",
  "2015 Majority: ", gp_hex_scaled$majority_15
) %>% lapply(htmltools::HTML)


# Creating the map itself
leaflet(
  gp_hex_scaled) %>%
  addPolygons(
    color = "grey",
    weight=0.75,
    opacity = 0.5,
    fillOpacity = 1,
    fillColor = ~party_colour,
    label=labels) 

