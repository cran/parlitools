## ----fig.width=6, fig.height=7, message=FALSE, warning=FALSE-------------
library(leaflet)
library(sf)
library(htmlwidgets)
library(dplyr)
library(hansard)
library(mnis)
library(parlitools)

west_hex_map <- parlitools::west_hex_map

party_colour <- parlitools::party_colour

mps <- mps_on_date("2017-04-19")

mps_colours <- left_join(mps, party_colour, by = "party_id") #Join to current MP data

west_hex_map <- left_join(west_hex_map, mps_colours, by = "gss_code") #Join colours to hexagon map

# Creating map labels
labels <- paste0(
  "<strong>", west_hex_map$constituency_name, "</strong>", "</br>",
  "Party: ", west_hex_map$party_name, "</br>",
  "MP: ", west_hex_map$display_as, "</br>",
  "Most Recent Result: ", west_hex_map$result_of_election, "</br>",
  "Current Majority: ", west_hex_map$majority, " votes"
) %>% lapply(htmltools::HTML)

# Creating the map itself
leaflet(options=leafletOptions(
  dragging = FALSE, zoomControl = FALSE, tap = FALSE,
  minZoom = 6, maxZoom = 6, maxBounds = list(list(2.5,-7.75),list(58.25,50.0)),
  attributionControl = FALSE),
  west_hex_map) %>%
  addPolygons(
    color = "grey",
    weight=0.75,
    opacity = 0.5,
    fillOpacity = 1,
    fillColor = ~party_colour,
    label=labels)  %>% 
  htmlwidgets::onRender(
    "function(x, y) {
        var myMap = this;
        myMap._container.style['background'] = '#fff';
    }")

## ----fig.width= 6, fig.height=7,message=FALSE----------------------------
library(leaflet)
library(sf)
library(htmlwidgets)
library(dplyr)
library(hansard)
library(mnis)
library(parlitools)

west_hex_map <- parlitools::west_hex_map #Base map

trump_yes <- hansard::epetition(ID = 680905, by_constituency=TRUE) #Download pro-inviting Trump signatures

pal = colorNumeric("Oranges", trump_yes$number_of_signatures)

west_trump_yes <- dplyr::left_join(west_hex_map, trump_yes, by = "gss_code") #Joining to base map

label_yes <- paste0(
  "<strong>", west_trump_yes$constituency_name, "</strong>", "</br>",
  "Signatures: ", west_trump_yes$number_of_signatures
) %>% lapply(htmltools::HTML)

leaflet(options=leafletOptions(
  dragging = FALSE, zoomControl = FALSE, tap = FALSE,
  minZoom = 6, maxZoom = 6, maxBounds = list(list(2.5,-7.75),list(58.25,50.0)),
  attributionControl = FALSE),
  west_trump_yes) %>%
  addPolygons(
    color = "grey",
    weight=0.75,
    opacity = 0.5,
    fillOpacity = 1,
    fillColor = ~pal(number_of_signatures),
    label = label_yes) %>%
  addLegend("topright", pal = pal, values = ~number_of_signatures,
    title = "Number of Signatures",
    opacity = 1)  %>% 
  htmlwidgets::onRender(
    "function(x, y) {
        var myMap = this;
        myMap._container.style['background'] = '#fff';
    }")%>% 
  mapOptions(zoomToLimits = "first")

## ----fig.width=6, fig.height=7, message=FALSE----------------------------
library(leaflet)
library(sf)
library(htmlwidgets)
library(dplyr)
library(hansard)
library(mnis)
library(parlitools)

west_hex_map <- parlitools::west_hex_map #Base map

trump_no <- hansard::epetition(ID = 648278, by_constituency=TRUE) #Download anti-inviting Trump signatures

west_trump_no <- dplyr::left_join(west_hex_map, trump_no, by = "gss_code") #Joining to base map

pal = colorNumeric("Blues", trump_no$number_of_signatures)

label_no <- paste0(
  "<strong>", west_trump_no$constituency_name, "</strong>", "</br>",
  "Signatures: ", west_trump_no$number_of_signatures
) %>% lapply(htmltools::HTML)

leaflet(options=leafletOptions(
  dragging = FALSE, zoomControl = FALSE, tap = FALSE,
  minZoom = 6, maxZoom = 6, maxBounds = list(list(2.5,-7.75),list(58.25,50.0)),
  attributionControl = FALSE),
  west_trump_no) %>%
  addPolygons(
    color = "grey",
    weight=0.75,
    opacity = 0.5,
    fillOpacity = 1,
    fillColor = ~pal(number_of_signatures),
    label = label_no) %>%
  addLegend("topright", pal = pal, values = ~number_of_signatures,
    title = "Number of Signatures",
    opacity = 1)  %>% 
  htmlwidgets::onRender(
    "function(x, y) {
        var myMap = this;
        myMap._container.style['background'] = '#fff';
    }")%>% 
  mapOptions(zoomToLimits = "first")

