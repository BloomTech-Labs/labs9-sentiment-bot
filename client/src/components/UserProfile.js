import React from "react";
import { connect } from "react-redux";
import { fetchUsers, fetchTeams } from "../actions";
import NavMenu from "./NavMenu";
import TopNav from "./TopNav";
import Avatar from "./Avatar";
import "./UserProfile.css";

class UserProfile extends React.Component {
    componentDidMount() {
        this.props.fetchUsers();
        this.props.fetchTeams();
    }

    render() {
        if (this.props.users) {
            return (
                <div className="profile-page">
                    <TopNav pageName="My Profile" />
                    <div className="main-view">
                        <NavMenu />
                        <div className="profile-view">
                            <Avatar imageSrc={this.props.users.image} />
                            <h3>{this.props.users.firstName} {this.props.users.lastName}</h3>
                            <button>Connect to Slack</button>
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