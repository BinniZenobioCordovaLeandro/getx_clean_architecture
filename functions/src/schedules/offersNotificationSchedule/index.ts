import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {sendNotificationToTopic} from "../../common/functions/sendNotificationMessage";

export const handler = (event: any) => {
  return new Promise((resolve, reject) => {
    functions.logger.info("offersNotificationSchedule");
    const firebaseFirestore = admin.firestore();

    const offersCollection = firebaseFirestore.collection("c_offers");

    offersCollection.where("state_id", "==", "-1").get().then((querySnapshot) => {
      functions.logger.info(`Offers filtered count ${querySnapshot.size}`);
      querySnapshot.forEach((doc) => {
        const abstractOfferEntity = doc.data();
        sendNotificationToTopic("pickpointer_app", {
          notification: {
            title: `S/ ${abstractOfferEntity.price.toFixed(2)} => ${abstractOfferEntity.route_title}`,
            body: `Viaja a ${abstractOfferEntity.route_to} por solo S/${abstractOfferEntity.price.toFixed(2)}!`,
          }, data: {
            is_message: "true",
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
