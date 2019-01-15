import React from 'react';
import { NavLink } from 'react-router-dom';

const SignedInLinks = () => {
  return (
    <ul className="right">
      <li><NavLink to='/'>Teams</NavLink></li>
      <li><NavLink to='/'>Users</NavLink></li>
      <li><NavLink to='/'>My Profile></NavLink></li>
      <li><NavLink to='/'>Log Out></NavLink></li>
      <li><NavLink to='/' className='btn btn-floating pink lighten-1'>Avatar</NavLink></li>
      
    </ul>
  )
}

export default SignedInLinks