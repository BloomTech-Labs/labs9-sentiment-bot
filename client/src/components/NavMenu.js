import React from "react";
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
                    <p>My Profile</p>
                    <p>Settings</p>
                </div>
            )
        } else {
            return (
                <div>
                    <p>My Profile</p>
                    <p>My Team</p>
                    <p>Survey</p>
                    <p>Reports</p>
                    <p>Settings</p>
                    <p>Billing</p>
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