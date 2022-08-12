import * as functions from "firebase-functions";
import {sendNotificationMessage} from "../../common/functions/sendNotificationMessage";

export const handler = (event: any) => {
  return new Promise((resolve, reject) => {
    functions.logger.info("sendNotificationFunction");
    sendNotificationMessage(event.token, event.payload, event.options);
  });
};
