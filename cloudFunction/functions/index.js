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

//* USER *//

//TODO: Send email, when a user is created.

//Listen to create user event of Firebase Auth
exports.createUser = functions.auth.user().onCreate((user) => {
    const newUser = {
        'displayName': user.displayName,
        'biography': '',
        'photoURL': user.photoURL,
        'webSite': '',
        'createdAt': user.metadata.creationTime,
    }
    const private = {
        'email': user.email,
        'sex': '',
    }

    var firestore = admin.firestore();
    return firestore.collection('users').doc(user.uid).set(newUser).then(response => {
        console.log('Response ', response);
        return firestore.collection('users').doc(user.uid).collection('privates').doc().set(private);
    }).catch(error => console.log('Error trying to create a user: ', error));

});

//Listen to the User photo update, in order to update each ridlles with the new user photo
exports.updateUserImage = functions.firestore.document('users/{userId}').onUpdate((change, context) => {
    //Get updated data
    const newPhoto = change.after.data().photoURL;
    var userId = context.params.userId;

    if (newPhoto !== null) {
        const firestore = admin.firestore();
        firestore.collection('ridlles').where('user.uid', '==', userId).get().then(querySnapshot => {
            var promises = []

            //Update each photo
            querySnapshot.docs.forEach(documentSnapshot => {
                promises.join(documentSnapshot.ref.update({ 'user.photoURL': newPhoto }));
            })

            return Promise.all(promises);
        }).catch(error => console.log('Error trying to update: ', error));
    }

    return null;
});

