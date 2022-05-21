const admin = require("firebase-admin");
const serviceAccount = require("./pickpointer-firebase-adminsdk-kador-cbb28cea76.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

exports.handler = (event, context, callback) => {
    // Do whatever you want to do with firestore
    firebaseFirestore = admin.firestore();

    firebaseFirestore.collection("c_orders").add({
        name: "John Doe",
        email: "any",
        date: new Date(),
    });
};
