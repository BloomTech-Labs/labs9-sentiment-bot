import React, { Component } from 'react';
// import Button from '@material-ui/core/Button';
import { Redirect, Route, Router } from 'react-router-dom';
import UserProfile from "./components/UserProfile";
import { oAuthFlow } from './actions'
import axios from 'axios'

import auth from './Auth/Auth'

const getData = async () => {
  const users = await axios.get('feelzy-api.heroku.com/api/users')
  return users
}

const handleAuthentication = (props) => {
  if (/access_token|id_token|error/.test(props.location.hash)) {
    auth.handleAuthentication(props).then(data => {
      console.log(data)
    }).catch(err => {
      console.log(err)
    });
  }
}

class App extends Component {

  loginHandler = (event) => {
    event.preventDefault()
    auth.signIn()
  }

  componentWillMount() {
    const users = getData()
    this.setState(users)
  }
  render() {
    return (
      <div>

        <button onClick={this.loginHandler} >Login</button>
        <Route path="/profile" render={props => {
          handleAuthentication(props).then(data => {
            console.log(data)
          }).catch(err => {
            console.log(err)
          });
          return (
            !auth.isAuthenticated() ? (
              <Redirect to="/" />
            ) : (
                <UserProfile auth={auth} {...props} />
              )
          )
        }
        } />
      </div>
    );
  }
}

export default App;