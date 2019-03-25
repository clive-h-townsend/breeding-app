import React from 'react'

import {auth, db} from '../Data/Fire'
import {GoogleAnalytics} from '../Data/GA'


import * as SButton from '../Components/StyledComponents/Buttons'
import * as SInput from '../Components/StyledComponents/Inputs'

class Manager extends React.Component {

    state = { 
        showHerdForm: false,
        showAnimalForm: false,
        herdName: '', 
        animalRegNumber: '',
        herds: [], 
        animals: []
    }

    componentDidMount() {

        GoogleAnalytics('/herd-manager')

        db.collection('herds').where('owner', '==', auth.currentUser.uid).onSnapshot(snapshot => {
            let herds = []
            snapshot.forEach(doc => {
                herds.push(doc.data())
            })
            this.setState({herds})
        })

        db.collection('animals').where('owner', '==', auth.currentUser.uid).onSnapshot(snapshot => {
            let animals = []
            snapshot.forEach(doc => {
                animals.push(doc.data())
            })
            this.setState({animals})
        })

        

    }

    addHerd = () => {

        let herdObject = {
            herdName: this.state.herdName,
            owner: auth.currentUser.uid
        }

        db.collection('herds').add(herdObject)

        this.setState({herdName: '', showHerdForm: false})

    }

    addAnimal = () => {

        let animalObject = {
            animalRegNumber: this.state.animalRegNumber,
            owner: auth.currentUser.uid
        }

        db.collection('animals').add(animalObject)

        this.setState({animalRegNumber: '', showAnimalForm: false})

    }

    handleChange = (event) => {
        
        this.setState({[event.target.name]: event.target.value})
    }
    

    render() {

        console.log(this.state.herds)

        let herdForm = (
            <div>
                <SInput.Standard name="herdName" onChange={this.handleChange} value={this.state.herdName} />
                <SButton.Standard onClick={()=>this.addHerd()}>Save</SButton.Standard>
            </div>
        )

        let animalForm = (
            <div>
                <SInput.Standard name="animalRegNumber" onChange={this.handleChange} value={this.state.animalRegNumber} />
                <SButton.Standard onClick={()=>this.addAnimal()}>Save</SButton.Standard>
            </div>
        )
    


        let herdList = (
            <div>
                {this.state.herds.map(herd=> {
                    return (
                        <div>{herd.herdName}</div>
                    )
                })}
            </div>
        )
        let animalList = (
            <div>
                {this.state.animals.map(animal=> {
                    return (
                        <div>{animal.animalRegNumber}</div>
                    )
                })}
            </div>
        )

        return (
            <div>
                <center>
                    {herdList}
                    {animalList}

                    {this.state.showHerdForm ? herdForm :  <SButton.Standard onClick={()=>this.setState({showHerdForm: true})}>Add Herd</SButton.Standard>}
                    {this.state.showAnimalForm ? animalForm :  <SButton.Standard onClick={()=>this.setState({showAnimalForm: true})}>Add Animal</SButton.Standard>}
                   


                </center>
                
            </div>
        )
    }
}

export default Manager