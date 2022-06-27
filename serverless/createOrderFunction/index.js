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
        userDropPointLat = orderRequest.user_drop_point_lat;
        userDropPointLng = orderRequest.user_drop_point_lng;

        console.log('firebaseFirestore');

        offersCollection.doc(orderRequest.offer_id).get().then(async (doc) => {
            console.log('offerSnapshot');
            const currentDate = Date.now();
            const orderId = uuid.v1();
            const offerDocument = doc.data();

            console.log('offerDocument : ', offerDocument);

            var requestQuantity = parseInt(orderRequest.count);
            var counter = parseInt(offerDocument.count);
            var availableQuantity = parseInt(offerDocument.max_count) - counter;

            console.log('routeQuantity <= availableQuantity : ', requestQuantity <= availableQuantity);

            if (requestQuantity <= availableQuantity) {
                // STATUS 
                // Esperando -1, enCarretera 2 , Completado 1, Cancelado 0
                const newOfferCount = counter + requestQuantity;
                var newStatus = { state_id: '-1', status_description: 'Esperando', }
                if (newOfferCount == availableQuantity) {
                    newStatus.state_id = '2';
                    newStatus.status_description = 'En Carretera';
                }

                // Update offer
                var newData = { count: newOfferCount, updated_at: currentDate };

                var clientInformation = {
                    userId: orderRequest.user_id,
                    orderId: orderId,
                    userToken: "ASCASVAS1wewq122",
                    fullName: orderRequest.user_name,
                    avatar: "https://upload.wikimedia.org/wikipedia/commons/f/f4/User_Avatar_2.png",
                    pickPointLat: orderRequest.user_pick_point_lat,
                    pickPointLng: orderRequest.user_pick_point_lng,
                    dropPointLat: orderRequest.user_drop_point_lat,
                    dropPointLng: orderRequest.user_drop_point_lng,
                }

                var way_points = JSON.parse(offerDocument.way_points);
                way_points.push(`${userPickPointLat}, ${userPickPointLng} `);
                newData.way_points = JSON.stringify(way_points);

                var clientsInformation = JSON.parse(offerDocument.orders);
                clientsInformation.push(clientInformation);
                newData.orders = JSON.stringify(clientsInformation);

                offersCollection.doc(orderRequest.offer_id).update({ ...newData, ...newStatus, });

                const orderDocument = {
                    ...orderRequest, ...{
                        id: orderId,
                        orderId: orderId,
                        offer_way_points: newData.way_points,
                        updated_at: currentDate,
                    }
                }

                ordersCollection.doc(orderId).set(orderDocument).then(() => {
                    console.log("Document written with ID: ", orderId);
                    // Return the offer updated.
                    console.log('------------------------------------------------------');
                    console.log('orderDocument : ', orderDocument);
                    resolve(orderDocument);
                    if (newStatus.state_id == '2') {
                        // TODO: Automatic init driver, send notification to driver to start the trip.
                        console.log('// TODO: send notification to user and driver, that the offer is "en carretera"');
                    }
                }).catch((error) => {
                    console.error("Error adding document: ", error);
                    reject(error);
                });
            } else {
                reject('Not enough quantity offer');
            }
        });
    });
};
