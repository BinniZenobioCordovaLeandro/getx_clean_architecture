import * as admin from "firebase-admin";
import {MessagingPayload} from "firebase-admin/lib/messaging/messaging-api";

export const sendNotificationMessage = (
    token: string | string[],
    payload: MessagingPayload, options?: {priority: "high"},
) => {
  admin.messaging().sendToDevice(
      token,
      payload,
      options,
  ).then((response: any) => {
    console.log("Successfully sent message: ", JSON.stringify(response));
    console.log("token: ", token);
  }).catch((error: any) => {
    console.log("Error sending message: ", error);
    console.log("token: ", token);
  });
};
