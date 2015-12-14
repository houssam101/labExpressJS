levelup = require('levelup')
association_db = levelup('./db/association_db') ## user to metrics
metrics_db = levelup('./db/metrics_db') ## metrics

module.exports =
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
