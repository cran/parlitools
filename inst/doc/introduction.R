## ----fig.width=6, fig.height=7, message=FALSE, warning=FALSE-------------
library(leaflet)
library(sf)
library(htmlwidgets)
library(dplyr)
library(parlitools)

west_hex_map <- parlitools::west_hex_map

party_col <- parlitools::party_colour

mps <- mps_on_date("2017-06-20")

mps_colours <- left_join(mps, party_col, by = "party_id") 
#Join to current MP data

west_hex_map <- left_join(west_hex_map, mps_colours, by = "gss_code") 
#Join colours to hexagon map

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
  minZoom = 6, maxZoom = 6, maxBounds = list(list(2.5,-7.75), list(58.25,50.0)),
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

## ----fig.width=6, fig.height=7, message=FALSE----------------------------
library(leaflet)
library(sf)
library(htmlwidgets)
library(dplyr)
library(hansard)
library(parlitools)

west_hex_map <- parlitools::west_hex_map #Base map

trump_no <- hansard::epetition(ID = 648278, by_constituency=TRUE) 
#Download anti-inviting Trump signatures

west_trump_no <- dplyr::left_join(west_hex_map, trump_no, by = "gss_code") 
#Joining to base map

pal = colorNumeric("Blues", trump_no$number_of_signatures)

label_no <- paste0(
  "<strong>", west_trump_no$constituency_name, "</strong>", "</br>",
  "Signatures: ", west_trump_no$number_of_signatures
) %>% lapply(htmltools::HTML)

leaflet(options=leafletOptions(
  dragging = FALSE, zoomControl = FALSE, tap = FALSE,
  minZoom = 6, maxZoom = 6, maxBounds = list(list(2.5,-7.75), list(58.25,50.0)),
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

## ----fig.width=6, fig.height=7, message=FALSE, warning=FALSE-------------
library(dplyr)
library(ggplot2)

census_11 <- parlitools::census_11

bes_2017 <- parlitools::bes_2017

elect_results <- left_join(census_11, bes_2017)

degree_plot <- ggplot(elect_results, aes(y=lab_17, x=degree)) +
  geom_point(alpha=0.75) +
  geom_smooth(size=1.75, colour = "#DC241F") +
  ylab("Share of Votes Cast for Labour") + 
  xlab("Percentage of Population with a University Degree")

degree_plot


