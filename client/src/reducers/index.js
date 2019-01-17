import { combineReducers } from "redux";
import { userReducer as users } from "./userReducer";
import { teamReducer as teams } from "./teamReducer";
import { authReducer as auth } from "./authReducers";

export default combineReducers({
    users, teams, auth
});