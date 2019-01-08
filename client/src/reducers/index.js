import { combineReducers } from "redux";
import { userReducer as users } from "./userReducer";
import { teamReducer as teams } from "./teamReducer";

export default combineReducers({
    users, teams
});