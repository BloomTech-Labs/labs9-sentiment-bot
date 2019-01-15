import React from 'react';
import { Navlink } from 'react-router-dom';

const SignedOutLinks = () => {
  return (
    <ul className="right">
      <li><NavLink to='/'>Signup</NavLink></li>
      <li><NavLink to='/'>Login</NavLink></li>
      
    </ul>
  )
}

export default SignedOutLinks