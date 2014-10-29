# Description:
#   Sends a reminder to do stuff!
#
# Author:
#   weimeng

TIMEZONE = "Asia/Singapore"
ROOM = "Dev Hangout!"

SCHEDULE = "*/5 * * * *"

cronJob = require('cron').CronJob

module.exports = (robot) ->
  daily_standup = new cronJob SCHEDULE, ->
    robot.messageRoom ROOM, "Ding", null, true, TIMEZONE
