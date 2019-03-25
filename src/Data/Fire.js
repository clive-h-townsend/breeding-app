import firebase from 'firebase'


// These are straight from firebase. They are backed up
// Don't post 2
let config = {
    signInFlow: 'popup',
    signInOptions: [
        firebase.auth.GoogleAuthProvider.PROVIDER_ID,
        firebase.auth.EmailAuthProvider.PROVIDER_ID,
      ],
      apiKey: "",
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