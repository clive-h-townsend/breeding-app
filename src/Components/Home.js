import React from 'react'
import {GoogleAnalytics} from '../Data/GA'

class Home extends React.Component {

    componentDidMount() {

        GoogleAnalytics('/home')

    }

    render() {
        
        return (
            <div>
                <center>
                    <h1>
                        Welcome to the Breeding Application! It is for Commercial cattle producers like you
                    </h1>
                    
                </center>
            </div>
        )
    }
}

export default Home;