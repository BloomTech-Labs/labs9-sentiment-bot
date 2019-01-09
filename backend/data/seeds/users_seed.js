const faker = require('faker')

exports.seed = function (knex, Promise) {

  const numUsers = 200;
  function generateUser(v, id) {
    //User Attributes
    var firstName = faker.name.firstName();
    var lastName = faker.name.lastName();
    var email = faker.internet.email();
    var image = faker.image.people();
    return ({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": faker.internet.password()
    });
  }

  // Deletes ALL existing entries
  return knex('users').del()
    .then(function () {
      // creates empty array with length numUsers 
      // and maps over it with faker.js userdata
      const users = Array.from({ length: numUsers }
        , (user, i) => generateUser(user, i))

      // Inserts seed entries
      return knex('users').insert(users);
    });
};
