import React, { Component } from 'react';
import loading from './loading.svg';
import auth0Client from '../Auth/Auth';
const auth = auth0Client



class Callback extends Component {

  hashCheckHandler = () => {
    console.log(this.props)
    // this.props.handleAuthentication({location})
    this.props.handleAuthentication(this.props).then(data => {
      console.log(data)
    }).catch(err => {
      console.log(err)
    });

  }

  render() {
    const style = {
      position: 'absolute',
      display: 'flex',
      justifyContent: 'center',
      height: '100vh',
      width: '100vw',
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      backgroundColor: 'white',
    }

    // return (
    //   <div style={style}>
    //     <img src={loading} alt="loading"/>
    //     <button onClick={this.props.handleAuthentication}>check hash</button>
    //   backgroundColor: 'white',
    // }

    return (
      <div style={style}>
        <img src={loading} alt="loading"/>
        <button onClick={this.hashCheckHandler}>
          check hash
        </button>
      </div>
    );
  }
}

export default Callback;