# Description:
#   Picks a place for food so we don't have to!

module.exports = (robot) ->

  robot.respond /(lunch|dinner|supper)/i, (msg) ->
    if process.env.GMAPS_API_KEY?
      key = process.env.GMAPS_API_KEY
      officeLocation = "1.279679,103.841821"
      radius = 500
      types = "food"

      url = "https://maps.googleapis.com/maps/api/place/radarsearch/json?" +
            "key=" + key +
            "&location=" + officeLocation +
            "&radius=" + 500 +
            "&types=" + types

      msg.robot.http(url).get() (error, response, body) ->
        data = JSON.parse(body)
        place = data.results[Math.floor(Math.random() * data.results.length)]

      msg.send place.place_id
    else
      msg.send "No food for you!"
