import { FETCHING_TEAMS, FETCHING_TEAMS_SUCCESS, FETCHING_TEAMS_FAILURE } from "../actions"; 

const initialState = {
    fetchingTeams: false,
    teams: [],
    error: null
}

export const teamReducer = (state = initialState, action) => {
    switch(action.type) {
        case FETCHING_TEAMS:
            return {...state, fetchingTeams: true};

        case FETCHING_TEAMS_SUCCESS:
            return {...state, fetchingTeams: false, teams: [...state.teams, ...action.payload]};

        case FETCHING_TEAMS_FAILURE:
            return {...state, fetchingTeams: false, error: action.payload};

        default: 
            return state;
    }
}