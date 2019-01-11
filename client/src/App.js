import React, { Component } from 'react';
import { Route } from "react-router-dom";
import UserProfile from "./components/UserProfile";


class App extends Component {
  render() {
    return (
      <div>
        <Route path="/" component={UserProfile} />
      </div>
    );
  }
}

export default App;