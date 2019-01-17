import React from 'react';
import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Button from '@material-ui/core/Button';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';

import auth from '../Auth/Auth'

const styles = {
  root: {
    flexGrow: 1,
  },
  grow: {
    flexGrow: 1,
  },
  menuButton: {
    marginLeft: -12,
    marginRight: 20,
  },
};


const Home = () => {
  loginHandler = (e) => {
    auth.signIn()
  }

  return (
    <div className="container">
      <AppBar >
      <Button color="inherit" onClick={this.loginHandler}>Login</Button> 
      </AppBar>
      <h4 className="center">Home</h4>
      <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Pariatur maxime facilis eius dicta nam ratione, sed expedita suscipit alias vel ipsum, laudantium dolor cum facere non aperiam, et nihil cumque!</p>
    </div>
  )
}

export default Home
