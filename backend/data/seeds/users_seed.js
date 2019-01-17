const faker = require('faker')

// number of mock entries that will be created
const numUsers = 100;
const numTeams = 50;

exports.seed = function (knex, Promise) {
  // Deletes ALL existing entries
  return knex('users').del()
    .then(function () {

      // creates empty array with length numUsers 
      // and maps over it with faker.js userdata
      const users = Array.from({ length: numUsers }, (v, i) => generateUser(v, i+1))
      const teams = Array.from({ length: numTeams }, (v, i) => generateTeam(v, i+1))
      // Inserts seed entries
      return knex('users').insert(users).then(function () {
        // sqlite3 must have a limit preventing you from inserting more then
        // 199 rows at a time
        // calling insert multiple times this way is a work around
        const users = Array.from({ length: numUsers }, (v, i) => generateUser(v, 1 + i + numUsers))
        return knex('users').insert(users).then(function () {
          const users = Array.from({ length: numUsers }, (v, i) => generateUser(v, 1 + i + numUsers * 2))
          return knex('users').insert(users).then(function () {

          })
        })
      })
        .then(function () {
          // Deletes ALL existing entries
          return knex('teams').del()
            .then(function () {

              return knex('teams').insert(teams)
            })

        })
    });
};

// returns an object with fake user data
// meant to be passed to a map function
function generateUser(v, id) {
  const firstName = faker.name.firstName(),
    lastName = faker.name.lastName(),
    email = faker.internet.email(),
    password = faker.internet.password(),
    imageUrl = faker.image.avatar();
  return ({
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "password": password,
    imageUrl
  });
}

// returns an object with fake team data
// meant to be passed to a map function
function generateTeam(v, id) {
  //Team Attributes
  var teamName = faker.lorem.word();

  return ({
    "id": id,
    "name": teamName,
    "joinCode": getRandomFiveDigitCode(),
  });
}

function getRandomFiveDigitCode() {
  return Math.floor(Math.random() * 90000) + 10000;
}