
exports.up = function(knex, Promise) {
  return knex.schema.createTable('users', (user) => {
    user.increments('id')
    user.string('firstName')
    user.string('lastName')
    user.string('password')
    user.string('email').unique()
  }).then(function() {
    return knex.schema.createTable('teams', (team) => {
      team.increments('id')
      team.string('name')
      team.string('joinCode').unique()
    })
  })
};

exports.down = function(knex, Promise) {
  return knex.schema.dropTableIfExists('users').then(() => {
  return knex.schema.dropTableIfExists('teams')
  })
};
