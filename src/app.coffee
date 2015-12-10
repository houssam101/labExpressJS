express = require 'express'
app = express()
metrics = require './metrics'

app.set 'port', 1889
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'
app.use '/', express.static "#{__dirname}/../public"
app.use require('body-parser')()

app.get '/login', (req, res) ->
  res.render 'login'

app.get '/insert-metrics', (req, res) ->
  res.render 'insert_metrics'

app.get '/', (req, res) ->
  res.render 'login'

app.get '/metrics.json', (req, res) ->
  res.status(200).json metrics.get()


app.get '/hello/:name', (req, res) ->
  res.status(200).send req.params.name

app.post '/metric/:id.json', (req, res) ->
  metrics.save req.params.id, req.body, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"


app.post '/login', (req, res) ->
  console.log "Login method called"
  console.log "- user : " + req.body.user
  console.log "- pass : " + req.body.pass
  if (req.body.user = "admin" && req.body.pass = "password") then res.render 'insert_metrics'
  else res.render 'login'

app.listen app.get('port'), () ->
  console.log "listening on #{app.get 'port'}"