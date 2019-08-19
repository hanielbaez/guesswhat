const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

//TODO: Delete all functions at Cloud Functions

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
// Listens for Love(Likes) state added to /loveGuesses/:loveId/original and 
// increase/decrease the counter of /guesses/:guessId/lovesCounter
exports.manageLoveCounter = functions.firestore.document('loveGuesses/{loveId}')
    .onWrite((snapshot, context) => {
        //Grab the guessId of the created loveGuesses
        const guessId = context.params.loveId.substring(0, 20);

        //Document referent of the current Love(Loke) guess
        const firestore = admin.firestore();
        var docRef = firestore.collection('guesses').doc(guessId);

        //Get the LoveGuesses state field value
        const newValue = snapshot.after.data();
        const state = newValue.state;

        if (state === true) {
            //Increment the value of the referent Guess by 1
            return docRef.update({ 'counter.loveCounter': admin.firestore.FieldValue.increment(1) });

        } else {
            //Decrement the value of the referent Guess by -1
            return docRef.update({ 'counter.loveCounter': admin.firestore.FieldValue.increment(-1) });
        }
    });

//Listen to Comment create and increase the counter of /guesses/::guessId/commentCounter
exports.manageCommentCounter = functions.firestore.document('guesses/{guessId}/comments/{commentId}')
    .onWrite((snapshot, context) => {

        const firestore = admin.firestore();
        var docRef = firestore.collection('guesses').doc(context.params.guessId);

        return docRef.update({ 'counter.commentCounter': admin.firestore.FieldValue.increment(1) });

    });
