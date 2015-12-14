levelup = require 'levelup'
levelws = require 'level-ws'

levelup = require('levelup')
user_db = levelup('./db/user_db') ## user
association_db = levelup('./db/association_db') ## user to metrics
metrics_db = levelup('./db/metrics_db') ## metrics
db = require './db'

module.exports =

  get: (username, callback) ->
    metrics = []
    metric = []
    rs = metrics_db.createReadStream
      limit: 100
      reverse: true
      keys: true
      values: true
      gte: "metrics:#{username}:1"
      lte: "metrics:#{username}:999999999999"
    rs.on 'data', (data) ->
      value = data.value.split ":"
      metric.push(timestamp: parseInt(value[1]), value: parseInt(value[2]))
      return metric

    rs.on 'error', callback

    rs.on 'close', ->
      callback null, metric

  save: (user, x, callback)->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    for metric, index in x
      {timestamp, value} = metric
      ws.write key: "metrics:#{user}:#{index+1}", value: "metrics:#{timestamp}:#{value}"
    console.log "Batch saved !"
    ws.end()

## ASSOCIATION (BETWEEN USER AND METRICS) METHODS
  auto_generate_user_db: (key, value) ->
    user_db.batch().del('father').put('admin', 'password').put('tata', 'toto').write -> console.log 'Auto generating user database is done!'

  put_association: (key, value) ->
    association_db.put key, value, (err) ->
      if err
        return console.log('Error in putting some data in association_db', err)
      return console.log('Success in putting some data in association_db - key : ' + key + ', value : ' + value)
  get_association: (key) ->
    association_db.get key, (err, value) ->
      if err
        return console.log('Error in getting some data in association_db', err)
      console.log 'Success in getting some data in association_db - key : ' + key + ', value : ' + value
      return value
  del_association: (key) ->
    association_db.del key, (err) ->
      if err
        return console.log('Error in deleting some data in association_db', err)
      console.log 'Success in deleting some data in association_db - key : ' + key


## METRICS TABLE METHODS
  put_metrics: (key, value) ->
    metrics_db.put key, value, (err) ->
      if err
        return console.log('Error in putting some data in metrics_db', err)
      return console.log('Success in putting some data in metrics_db - key : ' + key + ', value : ' + value)
  get_metrics: (key) ->
    metrics_db.get key, (err, value) ->
      if err
        return console.log('Error in getting some data in metrics_db', err)
      console.log 'Success in getting some data in metrics_db - key : ' + key + ', value : ' + value
      return value
  del_metrics: (key) ->
    metrics_db.del key, (err) ->
      if err
        return console.log('Error in deleting some data in metrics_db', err)
      console.log 'Success in deleting some data in metrics_db - key : ' + key
      return value


## USER TABLE METHODS
  put_user: (key, value) ->
    user_db.put key, value, (err) ->
      if err
        return console.log('Error in putting some data in user_db', err)
      return console.log('Success in putting some data in user_db - key : ' + key + ', value : ' + value)
  get_user: (key) ->
    user_db.get key, (err, value) ->
      if err
        return console.log('Error in getting some data in user_db', err)
      console.log 'Success in getting some data in user_db - key : ' + key + ', value : ' + value
      return value
  del_user: (key) ->
    user_db.del key, (err) ->
      if err
        return console.log('Error in deleting some data in user_db', err)
      console.log 'Success in deleting some data in user_db - key : ' + key


###
db.put 'name', 'LevelUP', (err) ->
  if err
    return console.log('Ooops!', err)
  db.get 'name', (err, value) ->
    if err
      return console.log('Ooops!', err)
    console.log 'name from db =' + value
    return
  return

  `save(id, metrics, cb)`
  ------------------------
  Save some metrics with a given id

  Parameters:
  `id`: An integer defining a batch of metrics
  `metrics`: An array of objects with a timestamp and a value
  `callback`: Callback function takes an error or null as parameter

  save: (id, metrics, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    for m in metrics
      {timestamp, value} = m
      ws.write key: "metric:#{id}:#{timestamp}", value: value
    ws.end()

###
