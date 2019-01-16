const express = require('express')

const router = express()

// 'sanity' endpoint
router.get('/', (req, res) => {
  res.status(200).json({
    message: 'api up!'
  })
})


router.use('/oauth', require('./Authentication/OAuthFlow'))
router.use('/users', require('./dataRoutes/usersRoutes'))
router.use('/slack', require('./slack-bot'))

module.exports = router;