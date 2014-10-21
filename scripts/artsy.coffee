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
key_artsy = process.env.ARTSY_API_KEY;
secret_artsy = process.env.ARTSY_API_SECRET;

fetchArtWork = (msg) ->
  keyword = encodeURIComponent(msg.match[1].trim())
  url_etsy = 'https://openapi.etsy.com/v2/public/listings/active?'+
        'keywords='+ keyword +
        '&sort_on=created&sort_order=down&api_key=' + key +
        '&includes=MainImage'
  url_artsy = 'https://api.artsy.net/api/search?q='
        + keyword + '+more:pagemap:metatags-og_type:artwork'
  url_artsy_token = 'https://api.artsy.net/api/tokens/xapp_token?'+
        'client_id='+ key_artsy +
        '&client_secret=' + secret_artsy

  msg.http(url_artsy_token).post() (err, res, body) ->
      return msg.send "I couldn't get token on artsy! :(" if err
      try
        token = JSON.parse(body).token
      catch err
        return msg.send  "I couldn't get the token for artsy :("
      msg.http(url_artsy)
        .headers('X-XAPP-Token': token)
        .get() (err, res, body) ->
          return msg.send "I couldn't find any art piece on artsy for that! :("
          try
            listings = JSON.parse(body)._embedded.results
          catch err
            return msg.send "I couldn't parse art piece result for that! :("

          try
            piece = listings[Math.floor(Math.random() * listings.length)]
            artwork = piece._links.thumbnail.href + "&format=png"
          msg.send piece.title
          msg.send artwork
          msg.send piece._links.permalink.href

  msg.http(url_etsy).get() (err, res, body) ->
    return msg.send "I couldn't find any art piece on etsy for that! :(" if err

    try
      listings = JSON.parse(body).results
    catch err
      return msg.send  "I couldn't parse art piece result for that! :("

    try
      piece = listings[Math.floor(Math.random() * listings.length)]
      artwork = piece.MainImage.url_570xN
    msg.send piece.title
    msg.send artwork
    msg.send piece.url

module.exports = (robot) ->

  unless key?
    robot.logger.warning 'The ETSY_API_KEY environment variable not set'
  unless key_artsy?
    robot.logger.warning 'The ARTSY_API_KEY environment variable not set'
  unless secret_artsy?
    robot.logger.warning 'The ARTSY_API_SECRET environment variable not set'

  robot.respond /art me (.*)/i, (msg) ->
    fetchArtWork(msg)
