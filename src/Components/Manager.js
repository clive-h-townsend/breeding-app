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
        animalRegNumbers: '',
        herds: [], 
        animals: [],
        selectedHerd: null,
    }

    componentDidMount() {

        GoogleAnalytics('/herd-manager')

        db.collection('herds').where('owner', '==', auth.currentUser.uid).onSnapshot(snapshot => {
            let herds = []
            snapshot.forEach(doc => {
                this.setState({selectedHerd: doc.id})
                let herdUIDObject = {herdUID: doc.id}
                let herdDataObject = doc.data()
                herds.push({...herdUIDObject, ...herdDataObject})
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

        let animalList = this.state.animalRegNumbers
        animalList = animalList.split(',')
        
   
        
        animalList.forEach(animal=> {
            let animalObject = {
                animalRegNumbers: animal,
                owner: auth.currentUser.uid,
                herd: this.state.selectedHerd,
            }
            db.collection('animals').add(animalObject)
        }) 

        this.setState({animalRegNumbers: '', showAnimalForm: false})

    }

    handleChange = (event) => {
        
        this.setState({[event.target.name]: event.target.value})
        console.log(this.state.selectedHerd)
    }
    

    render() {

        console.log(this.state.herds)

        let herdForm = (
            <div>
                <SInput.Standard name="herdName" onChange={this.handleChange} value={this.state.herdName} />
                <SButton.Standard onClick={()=>this.addHerd()}>Save</SButton.Standard>
            </div>
        )

        let herdDropDown = (
            <div>
                <select name="selectedHerd" onChange={this.handleChange} value={this.state.selectedHerd}>
                    {this.state.herds.map((herd,index) => {
                        if (index === 0) {
                            
                            return (<option value={herd.herdUID}>{herd.herdName}</option>)
                        } else {
                            return (<option value={herd.herdUID}>{herd.herdName}</option>)
                        }
                        
                    })}
                </select>
            </div>
        )

        let animalForm = (
            <div>
                Herd to add into: {herdDropDown}
                <SInput.Standard name="animalRegNumbers" onChange={this.handleChange} value={this.state.animalRegNumbers} />
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
                        <div>{animal.animalRegNumbers}</div>
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
                    {this.state.showAnimalForm ? animalForm :  <SButton.Standard onClick={()=>this.setState({showAnimalForm: true})}>Add Animals</SButton.Standard>}
                    <br />
                
                   


                </center>
                
            </div>
        )
    }
}

export default Manager