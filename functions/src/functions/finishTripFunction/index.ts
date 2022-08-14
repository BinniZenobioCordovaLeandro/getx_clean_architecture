import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {sendNotificationMessage} from "../../common/functions/sendNotificationMessage";


export const handler = (event: any) => {
  return new Promise((resolve, reject) => {
    functions.logger.info("finishTripFunction");
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
      const newStatus = {state_id: "1", state_description: "Completado"};
      const newData = {updated_at: currentDate};

      const clientsInformation = JSON.parse(offerDocument!.orders);

      if (offerDocument.state_id === "2") {
        clientsInformation.forEach((client: any) => {
          const orderId = client.orderId;
          const tokenMessaging = client.tokenMessaging;
          const fullName = client.fullName;

          ordersCollection.doc(orderId).update({
            ...newData,
            ...newStatus,
          });

          sendNotificationMessage(tokenMessaging, {
            notification: {
              title: "¡Gracias por usar PICKPOINTER!",
              body: `Gracias por viajar, te esperamos nuevamente, ${fullName}`,
              imageUrl: offerDocument.user_car_photo,
            },
          })
              .then(() => functions.logger.info(`User notified ${orderId}`))
              .catch(() => functions.logger.warn(`error notifying User ${orderId} ${tokenMessaging}`));
        });

        offersCollection.doc(offerId).update({
          ...newData,
          ...newStatus,
        }).then(() => {
          sendNotificationMessage(offerDocument.user_token_messaging, {
            notification: {
              title: `¡RUTA COMPLETA!, ${offerDocument.user_car_plate}`,
              body: `Gracias por usar PICKPOINTER, ${offerDocument.user_name}`,
              imageUrl: offerDocument.user_car_photo,
            },
          }).then(() => {
            functions.logger.info("Driver notified");
          }).catch(() => {
            functions.logger.warn(`error notifying Driver ${offerDocument.user_token_messaging}`);
          });

          admin.database().ref(`c_vehicles/${offerDocument.user_car_plate}`).remove().then(() => {
            functions.logger.info(`Vehicle removed ${offerDocument.user_car_plate}`);
          }).catch(() => {
            functions.logger.warn(`error removing Vehicle ${offerDocument.user_car_plate}`);
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
        reject(Error("offer not in progress to finish"));
      }
    });
  });
};
