express = require 'express'
app = express()
levelup = require('levelup')
db = require './db'
session = require 'express-session'
LevelStore = require('level-session-store')(session)

app.set 'port', 1889
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'
app.use '/', express.static "#{__dirname}/../public"
app.use require('body-parser')()
app.use session
  secret: '35k6itUdYceaqQtqGlW0jBIA1RF'
  store: new LevelStore '../db/sessions'
  resave: true
  saveUninitialized: true

authCheck = (req, res, next) ->
  unless req.session.loggedIn == true
    req.session.loggedIn = false
    res.locals.connected = false
    req.session.user = null
    res.redirect '/login'
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

app.get '/generate-user-db', authCheck, (req, res) ->
  db.auto_generate_user_db
  res.render 'login'

app.get '/display-metrics', authCheck, (req, res) ->
  console.log "db.get_association timestamp = " + db.get_association 'admin'
  res.render 'display_metrics'

app.get '/insert-metrics', authCheck, (req, res) ->
    console.log "req.session.name = " + req.session.name
    res.render 'insert_metrics'

app.get '/metrics.json', authCheck, (req, res) ->
  res.status(200).json metrics.get()

app.get '/hello/:name', authCheck, (req, res) ->
  res.status(200).send req.params.name

app.post '/insert-metric', authCheck, (req,res) ->
    username='admin'
    timestamp = (new Date).getTime().toString()
    db.put_metrics timestamp,req.body.value
    db.put_association username,timestamp

app.post '/metric/:id.json', authCheck, (req, res) ->
  db.save req.params.id, req.body, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"

app.get '/login', (req, res) ->
  res.render 'login'

app.post '/login', (req, res) ->
  console.log "Login method called"
  console.log "- user : " + req.body.user
  console.log "- pass : " + req.body.pass

  if req.body.user == "admin" and req.body.pass == "password"
    res.locals.connected = true
    req.session.loggedIn = true
    req.session.user = req.body.user
    res.locals.user = req.body.user
    res.render 'insert_metrics'
  else
    res.locals.connected = false
    req.session.loggedIn = false
    req.session.user = null
    res.locals.error_login = true
    res.render 'login'

app.listen app.get('port'), () ->
  console.log "listening on #{app.get 'port'}"