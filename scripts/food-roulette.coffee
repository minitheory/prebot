# Description:
#   Picks a place for food so we don't have to!
#
# Commands:
#   hubot lunch/dinner/supper - Queries Google for nearby places and returns a suitable place for a meal!
#
# Author:
#   weimeng

key = process.env.GMAPS_API_KEY
officeLocation = "1.279679,103.841821"

fetchPlace = (msg) ->
  return msg.send "You need to set env.GMAPS_API_KEY to get location data" unless process.env.GMAPS_API_KEY?

  radius = 500
  types = "food"

  url = "https://maps.googleapis.com/maps/api/place/radarsearch/json?" +
        "key=" + key +
        "&location=" + officeLocation +
        "&radius=" + radius +
        "&types=" + types

  msg.http(url).header("Accept", "application/json").get() (err, res, body) ->
    return msg.send "I couldn't search for nearby places! :(" if err
    try
      body = JSON.parse body
      place = msg.random body.results
    catch err
      return msg.send "I couldn't parse the nearby places data! :("
    fetchPlaceDetails(msg, place.place_id)

fetchPlaceDetails = (msg, placeId) ->
  url = "https://maps.googleapis.com/maps/api/place/details/json?" +
        "key=" + key +
        "&placeid=" + placeId

  msg.http(url).header("Accept", "application/json").get() (err, res, body) ->
    return msg.send "I couldn't fetch the location details! :(" if err
    try
      body = JSON.parse body
      place = body.result
    catch err
      return msg.send "I couldn't parse the location details! :("

    details = place.name + " | Rating: " + place.rating + " | Website: " + place.website

    mapUrl   = "http://maps.google.com/maps/api/staticmap?markers=color:red%7C" +
                officeLocation +
                "&markers=color:blue%7C" +
                place.geometry.location.lat + "," + place.geometry.location.lng +
                "&size=400x400&maptype=roadmap&sensor=false" +
                "&format=png" # So campfire knows it's an image

    directionsUrl = "http://maps.google.com/maps/dir/'" +
                    officeLocation + "'/'" +
                    place.geometry.location.lat + "," +
                    place.geometry.location.lng + "'/"

    msg.send mapUrl
    msg.send details + "\n Directions: " + directionsUrl

module.exports = (robot) ->

  robot.respond /(lunch|dinner|supper)/i, (msg) ->
    fetchPlace(msg)
