import React from 'react'

import {auth} from '../Data/Fire'
import {GoogleAnalytics} from '../Data/GA'

import * as SImg from '../Components/StyledComponents/Images'

class Account extends React.Component {

    state = {
        userData: auth.currentUser, 
      
    }

    componentDidMount() {

        GoogleAnalytics('/account')

    }

    

    render() {


        return (
            <div>
                <center>
                    <h1>
                        Hello {this.state.userData.displayName}
                    </h1>
                    <SImg.LargeAvatar src={this.state.userData.photoURL} alt="profile-avatar" ></SImg.LargeAvatar>
                    <p>Registered Email: {this.state.userData.email}</p>


                </center>
                
            </div>
        )
    }
}

export default Account