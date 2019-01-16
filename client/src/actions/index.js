import axios from "axios";

const URL = `http://localhost:3000`;

export const FETCHING_USERS = "FETCHING_USERS";
export const FETCHING_USERS_SUCCESS = "FETCHING_USERS_SUCCESS";
export const FETCHING_USERS_FAILURE = "FETCHING_USERS_FAILURE";
export const FETCHING_TEAMS = "FETCHING_TEAMS";
export const FETCHING_TEAMS_SUCCESS = "FETCHING_TEAMS_SUCCESS";
export const FETCHING_TEAMS_FAILURE = "FETCHING_TEAMS_FAILURE";

export const VERIFYING_USER = 'VERIFYING_USER';
export const USER_VERIFYED = 'USER_VERIFYED';
export const VERIFYING_USER_FAILURE = 'VERIFYING_USER_FAILURE';

export const TEST = 'TEST'

export const testAction = something => dispatch => {
    dispatch({type: TEST, payload: 'another'})
    // return{ 
    //     type: TEST, 
    //     payload: something ? something : 'wasup'
    // }
}

const APIURL = process.env.REACT_APP_API_URL

export const oAuthFlow = oAuthObj => async dispatch => {
    try {
        dispatch({type: VERIFYING_USER})

        const userInApp = await axios.post(
            `${APIURL}/api/oauth`, 
            oAuthObj.profileObj.email
        )

        dispatch({
            type: USER_VERIFYED, 
            payload: userInApp
        })
    } 
    catch (error) {
        dispatch({ 
            type: VERIFYING_USER_FAILURE, 
            payload: error
        })
    }
}

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