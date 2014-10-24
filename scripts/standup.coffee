# Description:
#   Daily Standup
#
# Commands:
#   standup/stand up - Respond for "standup"/"stand up" keywords and send a random response
#
# Author:
#   Zenan

fetchQuote = (msg) ->
  msg.http("http://quotesondesign.com/api/3.0/api-3.0.json")
  .get() (err, res, body) ->

    msg.send err

    return msg.send "I’m taking MC today :(" if err

    try
      quote = JSON.parse(body)
      msg.send quote
    catch err
      return msg.send "I’m taking MC today :("

    msg.send quote.quote + " – " + quote.author

module.exports = (robot) ->

  robot.respond /standup|stand up/i, (msg) ->
    fetchQuote(msg)
