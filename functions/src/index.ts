import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as createOrderPackage from "./functions/createOrderFunction";
import * as sendNotificationPackage from "./functions/sendNotificationFunction";
import * as startTripPackage from "./functions/startTripFunction";
import * as finishTripPackage from "./functions/finishTripFunction";
import {sendNotificationMessage} from "./common/functions/sendNotificationMessage";

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

export const usersTrigger = functions.firestore.document("c_users/{id}").onUpdate((change, context) => {
  const firebaseFirestore = admin.firestore();
  const sessionsCollection = firebaseFirestore.collection("c_sessions");

  const after = change.after.data();
  const userId = after.id;
  const userName = after.name;

  functions.logger.info(`User identified ${userId}`);

  if (after.is_driver === "1" && userName != null) {
    functions.logger.info(`User is verified driver ${after.is_driver}`);

    sessionsCollection.where("id_users", "==", `${userId}`).get().then((querySnapshot) => {
      const tokenMessaging: string[] = [];
      functions.logger.info(`Sessions filtered count ${querySnapshot.size}`);
      querySnapshot.forEach((doc) => {
        const sessionData = doc.data();
        if (sessionData.token_messaging != null) tokenMessaging.push(sessionData.token_messaging);
        sessionsCollection.doc(`${sessionData.id_sessions}`).update({is_driver: true}).then(() => {
          functions.logger.info(`Session Updated ${sessionData.id_sessions}`);
        }).catch((error: any) => {
          functions.logger.error("Error updating session", error);
        });
      });
      functions.logger.info(`Sending message to ${tokenMessaging.length} tokens`);
      sendNotificationMessage(tokenMessaging, {
        notification: {
          title: "¡HORA DE ROQUEAR!",
          body: `Bienvenido, ya eres CONDUCTOR!, ${userName}`,
        },
      }).then((response) => {
        functions.logger.info(`Messages sends response ${response}`);
      }).catch((error: any) => {
        functions.logger.error("Error sending messages", error);
      });
    }).catch((error: any) => {
      functions.logger.error("Error where id_users", error);
    });
  }
});
