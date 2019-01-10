const express = require('express')

const router = express()

// 'sanity' endpoint
router.get('/', (req, res) => {
  res.status(200).json({
    message: 'server up!'
  })
})

module.exports = router;