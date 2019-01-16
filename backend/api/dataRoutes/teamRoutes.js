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
    const team = req.body
    
    console.log(team)
    const teams = await db.addTeam(team);

    res.status(200).json(teams)
  } catch (error) {
    res.status(500).json({error}) 
  }
}

const putTeam = async (req, res) => {
  try {
    const { id } = req.params
    // destructing body
    const team = req.body

    const teams = await db.editTeam(team);

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