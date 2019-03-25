import firebase from 'firebase'
import {config} from './Sensative/apiKey'

firebase.initializeApp(config);

let auth = firebase.auth()
let db = firebase.firestore()

let storage = firebase.storage();

console.log(config.apiKey)

export {auth, config, db, storage}