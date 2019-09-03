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
    .onCreate((snapshot, context) => {

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

//Listen to the User update, in order to update each ridlles and comments (photosURL and displayName)
exports.updateUser = functions.firestore.document('users/{userId}').onUpdate((change, context) => {
    const firestore = admin.firestore();
    //Get new/old user data
    const newData = change.after.data();
    const oldData = change.before.data();

    //Get the userId
    var userId = context.params.userId;

    //User OBJ to be update if their property channged
    var newUser = {
        'user': {
            'displayName': oldData.displayName,
            'photoURL': oldData.photoURL,
            'uid': userId,
        }
    };

    if (newData.displayName !== null) {
        newUser.user.displayName = newData.displayName;
    }
    if (newData.photoURL !== null) {
        newUser.user.photoURL = newData.photoURL;
    }

    if (oldData.displayName !== newData.displayName || oldData.photoURL !== newData.photoURL) {
        var promises = []

        //Get all ridlles where user.uid == userId
        var userRidlles = firestore.collection('ridlles').where('user.uid', '==', userId).get();
        userRidlles.then(querySnapshot => {
            //Update each ridlle photo
            querySnapshot.docs.forEach(documentSnapshot => {
                promises.join(documentSnapshot.ref.update(newUser));
            })
            return null;
        }).catch(error => console.log('Error trying to update: ', error));


        //Get all comments where user.uid == userId
        var userComments = firestore.collectionGroup('comments').where('user.uid', '==', userId).get();
        userComments.then(querySnapshot => {
            querySnapshot.docs.forEach(document => {
                //Update each comment by user
                promises.join(document.ref.update(newUser));
            });
            return null;
        }).catch(error => console.log('Error trying to update: ', error));

        return Promise.all(promises);

    }

    return null;
});


