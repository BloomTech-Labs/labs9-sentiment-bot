import { FETCHING_TEAMS, FETCHING_TEAMS_SUCCESS, FETCHING_TEAMS_FAILURE, TEST } from "../actions"; 

const initialState = {
    fetchingTeams: false,
    teams: [],
    error: null
}

export const teamReducer = (state = initialState, action) => {
    console.log(action.type)
    switch(action.type) {
        case FETCHING_TEAMS:
            return {...state, fetchingTeams: true};

        case FETCHING_TEAMS_SUCCESS:
            return {...state, fetchingTeams: false, teams: [...state.teams, ...action.payload]};

        case FETCHING_TEAMS_FAILURE:
            return {...state, fetchingTeams: false, error: action.payload};

        case TEST:
        console.log(action.payload)
            return{...state,
              test: action.payload ? action.payload : 'a test'
            }

        default: 
            return state;
    }
}