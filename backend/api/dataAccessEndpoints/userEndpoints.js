const express = require('express')

const db = require('../../data/helpers/userHelpers')

const router = express()

const getUser

router.get('/', getUser)
router.get('/:id', getUsers)
router.post('/', addUser)
router.put('/:id', editUser)
router.delete('/:id', deleteUser)


module.exports = router