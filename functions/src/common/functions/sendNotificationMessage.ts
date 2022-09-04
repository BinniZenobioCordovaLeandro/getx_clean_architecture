import * as admin from "firebase-admin";
import {MessagingOptions, MessagingPayload} from "firebase-admin/lib/messaging/messaging-api";

export const sendNotificationMessage = (
    token: string | string[],
    payload: MessagingPayload,
    options?: MessagingOptions | undefined,
) => {
  return new Promise((resolve, reject) => {
    admin.messaging().sendToDevice(
        token,
        payload,
        options ?? {priority: "high"},
    ).then((response: any) => {
      console.log("Successfully sent message: ", JSON.stringify(response));
      console.log("token: ", token);
      resolve(response);
    }).catch((error: any) => {
      console.log("Error sending message: ", error);
      console.log("token: ", token);
      reject(error);
    });
  });
};
