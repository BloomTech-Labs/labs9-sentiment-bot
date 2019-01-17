
exports.up = function(knex, Promise) {
  return knex.schema.createTable('usersOnTeams', (table) => {
    table.increments('id')
    table.integer('users_id').unsigned()
    table.foreign('id', 'users_id').references('users.id')
    // table.integer('teams_id').unsigned()
    // table.foreign('id', 'teams_id').references('teams.id')
    table.boolean('Manager')
    user.timestamps(true, true)
  })
};

exports.down = function(knex, Promise) {
  
};
