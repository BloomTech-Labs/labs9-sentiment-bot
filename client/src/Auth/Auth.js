import auth0 from 'auth0-js'

class Auth {
  auth0 = new auth0.WebAuth({
    domain: 'feelzy.auth0.com',
    clientID: 'CXO6wkCUgWBSmBw30RNA70AGn9QfKDrE',
    redirectUri: 'http://localhost:3000/callback',
    responseType: 'token id_token',
    scope: 'openid'
  })

  getProfile = () => this.profile;

  getIdToken = () => this.idToken;

  isAuthenticated = () => (
    new Date().getTime() < this.expiresAt
  );

  signIn = () => this.auth0.authorize();

  handleAuthentication = () => {
    return new Promise((resolve, reject) => {
      this.auth0.parseHash((err, authResult) => {
        if (err) return reject(err);
        if (!authResult || !authResult.idToken) {
          return reject(err);
        }
        this.setSession(authResult);
        resolve();
      });
    });
  }

  setSession = (authResult) => {
    this.idToken = authResult.idToken;
    this.profile = authResult.idTokenPayload;
    // set the time that the id token will expire at
    this.expiresAt = authResult.idTokenPayload.exp * 1000;
  }

  signOut = () => {
    this.auth0.logout({
      returnTo: 'http://localhost:3000',
      clientID: 'CXO6wkCUgWBSmBw30RNA70AGn9QfKDrE',
    });
  }

  silentAuth() {
    return new Promise((resolve, reject) => {
      this.auth0.checkSession({}, (err, authResult) => {
        if (err) return reject(err);
        this.setSession(authResult);
        resolve();
      });
    });
  }
}

const auth0Client = new Auth();

export default auth0Client;