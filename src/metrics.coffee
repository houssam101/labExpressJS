levelup = require('levelup')
db = levelup('./db')

db.put 'name', 'LevelUP', (err) ->
  if err
    return console.log('Ooops!', err)
  db.get 'name', (err, value) ->
    if err
      return console.log('Ooops!', err)
    console.log 'name=' + value
    return
  return


  ###
  `save(id, metrics, cb)`
  ------------------------
  Save some metrics with a given id

  Parameters:
  `id`: An integer defining a batch of metrics
  `metrics`: An array of objects with a timestamp and a value
  `callback`: Callback function takes an error or null as parameter
  ###
  save: (id, metrics, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    for m in metrics
      {timestamp, value} = m
      ws.write key: "metric:#{id}:#{timestamp}", value: value
    ws.end()