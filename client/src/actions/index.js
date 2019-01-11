import axios from "axios";

const URL = `http://localhost:3000`;

export const FETCHING_USERS = "FETCHING_USERS";
export const FETCHING_USERS_SUCCESS = "FETCHING_USERS_SUCCESS";
export const FETCHING_USERS_FAILURE = "FETCHING_USERS_FAILURE";
export const FETCHING_TEAMS = "FETCHING_TEAMS";
export const FETCHING_TEAMS_SUCCESS = "FETCHING_TEAMS_SUCCESS";
export const FETCHING_TEAMS_FAILURE = "FETCHING_TEAMS_FAILURE";

export const fetchUsers = () => dispatch => {
    dispatch({type: FETCHING_USERS});
    axios
        .get(`https://feelzy-api.herokuapp.com/api/users/1`)
        .then(response => {
            dispatch({type: FETCHING_USERS_SUCCESS, payload: response.data});
        })
        .catch(error => {
            dispatch({ type: FETCHING_USERS_FAILURE, payload: error});
        })
}

export const fetchTeams = () => dispatch => {
    dispatch({type: FETCHING_TEAMS});
    axios
        .get(`${URL}/users/1/teams`)
        .then(response => {
            dispatch({type: FETCHING_TEAMS_SUCCESS, payload: response.data});
        })
        .catch(error => {
            dispatch({ type: FETCHING_TEAMS_FAILURE, payload: error});
        })
}