const express = require('express')
const morgan = require('morgan')
const helmet = require('helmet')
const  cors = require('cors')

module.exports = server => {
  // logs http requests to console
  server.use(morgan('dev')) 
  // enable requests from any domain
  server.use(cors()) 
  // sets security headers
  server.use(helmet()) 
  // parses http body into json
  server.use(express.json()) 
}