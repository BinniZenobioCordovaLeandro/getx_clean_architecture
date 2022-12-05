import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {Change} from "firebase-functions/v1";
import {QueryDocumentSnapshot} from "firebase-functions/v1/firestore";
import {sendNotificationToTopic} from "../../common/functions/sendNotificationMessage";

export const handler = (change: Change<QueryDocumentSnapshot>) => {
  const firebaseFirestore = admin.firestore();
  const routesCollection = firebaseFirestore.collection("c_routes");

  const after = change.after.data();
  const routeId = after.id;
  const routeTo = after.to;
  const routePrice = after.price;
  const routeTitle = after.title;

  functions.logger.info(`New route request identified ${routeId}`);

  if (after.approved === true) {
    functions.logger.info(`New Route APPROVED ${routeId}`);
    routesCollection.doc(routeId).set(after).then(() => {
      sendNotificationToTopic("pickpointer_app", {
        notification: {
          title: `¡NUEVA RUTA A ${routeTo}!`,
          body: `Precio desde S/ ${routePrice} en ruta ${routeTitle}`,
        }, data: {
          is_message: "true",
          link: `/route/${routeId}`,
        },
      }).then(() => functions.logger.info(`Topic pickpointer_app notified, routeId ${routeId}`))
          .catch(() => functions.logger.warn(`error notifying Topic pickpointer_app ${routeId}`));
    }).catch((error: any) => {
      functions.logger.error(`Error setting new route approved ${routeId}`, error);
    });
  }
};
