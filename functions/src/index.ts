import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as createOrderPackage from "./functions/createOrderFunction";
import * as sendNotificationPackage from "./functions/sendNotificationFunction";
import * as startTripPackage from "./functions/startTripFunction";
import * as finishTripPackage from "./functions/finishTripFunction";
import * as triggers from "./triggers";

admin.initializeApp();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const createOrder = functions.https.onRequest((request, response) => {
  functions.logger.info("createOrder logs!", {structuredData: true});
  createOrderPackage
      .handler(request.body)
      .then((result: any) => {
        response.status(200).send(result);
      })
      .catch((err: any) => {
        response.status(500).send(err);
      });
});

export const sendNotification = functions.https.onRequest((request, response) => {
  functions.logger.info("sendNotification logs!", {structuredData: true});
  sendNotificationPackage.handler(request.body).then((result: any) => {
    console.log("request.body: ", request.body);
    response.status(200).send(result);
  }).catch((err: any) => {
    response.status(500).send(err);
  });
});

export const startTrip = functions.https.onRequest((request, response) => {
  functions.logger.info("startTrip logs!", {structuredData: true});
  startTripPackage.handler(request.body).then((result: any) => {
    response.status(200).send(result);
  }).catch((err: any) => {
    response.status(500).send(err);
  });
});

export const finishTrip = functions.https.onRequest((request, response) => {
  functions.logger.info("finishTrip logs!", {structuredData: true});
  finishTripPackage.handler(request.body).then((result: any) => {
    response.status(200).send(result);
  }).catch((err: any) => {
    response.status(500).send(err);
  });
});


// // Start writing Firebase Triggers
// // https://firebase.google.com/docs/functions/firestore-events
//

export const triggerOnUpdate = functions.firestore.document("{collection}/{id}").onUpdate((change, context) =>{
  functions.logger.info("TRIGGER onUpdate");
  triggers.handler(change, context);
}
);
