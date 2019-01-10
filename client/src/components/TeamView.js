import React from "react";
import { connect } from "react-redux";
import "./TeamView.css";

class TeamView extends React.Component {
    
    render() {
        // use if you need to test or edit the "no team" view
        // this.props.teams[0] = undefined;
        if (this.props.teams[0] === undefined) {
            return (
                <div className="no-team">
                    <p>You're not on a team yet</p>
                    <div className="join-team">
                        <div className="button-wrapper">
                            <button>Join a Team</button>
                            <p>or</p>
                            <button>Create a Team</button>
                        </div>
                    </div>
                </div>
            );
        } else {
            return (
                <div className="team-manager">
                    <p>{this.props.teams[0].teamName}</p>
                    <div className="timeline">
                        {/* insert feelings timeline code here */}
                    </div>
                </div>
                )
        }
    }
}

const mapStateToProps = state => {
    return {
        teams: state.teams.teams,
        fetchingTeams: state.teams.fetchingTeams,
    }
}

export default connect(
    mapStateToProps
)(TeamView);