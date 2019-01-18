import React from 'react';
import { NavLink } from "react-router-dom";
import auth from '../Auth/Auth'
import "./TopNav.css"

const TopNav = props => {
    return (
        <div className="top-nav">
            <div className="left">
                <NavLink to="/home">Home</NavLink>
                <p>></p>
                <p>{props.pageName}</p>
            </div>
            <div className="right">
                <button onClick={auth.signOut}>Sign Our</button>
            </div>
            </div>
            )
        }

        // <NavLink to="/sign-out">Sign Out</NavLink>
export default TopNav;