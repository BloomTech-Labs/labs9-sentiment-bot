const express = require('express')
const morgan = require('morgan')
const helmet = require('helmet')
const  cors = require('cors')

module.exports = server => {
  server.use(morgan('dev')) // logs http requests to console
  server.use(cors()) // cross origin resource shareing (needs configuring)
  server.use(helmet()) // sets security headers
  server.use(express.json()) // parses http body into json
}