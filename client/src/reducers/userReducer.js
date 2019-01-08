import { FETCHING_USERS, FETCHING_USERS_SUCCESS, FETCHING_USERS_FAILURE } from "../actions"; 

const initialState = {
    fetchingUsers: false,
    users: [],
    error: null
}

export const userReducer = (state = initialState, action) => {
    switch(action.type) {
        case FETCHING_USERS:
            return {...state, fetchingUsers: true};

        case FETCHING_USERS_SUCCESS:
            return {...state, fetchingUsers: false, users: action.payload};

        case FETCHING_USERS_FAILURE:
            return {...state, fetchingUsers: false, error: action.payload};

        default: 
            return state;
    }
}