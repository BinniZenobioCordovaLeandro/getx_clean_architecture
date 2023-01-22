import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {sendNotificationMessage} from "../../common/functions/sendNotificationMessage";

export const handler = () => {
  return new Promise((resolve, reject) => {
    functions.logger.info("driversNotificationSchedule");
    const firebaseFirestore = admin.firestore();

    const usersCollection = firebaseFirestore.collection("c_users");
    const sessionsCollection = firebaseFirestore.collection("c_sessions");

    usersCollection.where("is_driver", "==", "2").get().then((querySnapshot) => {
      functions.logger.info(`Drivers filtered count ${querySnapshot.size}`);
      querySnapshot.forEach((doc) => {
        const abstractDriverEntity = doc.data();
        const userId = abstractDriverEntity.id;
        const userName = abstractDriverEntity.name;
        const userObservation = abstractDriverEntity.observation;
        sessionsCollection.where("id_users", "==", `${userId}`).get().then((querySnapshot) => {
          const tokenMessaging: string[] = [];
          functions.logger.info(`Sessions filtered count ${querySnapshot.size}`);
          querySnapshot.forEach((doc) => {
            const sessionData = doc.data();
            if (sessionData.token_messaging != null) tokenMessaging.push(sessionData.token_messaging);
          });
          functions.logger.info(`Sending message to ${tokenMessaging.length} tokens`);
          sendNotificationMessage(tokenMessaging, {
            notification: {
              title: `SOLICITUD OBSERVADA, ${userName}!`,
              body: `Hey!, resuelve esto para activar el modo conductor: ${userObservation}`,
            },
            data: {
              is_message: "true",
              link: "/user",
            },
          }).then((response: any) => {
            functions.logger.info(`Messages sends response ${response}`);
          }).catch((error: any) => {
            functions.logger.error("Error sending messages", error);
          });
        }).catch((error: any) => {
          functions.logger.error("Error where id_users", error);
        });
      });
    }).catch((error: any) => {
      functions.logger.error("Error is_driver", error);
    });
  });
};
