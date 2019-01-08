import React from "react";
import { NavLink } from "react-router-dom";
import { connect } from "react-redux";
import { fetchUsers, fetchTeams } from "../actions";

class NavMenu extends React.Component {
    componentDidMount() {
        this.props.fetchUsers();
        this.props.fetchTeams();
    }

    render() {
        if (this.props.fetchingUsers || this.props.fetchingTeams) {
            return <h1>Just a moment...</h1>
        }
        if (this.props.teams[0] === undefined) {
            return (
                <div>
                    <NavLink to="/my-profile">My Profile</NavLink>
                    <NavLink to="/settings">Settings</NavLink>
                </div>
            )
        } else {
            return (
                <div>
                    <NavLink to="/my-profile">My Profile</NavLink>
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