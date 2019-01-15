const express = require('express')

const router = express()

const protected = (req, res, next) => {
  const token = req.headers.authentication;
  console.log(token)
  if (token) {
    jwt.verify(token, process.env.JWT_SECRET, (err, decodedToken) => {
      if (err) {
        res.status(401).json({ message: 'invalid token' });
      } else {
        req.decodedToken = decodedToken;
        next()
      }
    })
  } else {
    res.status(401).json({message: 'No token provided.'})
  }
}


// ======== JWT flow ==============



// ================================
// 'sanity' endpoint
router.get('/', (req, res) => {
  res.status(200).json({
    message: 'api up!'
  })
})

router.use('/accounts', require('./accountRoutes/jwt'))

router.use('/users', protected, require('./dataRoutes/usersRoutes'))
router.use('/slack', require('./slack-bot'))

module.exports = router;