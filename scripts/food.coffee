# Description:
#   Picks a place for food so we don't have to!

fetchPlace = (msg) ->
  return msg.send "You need to set env.GMAPS_API_KEY to get location data" unless process.env.GMAPS_API_KEY?

  key = process.env.GMAPS_API_KEY
  officeLocation = "1.279679,103.841821"
  radius = 500
  types = "food"
  maxPrice = 2 # Max: 4

  url = "https://maps.googleapis.com/maps/api/place/radarsearch/json?" +
        "key=" + key +
        "&location=" + officeLocation +
        "&radius=" + radius +
        "&types=" + types +
        "&maxprice=" + maxPrice

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

    mapUrl   = "http://maps.google.com/maps/api/staticmap?markers=color:red%7C" +
                "1.279679,103.841821" +
                "&markers=color:blue%7C" +
                place.geometry.location.lat + "," + place.geometry.location.long +
                "&size=400x400&maptype=roadmap" +
                "&sensor=false" +
                "&format=png" # So campfire knows it's an image
    msg.send mapUrl
    # url      = "http://maps.google.com/maps?q=" +
    #            escape(location) +
    #           "&hl=en&sll=37.0625,-95.677068&sspn=73.579623,100.371094&vpsrc=0&hnear=" +
    #           escape(location) +
    #           "&t=m&z=11"

module.exports = (robot) ->

  robot.respond /(lunch|dinner|supper)/i, (msg) ->
    fetchPlace(msg)
