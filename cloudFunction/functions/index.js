const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const fcm = admin.messaging();



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

exports.notifyLove = functions.firestore.document('loveRidlles/{docId}')
    .onCreate((snapshot, context) => {

        const document = snapshot.data();
        //Document referent of the current Love(Like) ridlle
        const firestore = admin.firestore();

        //Get the tokes of the corresponding user
        firestore.collection('users').doc(document.userId)
            .collection('tokens').get().then(query => {
                const tokens = [];
                query.forEach(doc => {
                    tokens.push(doc.id);
                });
                console.log(tokens);

                const payload = {
                    notification: {
                        title: 'Someone love you riddle ♥️',
                        body: `Tap here to check it out!`,
                        click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                };

                return fcm.sendToDevice(tokens, payload);

            }).catch(error => console.log('Error sending notification: ', error));
        return null;
    });

//Listen to Comment create and increase the counter of /ridlles/::ridlleId/commentCounter
exports.manageCommentCounter = functions.firestore.document('ridlles/{ridlleId}/comments/{commentId}')
    .onWrite((snapshot, context) => {

        const firestore = admin.firestore();
        var docRef = firestore.collection('ridlles').doc(context.params.ridlleId);

        return docRef.update({ 'counter.commentCounter': admin.firestore.FieldValue.increment(1) });

    });

