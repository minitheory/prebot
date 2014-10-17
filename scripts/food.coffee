# Description:
#   Picks a place for food so we don't have to!

fetchPlace = (msg) ->
  return msg.send "You need to set env.GMAPS_API_KEY to get location data" unless process.env.GMAPS_API_KEY?

  key = process.env.GMAPS_API_KEY
  officeLocation = "1.279679,103.841821"
  radius = 500
  types = "food"

  url = "https://maps.googleapis.com/maps/api/place/radarsearch/json?" +
        "key=" + key +
        "&location=" + officeLocation +
        "&radius=" + radius +
        "&types=" + types

  msg.http(url).header("Accept", "application/json").get() (err, res, body) ->
    return msg.send "I encountered an error." if err
    try
      body = JSON.parse body
      place = msg.random body.results
    catch err
      return msg.send "I encountered an error."
    fetchPlaceDetails(msg, place.place_id)

fetchPlaceDetails = (msg, placeId) ->
  key = process.env.GMAPS_API_KEY
  url = "https://maps.googleapis.com/maps/api/place/details/json?" +
        "key=" + key +
        "&placeid=" + placeId

  msg.http(url).header("Accept", "application/json").get() (err, res, body) ->
    return msg.send "I encountered an error." if err
    try
      body = JSON.parse body
      place = body.result
    catch err
      return msg.send "I encountered an error."

    details = place.name + " @ " + place.formatted_address + " | Rating: " + place.rating + " | Website: " + place.website

    msg.send details

module.exports = (robot) ->

  robot.respond /(lunch|dinner|supper)/i, (msg) ->
    fetchPlace(msg)
