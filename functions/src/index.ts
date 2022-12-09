import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as createOrderPackage from "./functions/createOrderFunction";
import * as sendNotificationPackage from "./functions/sendNotificationFunction";
import * as sendNotificationToTopicPackage from "./functions/sendNotificationTopicFunction";
import * as startTripPackage from "./functions/startTripFunction";
import * as finishTripPackage from "./functions/finishTripFunction";
import * as cancelTripPackage from "./functions/cancelTripFunction";
import * as triggers from "./triggers";
import * as offersNotificationSchedule from "./schedules/offersNotificationSchedule";
import * as driversNotificationSchedule from "./schedules/driversNotificationSchedule";

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

export const sendNotificationTopic = functions.https.onRequest((request, response) => {
  functions.logger.info("sendNotificationTopic logs!", {structuredData: true});
  sendNotificationToTopicPackage.handler(request.body).then((result: any) => {
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

export const cancelTrip = functions.https.onRequest((request, response) => {
  functions.logger.info("cancelTrip logs!", {structuredData: true});
  cancelTripPackage.handler(request.body).then((result: any) => {
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

// // Start writing Firebase schedules functions
// // https://firebase.google.com/docs/functions/schedule-functions
//

export const scheduledFunction = functions.pubsub.schedule("every 6 hours").onRun((context) => {
  functions.logger.info("SCHEDULED every 6 hours");
  const handler = offersNotificationSchedule.handler(context);
  driversNotificationSchedule.handler(context);
  return handler;
});
