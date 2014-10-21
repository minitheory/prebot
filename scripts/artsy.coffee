# Description:
#   Find a art piece on Etsy by keyword.
#
# Commands:
#   hubot art me <query> - Show me etsy art work by keyword
#
# Configuration:
#   ETSY_API_KEY - Etsy api key
#   ETSY_API_SECRET - Etsy api secret
#
# Author:
#   Zenan


key = process.env.ETSY_API_KEY;

fetchArtWork = (msg) ->
  keyword = encodeURIComponent(msg.match[1].trim())
  url = 'https://openapi.etsy.com/v2/public/listings/active?'+
        'keywords='+ keyword +
        '&sort_on=created&sort_order=down&api_key=' + key +
        '&includes=MainImage'
  msg.http(url).get() (err, res, body) ->
    return msg.send "I couldn't find any art piece for that! :(" if err

    try
      listings = JSON.parse(body).results
    catch err
      return "I couldn't parse art piece result for that! :("

    try
      piece = listings[Math.floor(Math.random() * listings.length)]
      artwork = piece.MainImage.url_570xN
    msg.send piece.title
    msg.send artwork
    msg.send piece.url

module.exports = (robot) ->

  unless key?
    robot.logger.warning 'The ETSY_API_KEY environment variable not set'

  robot.respond /art me (.*)/i, (msg) ->
    fetchArtWork(msg)
