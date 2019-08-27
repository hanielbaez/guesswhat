const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

//TODO: Delete all functions at Cloud Functions

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
// Listens for Love(Likes) state added to /loveRidlles/:loveId/original and 
// increase/decrease the counter of /ridlles/:ridlleId/lovesCounter
exports.manageLoveCounter = functions.firestore.document('loveRidlles/{loveId}')
    .onWrite((snapshot, context) => {
        const newValue = snapshot.after.data();
        
        //Grab the ridlleId of the created loveRidlles
        const ridlleId = newValue.ridlleId;

        //Document referent of the current Love(Like) ridlle
        const firestore = admin.firestore();
        var docRef = firestore.collection('ridlles').doc(ridlleId);

        //Get the LoveRidlles state field value
        const state = newValue.state;

        if (state === true) {
            //Increment the value of the referent Ridlle by 1
            return docRef.update({ 'counter.loveCounter': admin.firestore.FieldValue.increment(1) });

        } else {
            //Decrement the value of the referent Ridlle by -1
            return docRef.update({ 'counter.loveCounter': admin.firestore.FieldValue.increment(-1) });
        }
    });

//Listen to Comment create and increase the counter of /ridlles/::ridlleId/commentCounter
exports.manageCommentCounter = functions.firestore.document('ridlles/{ridlleId}/comments/{commentId}')
    .onWrite((snapshot, context) => {

        const firestore = admin.firestore();
        var docRef = firestore.collection('ridlles').doc(context.params.ridlleId);

        return docRef.update({ 'counter.commentCounter': admin.firestore.FieldValue.increment(1) });

    });

