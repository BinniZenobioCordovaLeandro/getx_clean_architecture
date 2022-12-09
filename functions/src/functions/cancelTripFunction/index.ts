import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {sendNotificationMessage} from "../../common/functions/sendNotificationMessage";


export const handler = (event: any) => {
  return new Promise((resolve, reject) => {
    functions.logger.info("cancelTripFunction");
    const firebaseFirestore = admin.firestore();

    const offersCollection = firebaseFirestore.collection("c_offers");
    const ordersCollection = firebaseFirestore.collection("c_orders");

    const offerId = event.offer_id;

    functions.logger.info("firebaseFirestore");

    offersCollection.doc(offerId).get().then(async (doc: any) => {
      const currentDate = Date.now();
      const offerDocument = doc.data();
      if (!offerDocument) reject(Error("offer not found"));

      // Esperando -1, enCarretera 2 , enListo 3, Completado 1, Cancelado 0
      const newStatus = {state_id: "0", state_description: "Cancelado"};
      const newData = {updated_at: currentDate};

      const clientsInformation = JSON.parse(offerDocument!.orders);

      if (["-1", "2", "3"].includes(offerDocument.state_id)) {
        clientsInformation.forEach((client: any) => {
          const orderId = client.order_id;
          const tokenMessaging = client.token_messaging;
          // const fullName = client.full_name;

          ordersCollection.doc(orderId).update({
            ...newData,
            ...newStatus,
          });

          sendNotificationMessage(tokenMessaging, {
            notification: {
              title: "¡Viaje CANCELADO!",
              body: "Lo sentimos mucho. Tu conductor tuvo un inconveniente, y cancelo el viaje. :C",
              imageUrl: offerDocument.user_car_photo,
            },
            data: {
              is_message: "true",
              link: `/order/${orderId}`,
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
              title: `¡VIAJE CANCELADO!, auto ${offerDocument.user_car_plate}`,
              body: `Hemos notificado de tu cancelación de viaje, gracias por usar PICKPOINTER app!,
              ${offerDocument.user_name}`,
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
