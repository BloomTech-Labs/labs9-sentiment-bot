const express = require('express')
const db = require('../../data/helpers/teamHelpers')

const router = express()

const getTeamList = async (req, res) => {
  try {
    const { page } = req.body

    const teams = await db.getTeamList(page);

    res.status(200).json(teams)
  } catch (error) {
    res.status(500).json({error}) 
  }
}

const getTeam = async (req, res) => {
  try {
    const { id } = req.params;
    const teams = await db.getTeam(id);

    res.status(200).json(teams)
  } catch (error) {
    res.status(500).json({error}) 
  }
}

const postTeam = async (req, res) => {
  try {
    // destructing body
    const { name, email, password, firstName, lastName} = req.body
    console.log(name, email, password) 
    const newTeam = {
      firstName,
      lastName,
      email,
      password,
    }
    console.log(newTeam)
    const teams = await db.addTeam(newTeam);

    res.status(200).json(teams)
  } catch (error) {
    res.status(500).json({error}) 
  }
}

const putTeam = async (req, res) => {
  try {
    const { id } = req.params
    // destructing body
    const {
      firstName,
      lastName,
      email,
      password,
    } = req.body
    const updatedTeam = {
      id,
      firstName,
      lastName,
      email,
      password,
    }

    const teams = await db.updateTeam(newTeam);

    res.status(200).json(teams)
  } catch (error) {
    res.status(500).json({error}) 
  }
}

const deleteTeam = async (req, res) => {
  try {
    const { id } = req.params
    const teams = await db.deleteTeam(id);

    res.status(200).json(teams)
  } catch (error) {
    res.status(500).json({error}) 
  }
}

router.get('/', getTeamList)
router.get('/:id', getTeam)
router.post('/', postTeam)
router.put('/:id', putTeam)
router.delete('/:id', deleteTeam)


module.exports = router;