import React from 'react'

import {auth, config} from '../Data/Fire'

import {GoogleAnalytics} from '../Data/GA'

import StyledFirebaseAuth from 'react-firebaseui/StyledFirebaseAuth';

class Login extends React.Component {

    state = {

    }

    componentDidMount() {

        GoogleAnalytics('/login')

    }

    handleChange = (event) => {
        
        this.setState({[event.target.name]: event.target.value})
    }

    handleClick = () => {

        alert('You have clicked')

    }

    render() {
        return (
            <div>
                
                <StyledFirebaseAuth uiConfig={config} firebaseAuth={auth}/>
            </div>
        )
    }

}

export default Login;