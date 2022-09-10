import * as functions from "firebase-functions";
import {sendNotificationToTopic} from "../../common/functions/sendNotificationMessage";

export const handler = (event: any) => {
  return new Promise((resolve, reject) => {
    functions.logger.info("sendNotificationToTopic");
    sendNotificationToTopic(event.topic, event.payload, event.options)
        .then((response) => resolve(response))
        .catch((error) => reject(error));
  });
};
