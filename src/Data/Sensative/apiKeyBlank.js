import firebase from 'firebase'

const config = {
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

export default {config}