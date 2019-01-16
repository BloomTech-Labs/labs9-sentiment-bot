import React, { Component } from 'react';
import Button from '@material-ui/core/Button';
import { Route } from "react-router-dom";
import UserProfile from "./components/UserProfile";
import { oAuthFlow, testAction } from './actions'
import { connect } from "react-redux";
// import auth0 from 'auth0-js'


import { GoogleLogin } from 'react-google-login'


// import auth from './Auth/Auth'
// const auth0auth = new auth0.WebAuth({
//     domain: 'feelzy.auth0.com',
//     clientID: 'CXO6wkCUgWBSmBw30RNA70AGn9QfKDrE',
//     redirectUri: 'http://localhost:3000/callback',
//     responseType: 'token id_token',
//     scope: 'openid'
//   })

// const login = () => {
//     auth0auth.authorize();
//   }

const responseGoogle = (response) => {
  console.log(response)
  testAction({ message: 'a thing' })
  oAuthFlow(response.profileObj)
}

class App extends Component {

  loginHandler = (event) => {
    event.preventDefault()
    console.log('clicked')
    // this.state.dispatch(testAction('dispatched'))
    this.props.testAction('a thing')
    console.log(this.props) 
  }
  componentDidMount() {
    console.log(this.props) 
  }
  componentWillReceiveProps() {
    // this.props.
    console.log(this.props)
  }



  render() {
    return (
      <div>
      <GoogleLogin
      clientId="1094362572223-hpiugks0gl0iajlp9mt76re45rc7k8v0.apps.googleusercontent.com"
      buttonText="Login"
      onSuccess={responseGoogle}
      onFailure={responseGoogle}
    />
        <Button onClick={this.loginHandler} >Login</Button>
        <Route path="/" component={UserProfile} />
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
      state: state
  }
}


export default connect(
  mapStateToProps, {
    testAction, oAuthFlow
  }
)(App);