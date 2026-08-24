import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {sendNotificationMessage} from "../../common/functions/sendNotificationMessage";
import {daysBetweenDates} from "../../common/utils/dateUtil";
import {MAX_OFFERS_DAYS} from "../../common/constants";
import * as cancelTripPackage from "../../functions/cancelTripFunction";

export const handler = () => {
  return new Promise((resolve, reject) => {
    functions.logger.info("driversOffersSchedule");
    const firebaseFirestore = admin.firestore();

    const offersCollection = firebaseFirestore.collection("c_offers");
    offersCollection.where("state_id", "==", "-1").where("count", "==", 0).get().then((querySnapshot) => {
      functions.logger.info(`Offers filtered count ${querySnapshot.size}`);
      return querySnapshot.forEach((doc) => {
        const abstractOfferEntity = doc.data();
        const dateTimeString = abstractOfferEntity.date_time;

        const dateTime = new Date(dateTimeString);
        const currentTime = new Date();

        const daysAfter = daysBetweenDates(dateTime, currentTime);
        if (daysAfter > MAX_OFFERS_DAYS) {
          // disable
          cancelTripPackage.handler({offer_id: abstractOfferEntity.id});
        } else {
          sendNotificationMessage(abstractOfferEntity.user_token_messaging, {
            notification: {
              title: "¡Seguimos BUSCANDO!",
              body: "Esto esta tardando... seguiremos buscando clientes por un tiempo. Antes de cancelar el viaje.",
              imageUrl: abstractOfferEntity.user_car_photo,
            },
            data: {
              is_message: "true",
              link: `/offer/${abstractOfferEntity.id}`,
            },
          });
        }
      });
    }).then(() => resolve("driversOffersSchedule executed"))
        .catch(() => reject(Error("error driversOffersSchedule")));
  });
};
