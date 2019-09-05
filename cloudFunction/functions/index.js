const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const fcm = admin.messaging();

// Listens for Love(Likes) state added to /loveRiddles/:loveId/original and 
// increase/decrease the counter of /riddles/:riddleId/loves
exports.manageLoveCounter = functions.firestore.document('loveRiddles/{loveId}')
    .onWrite((snapshot, context) => {
        const newValue = snapshot.after.data();

        //Grab the riddleId of the created loveRiddles
        const riddleId = newValue.riddleId;

        //Document referent of the current Love(Like) riddle
        const firestore = admin.firestore();
        var docRef = firestore.collection('riddles').doc(riddleId);

        //Get the LoveRiddles state field value
        const state = newValue.state;

        if (state === true) {
            //Increment the value of the referent Riddle by 1
            return docRef.update({ 'counter.loves': admin.firestore.FieldValue.increment(1) });

        } else {
            //Decrement the value of the referent Riddle by -1
            return docRef.update({ 'counter.loves': admin.firestore.FieldValue.increment(-1) });
        }
    });

//Listen to Comment create and increase the counter of /riddles/::riddleId/comments
exports.manageCommentCounter = functions.firestore.document('riddles/{riddleId}/comments/{commentId}')
    .onCreate((snapshot, context) => {

        const firestore = admin.firestore();
        var docRef = firestore.collection('riddles').doc(context.params.riddleId);

        return docRef.update({ 'counter.comments': admin.firestore.FieldValue.increment(1) });

    });

//* SOLVED BY*//
//Listen to solvedby subcollection CREATE to increment the solveby RIDDLE counter by 1
//Also, assign the corresponding score for the user at the owner of the riddle
exports.manageSolvedBy = functions.firestore.document('riddles/{riddleId}/solvedBy/{solvedById}').onCreate((snapshot, context) => {
    //ID of the user that solved the riddle
    const userSolved = context.params.solvedById
    //ID of the riddle owner
    const ownerId = snapshot.data().ownerId;

    const firestore = admin.firestore();
    var ref = firestore.collection('riddles').doc(context.params.riddleId);

    //Increment the solvedBy counter
    return ref.update({ 'counter.solvedBy': admin.firestore.FieldValue.increment(1) })
        .then(_ => {
            return ref.get();
        })
        .then(result => {

            //Get the number of users that has solved it.
            var solvedBy = result.data().counter.solvedBy;

            var score = 1;
            console.log('Solved by value: ', solvedBy);
            //Assign a score depending on the number of the user who already solved the riddle
            switch (solvedBy) {
                case 1:
                    score = 10;
                    break;
                case 2:
                    score = 9;
                    break;
                case 3:
                    score = 8;
                    break;
                case 4:
                    score = 7;
                    break;
                case 5:
                    score = 6;
                    break;
                case 6:
                    score = 5;
                    break;
                case 7:
                    score = 4;
                    break;
                case 8:
                    score = 3;
                    break;
                case 9:
                    score = 2;
                    break;
                default:
                    score = 1;
            }

            var ref = firestore.collection('users').doc(ownerId).collection('rankings').doc(userSolved);
            return ref.update({ 'updateDate': context.timestamp, 'score': admin.firestore.FieldValue.increment(score) })
                .catch(_ => {
                    //? I do not think this is the best approach for this task.
                    return ref.set({ 'updateDate': context.timestamp, 'score': admin.firestore.FieldValue.increment(score) })
                });
        }).catch(error => console.log('Error: ', error));



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

//Listen to the User update, in order to update each riddles and comments (photosURL and displayName)
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

        //Get all riddles where user.uid == userId
        var userRiddles = firestore.collection('riddles').where('user.uid', '==', userId).get();
        userRiddles.then(querySnapshot => {
            //Update each riddle photo
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

//* FCM *//

//Listen to love(Likes) to notificate a user
exports.notifyLove = functions.firestore.document('loveRiddles/{docId}')
    .onCreate((snapshot, context) => {

        const document = snapshot.data();
        //Document referent of the current Love(Like) riddle
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

