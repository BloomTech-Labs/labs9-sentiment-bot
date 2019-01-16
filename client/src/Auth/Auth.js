import auth0 from 'auth0-js'

export default class Auth {
  auth0 = new auth0.WebAuth({
    domain: 'feelzy.auth0.com',
    clientID: 'CXO6wkCUgWBSmBw30RNA70AGn9QfKDrE',
    redirectUri: 'http://localhost:3000/callback',
    responseType: 'token id_token',
    scope: 'openid'
  })

  login() {
    this.auth0.authorize();
  }
}