const express = require('express')

const configureMiddleware = require('./middleware')
const server = express()

configureMiddleware(server)

// sanity endpoint
server.get('/', (req, res) => {
  res.status(200).json({ message: 'server up!'})
})

// we'll use URL/api as the base route for most api requests
server.use('/api', require('./api/apiRoutes'))

module.exports = server;