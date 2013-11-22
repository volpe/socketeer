Socketeer
=========

Socketeer is a simple way to deploy a redis connected notification
service to your webapp.  The main purpose is to add 'realtime' 
features to a standard (blocking server) webapp.

## Dependencies

    express = require('express')
    io = require('socket.io')
    redis = require ('redis')

## API

    class Socketeer

Socketeer provides the simplest possible API, simply instantiate
with a redis channel and an event map. and Socketeer does the rest

      constructor: (@channel, events) ->
        self = this
        @app = express()
        @io = io.listen(@app)
        @redis = redis.createClient()
        @redis.subscribe(@channel)

The events parameter provides a simple mechanism to map events 
from redis into socket.io events.

        @io.on('connection', (socket) ->

For a simple 'pass-through' (i.e Redis events carrying straight
through the socket) the events parameter can be an Array

          if events instanceof Array
            for event in events
              self.redis.on(event, (channel, message) ->
                socket.emit(event, message)
              )

For a 'mapping' (ie. event 'a' on redis becomes event 'b' on 
  the socket) an object mapping of strings can be provided.

          else if event_map instanceof Object
            for event of events
              self.redis.on(event, (channel, message) ->
                socket.emit(events[event], message)
              )
        )

To mount and run the Socketeer is simple, it simply provides the 
"Go" method:

      go: (port) ->
        @app.listen(port)

## Docker

Socketeer is provided as a Docker instance that is intended 
(for example) to be deployed in an Amazon EC2 instance (or any
cloud service providing a ubuntu precise VM).
