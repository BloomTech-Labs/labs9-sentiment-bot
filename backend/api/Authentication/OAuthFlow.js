const express = require('express')

const router = express()

const db = require('../../data/helpers/userHelpers')

const asyncOAuth = async (req, res) => {

  try {

    console.log(req.body)
    const { email } = req.body
    
    try {
      const user = await db.getUserByEmail(email)
      res.status(200).json(user[0])
    } catch (error) {
       // if the user doesn't exist in the db
      const success = await db.addUser({
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        email: req.body.email,
        password: req.body.password ? req.body.password : null
      })

      // get the new user and send it back
      const newUser = await db.getUserByEmail(email)
      res.status(200).json(newUser)
    }
    console.log('user from db', user)
    // check if incoming email matches an email in the db
    if(user.email === email) {
      res.status(200).json(user)
    } else {
      // email doesn't match
      res.status(200).json(user)
    }
  } 
  catch (error) {
    console.log(error)
    res.status(500).json({
      message: 'There was an error logging in',
      error: error
    })
  }
}

const OAuthRoute = (req, res) => {
  const { email } = req.body

  db.getUserByEmail(email)
    .then(user => {
      if(email === user.email) {
        res.status.json(user)
      } else {
        db.addUser()

      }
    }).catch(error => {
      // user doesn't exist in db
      db.addUser({
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        email: req.body.email,
        password: req.body.password ? req.body.password : null
      })

      console.log(error)
      res.status(500).json({
        message: 'There was an error logging in',
        error: error
      })
    })

}

router.post('/', asyncOAuth)

module.exports = router; 