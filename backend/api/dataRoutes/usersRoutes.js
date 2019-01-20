const express = require('express')
const db = require('../../data/helpers/userHelpers')

const router = express()

const getUserList = async (req, res) => {
  try {
    const { page } = req.body

    const users = await db.getUserList(page);

    res.status(200).json(users)
  } catch (error) {
    res.status(500).json({error}) 
  }
}

const getUser = async (req, res) => {
  try {
    const { id } = req.params;
    const users = await db.getUser(id);

    res.status(200).json(users[0])
  } catch (error) {
    res.status(500).json({error}) 
  }
}

const postUser = async (req, res) => {
  try {
    // destructing body
    const { name, email, password, firstName, lastName} = req.body
    console.log(name, email, password) 
    const newUser = {
      firstName,
      lastName,
      email,
      password,
    }
    console.log(newUser)
    const users = await db.addUser(newUser);

    res.status(200).json(users)
  } catch (error) {
    res.status(500).json({error}) 
  }
}

const putUser = async (req, res) => {
  try {
    const { id } = req.params
    // destructing body
    const {
      firstName,
      lastName,
      email,
      password,
    } = req.body
    const updatedUser = {
      id,
      firstName,
      lastName,
      email,
      password,
    }

    const users = await db.updateUser(newUser);

    res.status(200).json(users)
  } catch (error) {
    res.status(500).json({error}) 
  }
}

const deleteUser = async (req, res) => {
  try {
    const { id } = req.params
    const users = await db.deleteUser(id);

    res.status(200).json(users)
  } catch (error) {
    res.status(500).json({error}) 
  }
}

router.get('/', getUserList)
router.get('/:id', getUser)
router.post('/', postUser)
router.put('/:id', putUser)
router.delete('/:id', deleteUser)


module.exports = router;