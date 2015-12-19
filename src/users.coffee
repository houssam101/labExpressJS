db = require('./db') "#{__dirname}/../db/user_db"

module.exports =
  get: (callback) ->
    users = []
    rs = db.createReadStream
      gte: "user:a"
      lte: "user:zzzzzzzzzzzzzzzz"
    rs.on 'data', (data) ->
      key = data.key.split ":"
      value = data.value.split ":"
      console.log(value[1], '=', value[2])
      users.push(user: value[1], pass: value[2])
      return users
    rs.on 'error', ->
      callback null
    rs.on 'close', ->
      callback null, users

  save: (user, pass, callback) ->
    ws = db.createWriteStream()
    ws.write key: "user:#{user}", value:"user:#{user}:#{pass}"
    console.log "User '" + user + "' is registered."

    ws.on 'error', callback
    ws.on 'close', callback
    ws.end()