const admin = require("firebase-admin");
const serviceAccount = require("./pickpointer-firebase-adminsdk-kador-cbb28cea76.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

exports.handler = (event, context, callback) => {
    // Do whatever you want to do with firestore
    return new Promise((resolve, reject) => {
        console.log('event', event);

        firebaseFirestore = admin.firestore();

        console.log('firebaseFirestore');

        firebaseFirestore.collection("c_orders").add({
            name: "John Doe",
            email: "any",
            date: new Date(),
        }).then(function (docRef) {
            console.log("Document written with ID: ", docRef.id);
            resolve(
                {
                    id: `${docRef.id}`,
                    route_id: '1',
                    count: '1',
                    max_count: '3',
                    price: '12',
                    start_lat: '-12.123276353363956',
                    start_lng: '-76.87233782753958',
                    end_lat: '-12.0552257792263',
                    end_lng: '-76.96429734159008',
                    way_points: '["-12.076121251499771, -76.90765870404498", "-12.071811365487575, -76.95666951452563"]',
                    user_id: '1',
                    user_name: 'John Doe',
                    user_avatar: '',
                    user_car_plate: 'ERWIN-12',
                    user_car_photo: '',
                    user_car_model: 'TIco 24',
                    user_car_color: 'red',
                    user_phone_number: '+1 123 456 7890',
                    user_rank: '5',
                    updated_at: '2020-01-01',
                    created_at: '2020-01-05',
                }
            );
        }).catch(function (error) {
            console.error("Error adding document: ", error);
            reject(error);
        });
    });
};
