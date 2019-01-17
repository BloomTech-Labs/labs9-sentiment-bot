import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import auth from '../Auth/Auth'

class Home extends Component {
  login = () => {
    auth.signIn()
  }
  render() {
    const { isAuthenticated } = this.props.auth;
    return (
      <div className="container">
        {
          isAuthenticated() && (
              <h4>
                You are logged in! You can now view your{' '}
                <Link to="profile">profile area</Link>
                .
              </h4>
            )
        }
        {
          !isAuthenticated() && (
              <h4>
                You are not logged in! Please{' '}
                <a
                  style={{ cursor: 'pointer' }}
                  onClick={this.login}
                >
                  Log In
                </a>
                {' '}to continue.
              </h4>
            )
        }
      </div>
    );
  }
}

export default Home;