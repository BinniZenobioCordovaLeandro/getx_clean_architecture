const admin = require("firebase-admin");
const serviceAccount = require("./pickpointer-firebase-adminsdk-kador-cbb28cea76.json");
const uuid = require('uuid');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

exports.handler = (event, context, callback) => {
    return new Promise(async (resolve, reject) => {
        console.log('createOrderFunction>');
        firebaseFirestore = admin.firestore();

        const offersCollection = firebaseFirestore.collection("c_offers");
        const ordersCollection = firebaseFirestore.collection("c_orders");

        const orderRequest = event;

        userPickPointLat = orderRequest.user_pick_point_lat;
        userPickPointLng = orderRequest.user_pick_point_lng;

        console.log('firebaseFirestore');

        offersCollection.doc(orderRequest.offer_id).get().then(async (doc) => {
            console.log('offerSnapshot');
            const currentDate = new Date();
            const orderId = uuid.v1();
            const offerDocument = doc.data();

            console.log('offerDocument : ', offerDocument);

            var requestQuantity = parseInt(orderRequest.route_quantity);
            var counter = parseInt(offerDocument.count);
            var availableQuantity = parseInt(offerDocument.max_count) - counter;

            console.log('routeQuantity <= availableQuantity : ', requestQuantity <= availableQuantity);

            if (requestQuantity <= availableQuantity) {
                // Update offer
                var newData = { count: `${counter + requestQuantity}`, updated_at: currentDate };

                var clientInformation = {
                    userId: orderRequest.user_id,
                    orderId: orderId,
                    userToken: "ASCASVAS1wewq122",
                    fullName: orderRequest.user_name,
                    avatar: "https://upload.wikimedia.org/wikipedia/commons/f/f4/User_Avatar_2.png",
                    pickPointLat: orderRequest.user_pick_point_lat,
                    pickPointLng: orderRequest.user_pick_point_lng,
                    outPointLat: orderRequest.user_out_point_lat,
                    outPointLng: orderRequest.user_out_point_lng,
                }

                var way_points = JSON.parse(offerDocument.way_points);
                way_points.push(`${userPickPointLat}, ${userPickPointLng} `);
                newData.way_points = JSON.stringify(way_points);

                var clientsInformation = JSON.parse(offerDocument.orders);
                clientsInformation.push(clientInformation);
                newData.orders = JSON.stringify(clientsInformation);

                offersCollection.doc(orderRequest.offer_id).update(newData);

                const orderDocument = {
                    ...orderRequest, ...{
                        id: orderId,
                        way_points: newData.way_points,
                        updated_at: currentDate,
                    }
                }
                ordersCollection.doc(orderId).set(orderDocument).then(() => {
                    console.log("Document written with ID: ", orderId);
                    // Return the offer updated.
                    resolve(orderDocument);
                }).catch((error) => {
                    console.error("Error adding document: ", error);
                    reject(error);
                });
            }
        });
    });
};
