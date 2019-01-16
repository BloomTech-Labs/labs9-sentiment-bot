import { 
  VERIFYING_USER, 
  USER_VERIFYED, 
  VERIFYING_USER_FAILURE 
} from "../actions"; 

const initialState = {
    verifyingUser: false,
    userVerifyed: false,
    userProfile: {},
    error: null
}

export const authReducer = (state = initialState, action) => {
    switch(action.type) {
        case VERIFYING_USER:
            return {...state, 
              fetchingUsers: true
            };

        case USER_VERIFYED:
            return {...state, 
              fetchingUsers: false, 
              users: action.payload
            };

        case VERIFYING_USER_FAILURE:
            return {...state, 
              fetchingUsers: false, 
              error: action.payload
            };

        default: 
            return state;
    }
}