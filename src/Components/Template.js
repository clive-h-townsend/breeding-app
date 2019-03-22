import React from 'react'

import * as SDiv from './StyledComponents/Divs'
import * as SInput from './StyledComponents/Inputs'
import * as SButton from './StyledComponents/Buttons'

import {db} from '../Data/Fire'
import {GoogleAnalytics} from '../Data/GA'

class PageTemplate extends React.Component {

    state = {

    }

    componentDidMount() {

        GoogleAnalytics('/template-url')

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
                Template Text
            </div>
        )
    }

}

export default PageTemplate;