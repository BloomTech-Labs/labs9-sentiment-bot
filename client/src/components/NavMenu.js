import React from "react";
import { NavLink } from "react-router-dom";
import { connect } from "react-redux";
import { fetchUsers, fetchTeams } from "../actions";
import "./NavMenu.css";

class NavMenu extends React.Component {

    render() {
        // if user has no teams, they will only have access to profile and settings
        // when the teams data model is updated, this will be updated as well
        if (this.props.teams[0] === undefined) {
            return (
                <div className="navigation">
                    <NavLink to="/">My Profile</NavLink>
                    <NavLink to="/settings">Settings</NavLink>
                </div>
            )
        } else {
            return (
                <div className="navigation">
                    <NavLink to="/">My Profile</NavLink>
                    <NavLink to="/my-team">My Team</NavLink>
                    <NavLink to="/new-survey">Survey</NavLink>
                    <NavLink to="/reports">Reports</NavLink>
                    <NavLink to="/settings">Settings</NavLink>
                    <NavLink to="/billing">Billing</NavLink>
                </div>
            );
        }
        
    }
}

const mapStateToProps = state => {
    return {
        users: state.users.users,
        fetchingUsers: state.users.fetchingUsers,
        teams: state.teams.teams,
        fetchingTeams: state.teams.fetchingTeams,
    }
}

export default connect(
    mapStateToProps,
    { fetchUsers, fetchTeams }
)(NavMenu);