import * as admin from "firebase-admin";
import * as uuid from "uuid";

admin.initializeApp();

export const handler = (event: any) => {
  return new Promise((resolve, reject) => {
    console.log("createOrderFunction>");
    const firebaseFirestore = admin.firestore();

    const offersCollection = firebaseFirestore.collection("c_offers");
    const ordersCollection = firebaseFirestore.collection("c_orders");

    const orderRequest = event;

    const userPickPointLat = orderRequest.user_pick_point_lat;
    const userPickPointLng = orderRequest.user_pick_point_lng;
    const userDropPointLat = orderRequest.user_drop_point_lat;
    const userDropPointLng = orderRequest.user_drop_point_lng;

    console.log("firebaseFirestore");

    offersCollection
        .doc(orderRequest.offer_id)
        .get()
        .then(async (doc) => {
          console.log("offerSnapshot");
          const currentDate = Date.now();
          const orderId = uuid.v1();
          const offerDocument = doc.data();
          if (!offerDocument) reject(Error("offer not found"));

          console.log("offerDocument : ", offerDocument);

          const requestQuantity = parseInt(orderRequest.count);
          const counter = parseInt(offerDocument!.count);
          const availableQuantity = parseInt(offerDocument!.max_count) - counter;

          console.log("routeQuantity <= availableQuantity : ");
          console.log(requestQuantity <= availableQuantity);

          if (requestQuantity <= availableQuantity) {
          // STATUS
          // Esperando -1, enCarretera 2 , Completado 1, Cancelado 0
            const newOfferCount = counter + requestQuantity;
            const newStatus = {state_id: "-1", status_description: "Esperando"};
            if (newOfferCount == availableQuantity) {
              newStatus.state_id = "2";
              newStatus.status_description = "En Carretera";
            }

            // Update offer
            const newData = {count: newOfferCount, updated_at: currentDate, way_points: "[]", orders: "[]"};

            const clientInformation = {
              userId: orderRequest.user_id,
              orderId: orderId,
              userToken: "ASCASVAS1wewq122",
              fullName: orderRequest.user_name,
              avatar:
              "https://upload.wikimedia.org/wikipedia/commons/f/f4/User_Avatar_2.png",
              pickPointLat: orderRequest.user_pick_point_lat,
              pickPointLng: orderRequest.user_pick_point_lng,
              dropPointLat: orderRequest.user_drop_point_lat,
              dropPointLng: orderRequest.user_drop_point_lng,
            };

            const wayPoints = JSON.parse(offerDocument!.way_points);
            wayPoints.push(`${userPickPointLat}, ${userPickPointLng} `);
            wayPoints.push(`${userDropPointLat}, ${userDropPointLng} `);
            newData.way_points = JSON.stringify(wayPoints);

            const clientsInformation = JSON.parse(offerDocument!.orders);
            clientsInformation.push(clientInformation);
            newData.orders = JSON.stringify(clientsInformation);

            offersCollection
                .doc(orderRequest.offer_id)
                .update({...newData, ...newStatus});

            const orderDocument = {
              ...orderRequest,
              ...{
                id: orderId,
                orderId: orderId,
                offer_way_points: newData.way_points,
                updated_at: currentDate,
              },
            };

            ordersCollection
                .doc(orderId)
                .set(orderDocument)
                .then(() => {
                  console.log("Document written with ID: ", orderId);
                  // Return the offer updated.
                  console.log(
                      "------------------------------------------------------"
                  );
                  console.log("orderDocument : ", orderDocument);
                  resolve(orderDocument);
                  if (newStatus.state_id == "2") {
                    // TODO: Automatic init driver, send notification to driver to start the trip.
                    console.log(
                        "// TODO: send notification to user and driver, that the offer is \"en carretera\""
                    );
                  }
                })
                .catch((error) => {
                  console.error("Error adding document: ", error);
                  reject(error);
                });
          } else {
            reject(Error("Not enough quantity offer"));
          }
        });
  });
};
