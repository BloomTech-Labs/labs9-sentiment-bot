import React, { Component } from 'react';
// import Button from '@material-ui/core/Button';
import { Redirect, Route, Router } from 'react-router-dom';
import UserProfile from "./components/UserProfile";
import { oAuthFlow } from './actions'

import auth from './Auth/Auth'

class App extends Component {

  loginHandler = (event) => {
    event.preventDefault()
    auth.signIn()
  }
  render() {
    return (
      <div>

        <button onClick={this.loginHandler} >Login</button>
        <Route path="/profile" render={props => (
          !auth.isAuthenticated() ? (
            <Redirect to="/" />
          ): (
            <UserProfile auth={auth} {...props} />
          )
        )} />
      </div>
    );
  }
}

export default App;