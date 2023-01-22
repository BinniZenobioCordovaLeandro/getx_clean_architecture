import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {sendNotificationToTopic} from "../../common/functions/sendNotificationMessage";

export const handler = () => {
  return new Promise((resolve, reject) => {
    functions.logger.info("offersNotificationSchedule");
    const firebaseFirestore = admin.firestore();

    const offersCollection = firebaseFirestore.collection("c_offers");

    offersCollection.where("state_id", "==", "-1").get().then((querySnapshot) => {
      functions.logger.info(`Offers filtered count ${querySnapshot.size}`);
      querySnapshot.forEach((doc) => {
        const abstractOfferEntity = doc.data();
        const availableSites = abstractOfferEntity.max_count - abstractOfferEntity.count;
        const pluralSuffix = availableSites > 1 ? "s" : "";
        const price = abstractOfferEntity.price.toFixed(2);
        sendNotificationToTopic("pickpointer_app", {
          notification: {
            title: `Colectivo disponible!, A ${abstractOfferEntity.route_to}`,
            body: `AUTO "${abstractOfferEntity.user_car_model}", precio de S/ ${price} por pasajero
              Recojo a domicilio
              ${availableSites} asiento${pluralSuffix} disponible${pluralSuffix}`,
            imageUrl: abstractOfferEntity.user_car_photo,
          }, data: {
            link: `/route/${abstractOfferEntity.route_id}`,
          },
        }).then(() => {
          functions.logger.info(`Topic pickpointer_app notified, offerId ${abstractOfferEntity.id}`);
          resolve(`Topic pickpointer_app notified, offerId ${abstractOfferEntity.id}`);
        })
            .catch(() => {
              functions.logger.warn(`error notifying Topic pickpointer_app ${abstractOfferEntity.id}`);
              reject(Error(`error notifying Topic pickpointer_app ${abstractOfferEntity.id}`));
            });
      });
    });
  });
};
