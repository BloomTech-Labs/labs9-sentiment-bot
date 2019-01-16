import { 
  VERIFYING_USER, 
  USER_VERIFYED, 
  VERIFYING_USER_FAILURE 
} from "../actions"; 

const initialState = {
    verifyingUser: false,
    userVerifyed: false,
    verifyingUserFailure: false,
    userProfile: {},
    error: null
}

export const authReducer = (state = initialState, action) => {
  console.log(action.payload)
    switch(action.type) {
        case VERIFYING_USER:
            return {...state, 
              verifyingUser: true
            };

        case USER_VERIFYED:
            return {...state, 
              userVerifyed: false, 
              user: action.payload
            };

        case VERIFYING_USER_FAILURE:
            return {...state, 
              verifyingUserFailure: false, 
              error: action.payload
            };

        default: 
            return state;
    }
}