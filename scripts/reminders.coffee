# Description:
#   Sends a reminder to do stuff!
#
# Author:
#   weimeng

TIMEZONE = "Asia/Singapore"

STANDUP_ROOM = "35061_daily_standup@conf.hipchat.com"
STANDUP_SCHEDULE = "0 30 10 * * 2-6"

cronJob = require('cron').CronJob

module.exports = (robot) ->
  daily_standup = new cronJob STANDUP_SCHEDULE, ->
    robot.messageRoom STANDUP_ROOM, "@all Time to do our daily standup! Give a quick update on: (1) what you did yesterday, (2) what you will do today, (3) any obstacles/issues blocking your progress."
    return
  , null, true, TIMEZONE
