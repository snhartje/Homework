function createMap(earthquake) {

    // Create the tile layer that will be the background of our map
    var piratesMap = L.tileLayer("https://api.mapbox.com/styles/v1/mapbox/light-v9/tiles/256/{z}/{x}/{y}?access_token={accessToken}", {
      attribution: "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://mapbox.com\">Mapbox</a>",
      maxZoom: 100,
      id: "mapbox.pirates",
      accessToken: API_KEY
    });
  
    // Create a baseMaps object to hold the lightmap layer
    var baseMaps = {
      "Pirates": piratesMap
    };
  
    // Create an overlayMaps object to hold the earthquakes layer
    var overlayMaps = {
      "Earthquakes": earthquake
    };

    // Create the map object with options
    var map = L.map("map-id", {
      center: [38, -115],
      zoom: 5,
      layers: [piratesMap, earthquake]
    }); 
  
    // Create a layer control, pass in the baseMaps and overlayMaps. Add the layer control to the map
    L.control.layers(baseMaps, overlayMaps, {
      collapsed: false
    }).addTo(map);
  }
  
  function createMarkers(response) {
  
    // Pull the earthquakes features
    var earthquakesResponse = response.features;
  
    console.log(response.features)
    console.log(earthquakesResponse.length)

    // Initialize an array to hold earthquakes
    var earthquakeMarkers = [];
  
    // Loop through the earthquakes features array
    for (var index = 0; index < earthquakesResponse.length; index++) {
      var observation = earthquakesResponse[index];
      
      // For each earthquake, create a marker and bind a popup with the earthquake's location and magnitude
      var earthquakeMarker = L.circle([observation.geometry.coordinates[1], observation.geometry.coordinates[0]], {
          color: chooseColor(observation.properties.mag),
          fillColor: chooseColor(observation.properties.mag),
          fillOpacity: 0.50,
          radius: markerSize(observation.properties.mag)
      })
        .bindPopup("<h3>Magnitude: " + observation.properties.mag + "<h3><h3>Location: " + observation.properties.place + "<h3>");
        console.log(observation.geometry.coordinates[0])
        console.log(observation.geometry.coordinates[1])
        console.log(earthquakeMarker)
      // Add the marker to the earthquake markers array
      earthquakeMarkers.push(earthquakeMarker);
    }
    
      //function to choose the color
      function chooseColor(magnitude) {
        if (magnitude < 1) {
          return "green";
        }
        else if (magnitude < 2) {
          return "yellow";
        }
        else if (magnitude < 3) {
          return "gold";
        }
        else if (magnitude < 4) {
          return "orange";
        }
        else if (magnitude < 5) {
          return "orangered";
        }
        else {
          return "red";
        };
      }

    //Define a markerSize function that will give each earthquake a different size
    function markerSize(magnitude) {
      return magnitude*10000;
    };

    console.log(earthquakeMarkers)
  
    // Create a layer group made from the earthquake markers array, pass it into the createMap function
    createMap(L.layerGroup(earthquakeMarkers));
  }
 
  
  // Perform an API call to the Citi Bike API to get station information. Call createMarkers when complete
  d3.json("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson", createMarkers);
  