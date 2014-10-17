# Description:
#   Picks a place for food so we don't have to!

module.exports = (robot) ->

  robot.respond /(lunch|dinner|supper)/i, (msg) ->
    msg.send "McDonald's for you!"
