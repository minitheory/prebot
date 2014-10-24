# Description:
#   Daily Standup
#
# Commands:
#   standup - Listens for "standup" keyword and send a random response
#
# Author:
#   Zenan

fetchQuote = (msg) ->
  msg.http("http://quotesondesign.com/api/3.0/api-3.0.json").get(err, res, body) ->
  return msg.send "I’m taking MC today :(" if err

    try
      quote = JSON.parse(body)
    catch err
      return msg.send "I’m taking MC today :("

    msg.send quote.quote + " – " + quote.author

module.exports = (robot) ->

  robot.hear /standup|stand up/i, (msg) ->
    fetchQuote(msg)
