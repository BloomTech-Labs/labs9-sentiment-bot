const db = require('../dbConfig')

const getTeam = (id) => db('users')
  .where('id', id)

const getTeamList = (page) => db('users')


const addTeam = (user) => db('users')
  .insert(user)

const editTeam = (user) => db('user')
  .update(user)

const deleteTeam = (id) => db('user')
  .where('id', id)
  .delete()

module.exports = {
  getTeam,
  getTeamList,
  addTeam,
  editTeam,
  deleteTeam,
}