express = require 'express'
app = express()
levelup = require('levelup')
##db = require './db'
session = require 'express-session'
LevelStore = require('level-session-store')(session)
morgan = require 'morgan'
bodyparser = require 'body-parser'
users = require './users'
metrics = require './metrics'

app.use bodyparser.json()
app.use bodyparser.urlencoded()
app.set 'port', 1889
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'
app.use '/', express.static "#{__dirname}/../public"
app.use require('body-parser')()
app.use session
  secret: '35ktqG6A1RFitUdYA1RFceaqQtqGlA1RFW0jBIA1RFtqG'
  store: new LevelStore './db/sessions'
  resave: true
  saveUninitialized: true

authCheck = (req, res, next) ->
  if req.session.loggedIn != true
    req.session.loggedIn = false
    res.locals.connected = false
    req.session.user = null

    if req.url == '/signup'
    then res.render 'signup'
    else res.render 'login'
  else
    req.session.loggedIn = true
    res.locals.connected = true
    res.locals.user = req.session.user
    next()

app.get '/logout', (req, res) ->
  req.session.loggedIn = false
  req.session.user = null
  res.locals.connected = false
  res.render 'login'

app.get '/', authCheck, (req, res) ->
  res.render 'login'

app.get '/my-metrics', authCheck, (req, res) ->
  console.log "req.session.user = " + req.session.user
  res.render 'my_metrics'

app.get '/users.json', (req, res) ->
  users.get (err, users) ->
    res.status(200).json users

app.get '/hello/:name', authCheck, (req, res) ->
  res.status(200).send req.params.name

app.post '/my-metrics', authCheck, (req, res) ->
  username = req.session.user

  myDate = req.body.date
  myDate.split "-"
  newDate = myDate[1] + '/' + myDate[0] + '/' + myDate[2]
  myDate2 = new Date(newDate)
  console.log myDate2.getTime()

  metrics.save req.session.user, myDate2.getTime(), req.body.value, (err, data) ->
    if err then throw error
    else
      res.render 'my_metrics'


###
  db.put_metrics timestamp, req.body.value
  db.put_association username, timestamp
###

app.get '/metrics.json', (req, res) ->
  metrics.get req.session.user, (err, data) ->
    res.status(200).json data

app.post '/metrics/:id.json', authCheck, (req, res) ->
  db.save req.params.id, req.body, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"

app.get '/login', (req, res) ->
  res.render 'login'

app.get '/signup', authCheck, (req, res) ->
  res.render 'signup'

app.post '/signup', (req, res) ->
  users.save req.body.user, req.body.pass, (err, data) ->
    if err then throw error
    else
      res.redirect '/'

app.post '/login', (req, res) ->
  users.check req.body.user, (err, data)  ->
    if err then throw error
    console.log "data.user = " + data.user + ", data.pass = " + data.pass

    if req.body.pass == data.pass
      console.log "user authenticated"
      res.locals.connected = true
      req.session.loggedIn = true
      req.session.user = req.body.user
      res.locals.user = req.body.user
      res.render 'my_metrics'
    else
      console.log "user not authenticated"
      res.locals.connected = false
      req.session.loggedIn = false
      req.session.user = null
      res.locals.error_login = true
      res.render 'login'

app.listen app.get('port'), () ->
  console.log "listening on #{app.get 'port'}"