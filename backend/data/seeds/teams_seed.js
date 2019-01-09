const faker = require('faker')

// number of mock team entries that will be created
const numTeams = 50;
const numUsers = require('./users_seed').numUsers;

exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('teams').del()
    .then(function () {

      const teams = Array.from({length: numTeams}, generateTeam)
      // Inserts seed entries
      return knex('teams').insert(teams);
    });
};

// returns an object with fake team data
// meant to be passed to a map function
function generateTeam(v, id) {
  //Team Attributes
  var teamName = faker.lorem.word();

  return({
      "id": id,
      "name": teamName,
      "joinCode": getRandomFiveDigitCode(),
  });
}

function getRandomFiveDigitCode() {
  return Math.floor(Math.random()*90000) + 10000;
}