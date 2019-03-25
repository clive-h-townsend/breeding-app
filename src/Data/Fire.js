import firebase from 'firebase'
import siteAPIKey from './Sensative/apiKey'

// These are straight from firebase. They are backed up

let config = {
    signInFlow: 'popup',
    signInOptions: [
        firebase.auth.GoogleAuthProvider.PROVIDER_ID,
        firebase.auth.EmailAuthProvider.PROVIDER_ID,
      ],
      apiKey: siteAPIKey,
      authDomain: "breeding-app.firebaseapp.com",
      databaseURL: "https://breeding-app.firebaseio.com",
      projectId: "breeding-app",
      storageBucket: "breeding-app.appspot.com",
      messagingSenderId: "488922508440",
    
    callbacks: {
        // Avoid redirects after sign-in.
        signInSuccessWithAuthResult: () => false
      }
  };



firebase.initializeApp(config);

let auth = firebase.auth()
let db = firebase.firestore()

let storage = firebase.storage();

export {auth, config, db, storage}