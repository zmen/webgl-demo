import React from 'react';
import { HashRouter as Router, NavLink } from 'react-router-dom';
import Routes from './routes';
import './App.css';

function App() {
  return (
    <div className="container">
      <Router>
        <ul className="navbar">
          <li>
            <NavLink exact activeClassName="active" to="/">
              Home
            </NavLink>
          </li>
          <li>
            <NavLink  activeClassName="active"to="/paint">
              Paint Demo
            </NavLink>
          </li>
          <li>
            <NavLink activeClassName="active" to="/moma01">
              Moma01 Demo
            </NavLink>
          </li>
          <li>
            <NavLink activeClassName="active" to="/moma02">
              Moma02 Demo
            </NavLink>
          </li>
          <li>
            <NavLink activeClassName="active" to="/glich">
              Glich Demo
            </NavLink>
          </li>
          <li>
            <NavLink activeClassName="active" to="/mosaic">
              Mosaic Demo
            </NavLink>
          </li>
          <li>
            <NavLink activeClassName="active" to="/splash">
              Splash Demo
            </NavLink>
          </li>
          <li>
            <NavLink activeClassName="active" to="/layout">
              Layout Demo
            </NavLink>
          </li>
          <li>
            <NavLink activeClassName="active" to="/three">
              Three-js Demo
            </NavLink>
          </li>
        </ul>
        <div className="content">
          <div className="demo">
            <Routes />
          </div>
        </div>
      </Router>
    </div>
  );
}

export default App;
