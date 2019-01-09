const faker = require('faker')

// number of mock user entries that will be created
const numUsers = 501;

exports.seed = function (knex, Promise) {
  // Deletes ALL existing entries
  return knex('users').del()
    .then(function () {

      // creates empty array with length numUsers 
      // and maps over it with faker.js userdata
      const users = Array.from({
        length: numUsers
      }, generateUser)

      // Inserts seed entries
      return knex('users').insert(users);
    });
};

// returns an object with fake user data
// meant to be passed to a map function
function generateUser(v, id) {
  return ({
    "firstName": faker.name.firstName(),
    "lastName": faker.name.lastName(),
    "email": faker.internet.email(),
    "password": faker.internet.password()
  });
}