import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as uuid from "uuid";
import {MessagingPayload} from "firebase-admin/lib/messaging/messaging-api";

admin.initializeApp();

export const handler = (event: any) => {
  return new Promise((resolve, reject) => {
    functions.logger.info("createOrderFunction>");
    const firebaseFirestore = admin.firestore();

    const offersCollection = firebaseFirestore.collection("c_offers");
    const ordersCollection = firebaseFirestore.collection("c_orders");

    const orderRequest = event;

    const userPickPointLat = orderRequest.user_pick_point_lat;
    const userPickPointLng = orderRequest.user_pick_point_lng;
    const userDropPointLat = orderRequest.user_drop_point_lat;
    const userDropPointLng = orderRequest.user_drop_point_lng;

    functions.logger.info("firebaseFirestore");

    offersCollection
        .doc(orderRequest.offer_id)
        .get()
        .then(async (doc: any) => {
          // console.log("offerSnapshot");
          const currentDate = Date.now();
          const orderId = uuid.v1();
          const offerDocument = doc.data();
          if (!offerDocument) reject(Error("offer not found"));

          // console.log("offerDocument : ", offerDocument);

          const requestQuantity = parseInt(orderRequest.count);
          const counter = parseInt(offerDocument!.count);
          const availableQuantity = parseInt(offerDocument!.max_count) - counter;
          const maxCounter = parseInt(offerDocument!.max_count);

          // console.log("routeQuantity <= availableQuantity : ");
          // console.log(requestQuantity <= availableQuantity);

          if (requestQuantity <= availableQuantity) {
          // STATUS
          // Esperando -1, enCarretera 2 , Completado 1, Cancelado 0
            const newOfferCount = counter + requestQuantity;
            const newStatus = {state_id: "-1", status_description: "Esperando"};

            console.log("newOfferCount == max_counter", newOfferCount, " == ", maxCounter);
            if (newOfferCount == maxCounter) {
              newStatus.state_id = "2";
              newStatus.status_description = "En Carretera";
            }

            // Update offer
            const newData = {count: newOfferCount, updated_at: currentDate, way_points: "[]", orders: "[]"};

            const clientInformation = {
              userId: orderRequest.user_id,
              orderId: orderId,
              fullName: orderRequest.user_name,
              avatar: orderRequest.user_avatar ||
                "https://upload.wikimedia.org/wikipedia/commons/f/f4/User_Avatar_2.png",
              count: requestQuantity,
              pickPointLat: orderRequest.user_pick_point_lat,
              pickPointLng: orderRequest.user_pick_point_lng,
              dropPointLat: orderRequest.user_drop_point_lat,
              dropPointLng: orderRequest.user_drop_point_lng,
              tokenMessaging: orderRequest.user_token_messaging,
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
                  resolve(orderDocument);

                  const plural = requestQuantity > 1 ? "s": "";
                  switch (newStatus.state_id) {
                    case "-1": // Esperando
                      console.log(
                          "// TODO: send notification to user and driver, that the offer is \"Waiting\""
                      );
                      // message to client
                      console.log("orderRequest.user_token_messaging: ", orderRequest.user_token_messaging);
                      sendNotificationMessage(
                          orderRequest.user_token_messaging, {
                            notification: {
                              title: `¡Compraste ${requestQuantity} asiento${plural}!`,
                              body: `Destino: ${orderRequest.route_to}`,
                              imageUrl: orderRequest.driver_car_photo,
                            },
                          }
                      );
                      // message to Driver
                      console.log("orderRequest.driver_token_messaging: ", orderRequest.driver_token_messaging);
                      sendNotificationMessage(orderRequest.driver_token_messaging, {
                        notification: {
                          title: `¡${requestQuantity} asiento${plural} vendido${plural}!`,
                          body: `${clientInformation.fullName}, compro ${requestQuantity} asiento${plural}`,
                          imageUrl: clientInformation.avatar,
                        },
                      });
                      break;
                    case "2": // enCarretera
                      console.log(
                          "// TODO: send notification to user and driver, that the offer is \"On Road\""
                      );
                      // message to clients, notify that the offer is in the way
                      console.log("clientsInformation: ", clientsInformation.map(
                          (clientInformation: any) => clientInformation.tokenMessaging));
                      sendNotificationMessage(clientsInformation.map(
                          (clientInformation: any) => clientInformation.tokenMessaging), {
                        notification: {
                          title: `¡El vehiculo está en ruta!, ${orderRequest.driver_car_plate}`,
                          body: "Por favor, espere en el punto de encuentro seleccionado",
                          imageUrl: orderRequest.driver_car_photo,
                        },
                      });
                      // message to driver, notify that the offer is in the way
                      console.log("orderRequest.driver_token_messaging: ", orderRequest.driver_token_messaging);
                      sendNotificationMessage(orderRequest.driver_token_messaging, {
                        notification: {
                          title: "¡LISTO! Inicia la ruta",
                          body: `Los ${maxCounter} asientos fueron vendidos,
                            ponte en ruta con el vehiculo ${orderRequest.driver_car_plate}`,
                          imageUrl: clientInformation.avatar,
                        },
                      });
                      break;
                    default:
                      console.log("default case");
                      break;
                  }
                })
                .catch((error: any) => {
                  console.error("Error adding document: ", error);
                  reject(error);
                });
          } else {
            reject(Error("Not enough quantity offer"));
          }
        });
  });
};

const sendNotificationMessage = (token: string | string[], payload: MessagingPayload, options?: {priority: "high"}) => {
  admin.messaging().sendToDevice(
      token,
      payload,
      options,
  ).then((response: any) => {
    console.log("Successfully sent message: ", JSON.stringify(response));
    console.log("token: ", token);
  }).catch((error: any) => {
    console.log("Error sending message: ", error);
    console.log("token: ", token);
  });
};
