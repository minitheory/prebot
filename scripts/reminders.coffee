# Description:
#   Sends a reminder to do stuff!
#
# Author:
#   weimeng

TIMEZONE = "Asia/Singapore"

STANDUP_ROOM = "daily-standup"
STANDUP_SCHEDULE = "0 30 9 * * 2-6"

cronJob = require("cron").CronJob

module.exports = (robot) ->
  daily_standup = new cronJob STANDUP_SCHEDULE, ->
    robot.messageRoom STANDUP_ROOM, "<!channel> Time to do our daily standup! Give a quick update on: (1) what you did yesterday, (2) what you will do today, (3) any obstacles/issues blocking your progress."
    return
  , null, true, TIMEZONE
