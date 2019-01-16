import React, { Component } from 'react';
import { Route } from "react-router-dom";
import UserProfile from "./components/UserProfile";
import auth0 from 'auth0-js'
import Button from '@material-ui/core/Button';
// import auth from './Auth/Auth'
const auth0auth = new auth0.WebAuth({
    domain: 'feelzy.auth0.com',
    clientID: 'CXO6wkCUgWBSmBw30RNA70AGn9QfKDrE',
    redirectUri: 'http://localhost:3000/callback',
    responseType: 'token id_token',
    scope: 'openid'
  })

const login = () => {
    auth0auth.authorize();
  }
class App extends Component {

  loginHandler = (event) => {
    event.preventDefault()
    login()
  }
  render() {
    return (
      <div>
        <Button onClick={this.loginHandler} >Login</Button>
        <Route path="/" component={UserProfile} />
      </div>
    );
  }
}

export default App;