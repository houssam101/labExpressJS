db = require('./db') "#{__dirname}/../db/metrics_db"

module.exports =
  get: (username, callback) ->
    metrics = []
    metric = []
    rs = db.createReadStream
      gte: "metrics:#{username}:1"
      lte: "metrics:#{username}:99999999999999999"
    rs.on 'data', (data) ->
      value = data.value.split ":"
      metric.push(date: parseInt(value[1]), value: parseInt(value[2]))
      return metric

    rs.on 'error', callback

    rs.on 'close', ->
      callback null, metric

  save: (user, date, value, callback)->
    this.get user, (err, data) ->
      console.log value
      ws = db.createWriteStream()
      ws.on 'error', callback
      ws.on 'close', callback
      ws.write key: "metrics:#{user}:#{data.length+1}", value: "metrics:#{date}:#{value}"
      console.log "New user metric added"
      ws.end()
