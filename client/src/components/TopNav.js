import React from 'react';
import { NavLink } from "react-router-dom";
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
                <NavLink to="/sign-out">Sign Out</NavLink>
            </div>
        </div>
    )
}

export default TopNav;