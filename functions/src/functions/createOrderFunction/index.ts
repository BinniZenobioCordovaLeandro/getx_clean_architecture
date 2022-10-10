import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as uuid from "uuid";
import {sendNotificationMessage} from "../../common/functions/sendNotificationMessage";

export const handler = (event: any) => {
  return new Promise((resolve, reject) => {
    functions.logger.info("createOrderFunction");
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
          const currentCounter = parseInt(offerDocument!.count);
          const currentTotal = parseFloat(offerDocument!.total);
          const availableQuantity = parseInt(offerDocument!.max_count) - currentCounter;
          const maxCounter = parseInt(offerDocument!.max_count);

          // console.log("routeQuantity <= availableQuantity : ");
          // console.log(requestQuantity <= availableQuantity);

          if (requestQuantity <= availableQuantity) {
          // STATUS
          // Esperando -1, enCarretera 2 , Completado 1, Cancelado 0
            const newOfferCount = currentCounter + requestQuantity;
            const newStatus = {state_id: "-1", state_description: "Esperando"};

            console.log("newOfferCount == max_counter", newOfferCount, " == ", maxCounter);
            if (newOfferCount == maxCounter) {
              newStatus.state_id = "2";
              newStatus.state_description = "En Carretera";
            }

            // Update offer
            const newData = {count: newOfferCount, total: 0.0, updated_at: currentDate, way_points: "[]", orders: "[]"};

            const clientInformation = {
              user_id: orderRequest.user_id,
              order_id: orderId,
              full_name: orderRequest.user_name,
              phone_number: orderRequest.user_phone,
              avatar: orderRequest.user_avatar ||
                "https://upload.wikimedia.org/wikipedia/commons/f/f4/User_Avatar_2.png",
              count: requestQuantity,
              subtotal: orderRequest.subtotal,
              total: orderRequest.total,
              pick_point_lat: orderRequest.user_pick_point_lat,
              pick_point_lng: orderRequest.user_pick_point_lng,
              drop_point_lat: orderRequest.user_drop_point_lat,
              drop_point_lng: orderRequest.user_drop_point_lng,
              token_messaging: orderRequest.user_token_messaging,
            };

            const wayPoints = JSON.parse(offerDocument!.way_points);
            wayPoints.push(`${userPickPointLat}, ${userPickPointLng} `);
            wayPoints.push(`${userDropPointLat}, ${userDropPointLng} `);
            newData.way_points = JSON.stringify(wayPoints);

            const clientsInformation = JSON.parse(offerDocument!.orders);
            clientsInformation.push(clientInformation);
            newData.orders = JSON.stringify(clientsInformation);

            const newTotal = currentTotal + clientInformation.total;
            newData.total = newTotal;

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
                          body: `${clientInformation.full_name}, compro ${requestQuantity} asiento${plural}`,
                          imageUrl: clientInformation.avatar,
                        },
                        data: {
                          is_message: "true",
                          link: `/offer/${offerDocument.id}`,
                        },
                      });
                      break;
                    case "2": // enCarretera
                      console.log(
                          "// TODO: send notification to user and driver, that the offer is \"On Road\""
                      );
                      // message to clients, notify that the offer is in the way
                      clientsInformation.forEach((client: any) => {
                        const orderId = client.order_id;
                        const tokenMessaging = client.token_messaging;
                        const fullName = client.full_name;

                        sendNotificationMessage(tokenMessaging, {
                          notification: {
                            title: `¡El vehiculo está en ruta!, ${orderRequest.driver_car_plate}`,
                            body: `Por favor, espere en el punto de encuentro seleccionado, ${fullName}`,
                            imageUrl: orderRequest.driver_car_photo,
                          },
                          data: {
                            is_message: "true",
                            link: `/order/${orderId}`,
                          },
                        })
                            .then(() => functions.logger.info(`User notified ${orderId}`))
                            .catch(() => functions.logger.warn(`error notifying User ${orderId} ${tokenMessaging}`));
                      });
                      // message to driver, notify that the offer is in the way
                      console.log("orderRequest.driver_token_messaging: ", orderRequest.driver_token_messaging);
                      sendNotificationMessage(orderRequest.driver_token_messaging, {
                        notification: {
                          title: "¡LISTO! Inicia la ruta",
                          body: `Los ${maxCounter} asientos fueron vendidos,
                            ponte en ruta con el vehiculo ${orderRequest.driver_car_plate}`,
                          imageUrl: orderRequest.driver_car_photo,
                        },
                        data: {
                          is_message: "true",
                          link: `/offer/${offerDocument.id}`,
                        },
                      }).then(() =>
                        functions.logger.info(`Driver notified ${offerDocument.user_car_plate}`)
                      ).catch(() =>
                        functions.logger.warn(`error notifying Driver ${offerDocument.user_car_plate}`)
                      );
                      break;
                    default:
                      console.log("default case");
                      break;
                  }
                })
                .catch((error: any) => {
                  functions.logger.error("Error updating order ", error);
                  reject(error);
                });
          } else {
            reject(Error("Not enough quantity offer"));
          }
        });
  });
};


