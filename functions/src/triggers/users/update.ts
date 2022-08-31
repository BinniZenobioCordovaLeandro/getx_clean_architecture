import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {Change} from "firebase-functions/v1";
import {QueryDocumentSnapshot} from "firebase-functions/v1/firestore";
import {sendNotificationMessage} from "../../common/functions/sendNotificationMessage";

export const handler = (change: Change<QueryDocumentSnapshot>) => {
  const firebaseFirestore = admin.firestore();
  const sessionsCollection = firebaseFirestore.collection("c_sessions");

  const after = change.after.data();
  const userId = after.id;
  const userName = after.name;

  functions.logger.info(`User identified ${userId} - ${userName}`);

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
      }).then((response: any) => {
        functions.logger.info(`Messages sends response ${response}`);
      }).catch((error: any) => {
        functions.logger.error("Error sending messages", error);
      });
    }).catch((error: any) => {
      functions.logger.error("Error where id_users", error);
    });
  }
};
