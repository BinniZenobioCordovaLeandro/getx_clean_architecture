import * as functions from "firebase-functions";
import {Change, EventContext} from "firebase-functions/v1";
import {QueryDocumentSnapshot} from "firebase-functions/v1/firestore";
import * as users from "./users";
import * as routesRequests from "./routesRequests";

export const handler = (change: Change<QueryDocumentSnapshot>, context: EventContext) => {
  const collectionName = context.params.collection;
  functions.logger.info(`onUpdate trigger, evaluating switch value ${collectionName}`);
  switch (collectionName) {
    case "c_users":
      users.onUpdate(change);
      break;

    case "c_routes_requests":
      routesRequests.onUpdate(change);
      break;

    default:
      break;
  }
};
