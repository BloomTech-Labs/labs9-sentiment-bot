import React from "react";
import { connect } from "react-redux";
import { fetchUsers, fetchTeams } from "../actions";
import NavMenu from "./NavMenu";
import TopNav from "./TopNav";
import Avatar from "./Avatar";
import TeamView from "./TeamView";
import "./UserProfile.css";

class UserProfile extends React.Component {
    componentDidMount() {
        this.props.fetchUsers();
        this.props.fetchTeams();
    }

    render() {
        // if the user has been retrieved and the teams data exists, render profile
        if (this.props.users[0] && this.props.teams) {
            return (
                <div className="profile-page">
                    <TopNav pageName="My Profile" />
                    <div className="main-view">
                        <NavMenu />
                        <div className="profile-view">
                            <Avatar imageSrc={this.props.users.image} />
                            <h3>{this.props.users[0].firstName} {this.props.users[0].lastName}</h3>
                            <div>Connect to Slack</div>
                            <TeamView />
                        </div>
                    </div>
                     
                </div>
            );
        } else {
            return <h1>Loading...</h1>
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