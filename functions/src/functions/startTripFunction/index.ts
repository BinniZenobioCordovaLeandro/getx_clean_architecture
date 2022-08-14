import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {sendNotificationMessage} from "../../common/functions/sendNotificationMessage";

export const handler = (event: any) => {
  return new Promise((resolve, reject) => {
    functions.logger.info("startTripFunction");
    const firebaseFirestore = admin.firestore();

    const offersCollection = firebaseFirestore.collection("c_offers");
    const ordersCollection = firebaseFirestore.collection("c_orders");

    const offerId = event.offer_id;

    functions.logger.info("firebaseFirestore");

    offersCollection.doc(offerId).get().then(async (doc: any) => {
      const currentDate = Date.now();
      const offerDocument = doc.data();
      if (!offerDocument) reject(Error("offer not found"));

      // Esperando -1, enCarretera 2 , Completado 1, Cancelado 0
      const newStatus = {state_id: "2", state_description: "En Carretera"};
      const newData = {updated_at: currentDate, max_count: offerDocument.count};

      // let orders = [];
      const clientsInformation = JSON.parse(offerDocument!.orders);

      if (offerDocument.state_id === "-1") {
        clientsInformation.forEach(async (client: any) => {
          const orderId = client.orderId;
          const tokenMessaging = client.tokenMessaging;
          const fullName = client.fullName;
          ordersCollection.doc(orderId).update({
            ...newData,
            ...newStatus,
          });
          sendNotificationMessage(tokenMessaging, {
            notification: {
              title: `¡Vehiculo en ruta!, ${offerDocument.user_car_plate}`,
              body: `Por favor, espere en el punto de encuentro seleccionado, ${fullName}`,
              imageUrl: offerDocument.user_car_photo,
            },
          })
              .then(() => functions.logger.info(`sendNotificationMessage ${orderId} ${tokenMessaging}`))
              .catch(() => functions.logger.warn(`error sendNotificationMessage ${orderId} ${tokenMessaging}`));
        });

        offersCollection.doc(offerId).update({
          ...newData,
          ...newStatus,
        }).then(() => {
          sendNotificationMessage(offerDocument.user_token_messaging, {
            notification: {
              title: "¡INICIASTE LA RUTA!",
              body: `Los ${clientsInformation.length} pasajeros fueron notificados,
                            ponte en ruta con el vehiculo ${offerDocument.user_car_plate}`,
              imageUrl: offerDocument.user_car_photo,
            },
          });
          resolve({
            ...offerDocument,
            ...newStatus,
            ...newData,
          });
        }).catch((error) => {
          functions.logger.error("Error updating offer ", error);
          reject(error);
        });
      } else {
        reject(Error("offer not available to start trip"));
      }
    });
  });
};
