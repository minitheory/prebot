# Description:
#   Sends a reminder to do stuff!
#
# Author:
#   weimeng

TIMEZONE = "Asia/Singapore"
ROOM = "35061_daily_standup@conf.hipchat.com"

SCHEDULE = "* */5 * * * *"

cronJob = require('cron').CronJob

module.exports = (robot) ->
  daily_standup = new cronJob SCHEDULE, ->
    robot.messageRoom ROOM, "Hi!"
