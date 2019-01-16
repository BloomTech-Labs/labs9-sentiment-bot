const express = require('express')

const router = express()

const db = require('../../data/helpers/userHelpers')

// for OAuth flow
router.post('/oauth', async (req, res) => {

  try {

    const { email } = req.body
    
    const user = await db.getUserByEmail(email)
    if(user.email === email) {
      res.status(200).json(user)
    } else {
      const success = await db.addUser({
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        email: req.body.email,
        password: req.body.password
      })
      const newUser = await db.getUserByEmail(email)
      res.status(200).json(newUser)
    }
  } 
  catch (error) {
    res.status(500).json({
      message: 'There was an error logging in',
      error: error
    })
  }
})


module.exports = router; 