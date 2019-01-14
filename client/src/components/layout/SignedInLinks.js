import React from 'react';
import { NavLink } from 'react-router-dom';

const SignedInLinks = () => {
  return (
    <ul className="right">
      <li><NavLink to='/'>Teams</NavLink></li>
      <li><NavLink to='/'>Users</NavLink></li>
      <li><NavLink to='/'>MyProfile></NavLink></li>
    </ul>
  )
}

export default SignedInLinks