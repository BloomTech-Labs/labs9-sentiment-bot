import React from "react";
import { connect } from "react-redux";
import { fetchUsers, fetchTeams } from "../actions";
import NavMenu from "./NavMenu";
import TopNav from "./TopNav";

class UserProfile extends React.Component {
    componentDidMount() {
        this.props.fetchUsers();
        this.props.fetchTeams();
    }

    render() {
        if (this.props.fetchingUsers || this.props.fetchingTeams) {
            return (
                <div className="profile-page">
                    <TopNav pageName="My Profile" />
                    <NavMenu />
                    
                </div>
            )
        }
        if (this.props.teams[0] === undefined) {
            return (
                <div className="profile-page">
                    <TopNav pageName="My Profile" />
                    <NavMenu />
                    
                </div>
            )
        } else {
            return (
                <div className="profile-page">
                    <TopNav pageName="My Profile" />
                    <NavMenu />
                    
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
)(UserProfile);