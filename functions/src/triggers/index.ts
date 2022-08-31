import * as functions from "firebase-functions";
import {Change, EventContext} from "firebase-functions/v1";
import {QueryDocumentSnapshot} from "firebase-functions/v1/firestore";
import * as users from "./users";

export const handler = (change: Change<QueryDocumentSnapshot>, context: EventContext) => {
  const collectionName = context.params.collection;
  functions.logger.info(`onUpdate trigger, evaluating switch value ${collectionName}`);
  switch (collectionName) {
    case "c_users":
      users.onUpdate(change);
      break;

    default:
      break;
  }
};
