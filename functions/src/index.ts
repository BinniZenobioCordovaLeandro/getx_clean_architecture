import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as createOrderPackage from "./functions/createOrderFunction";
import * as sendNotificationPackage from "./functions/sendNotificationFunction";

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
