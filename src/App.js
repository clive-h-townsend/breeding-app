import React, { Component } from 'react';
import './App.css';

import {BrowserRouter as Router, Route} from 'react-router-dom'



import {auth, db} from './Data/Fire'

import Home from './Components/Home'
import Account from './Components/Account'
import Login from './Components/Login'
import Manager from './Components/Manager'


import * as SHeader from './Components/StyledComponents/Header'


class App extends Component {

  state = {
    userData: null,
    isSignedIn: false,
    isAdmin: false,
    isLoading: true,
  }

  componentDidMount() {    

    
    auth.onAuthStateChanged(user => {
      
      
      this.setState({isSignedIn: !!user, userData: user})

      db.collection('users').doc(user.uid).get().then(doc => {

        if (!doc.exists) {
          db.collection('users').doc(user.uid).set({
            displayName: user.displayName,
            email: user.email,
            phone: user.phoneNumber,
            photoURL: user.photoURL,
            onBoarding: 1,
          }, {merge: true})
        } else {

          if (doc.data().admin) {

              this.setState({isAdmin: doc.data().admin})

            }
        }
      })
    })

    
  }

  performSignOut = () => {

    auth.signOut()

  }


  render() {

    const HomeURL = '/'
    const AccountURL = '/account'
    const LoginURL = '/login'
    const ManagerURL = '/herd-manager'
    
    if (!!this.state.userData && this.state.isAdmin) {

      return (
        
        <Router>
          <div>
            <SHeader.NavBar>
              
                
                  <SHeader.HeaderLink to={HomeURL}>Home</SHeader.HeaderLink >
                  <SHeader.HeaderLink to={ManagerURL} >Manager</SHeader.HeaderLink>
               
                  <SHeader.LogoutButton onClick={()=>auth.signOut()}>Sign Out</SHeader.LogoutButton>

                  
                
            </SHeader.NavBar>

            <Route path={HomeURL} exact component={Home} />
            <Route path={AccountURL} exact component={Account} />
            <Route path={ManagerURL} exact component={Manager} />
            {/* <Route path="/posts/:id"  component={ShowPost} /> */}

          </div>
        </Router>
      )
    } else if (!!this.state.userData) {
      return (
        <Router>
          <div>
            <SHeader.NavBar>
              
                  <SHeader.HeaderLink to={HomeURL}>Home</SHeader.HeaderLink >
                  <SHeader.HeaderLink to={ManagerURL}>Manager</SHeader.HeaderLink>
                  <SHeader.HeaderLink  to={AccountURL}>Account</SHeader.HeaderLink >

                  <SHeader.LogoutButton onClick={()=>auth.signOut()}>Sign Out</SHeader.LogoutButton>

                  
                
            </SHeader.NavBar>

            <Route path={HomeURL} exact component={Home} />
            <Route path={AccountURL} exact component={Account} />
            <Route path={ManagerURL} exact component={Manager} />
            {/* <Route path="/posts/:id" component={ShowPost} /> */}

          </div>
        </Router>
      )
    } else {
      return (
        <div>
          
          <Router>
          <div>
            <SHeader.NavBar>
              
                  <center>
                    <SHeader.HeaderLink to={HomeURL}>Home</SHeader.HeaderLink >
                    <SHeader.HeaderLink to={LoginURL}>Login</SHeader.HeaderLink>
                    
                  </center>
                
            </SHeader.NavBar>

            <Route path={HomeURL} exact component={Home} />
            <Route path={LoginURL} exact component={Login} />

          </div>
        </Router>
        </div>

      )
    }


  }
}

export default App;
