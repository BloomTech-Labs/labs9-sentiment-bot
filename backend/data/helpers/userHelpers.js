const db = require('../dbConfig')

const getUser = (id) => db('users')
  .where('id', id)

const getUserList = (page) => db('users')
  .whereBetween('id', [0, 100])

const addUser = (user) => db('users')
  .insert(user)

const editUser = (user) => db('user')
  .update(user)

const deleteUser = (id) => db('user')
  .where('id', id)
  .delete()

module.exports = {
  getUser,
  getUserList,
  addUser,
  editUser,
  deleteUser,
}