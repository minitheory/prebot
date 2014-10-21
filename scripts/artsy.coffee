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
        '&sort_on=score&sort_order=down&api_key=' + key
  console.error(url)
  msg.http(url).get() (err, res, body) ->
    listings = JSON.parse(body).results
    unless listings?
      piece = listings[Math.floor(Math.random() * listings.length)];
      msg.send piece

module.exports = (robot) ->

  unless key?
    robot.logger.warning 'The ETSY_API_KEY environment variable not set'

  robot.respond /art me (.*)/i, (msg) ->
    fetchArtWork(msg)
