import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {http} from "../../common/functions/http";


export const handler = () => {
  return new Promise((resolve, reject) => {
    functions.logger.info("sutranDataSchedule");

    const firebaseStorage = admin.storage().bucket();

    const formData = new http.FormData();
    formData.append("tipo", "MAPA");

    const headers = {
      "Origin": "http://gis.sutran.gob.pe",
      "Referer": "http://gis.sutran.gob.pe/alerta_sutran/",
      "Host": "gis.sutran.gob.pe",
      "Content-type": "application/x-www-form-urlencoded",
      "Postman-Token": "",
      "Content-Length": "163",
    };

    http.post("http://gis.sutran.gob.pe/alerta_sutran/script_cgm/carga_xlsx.php", formData, headers)
        .then((response) => {
          functions.logger.info("response sutranData", response);
          const file = firebaseStorage.file("sutranData.json");
          functions.logger.info("creating sutranData.json");
          const content = JSON.stringify(response);
          file.save(content).then(() => file.makePublic()).then(() => {
            const publicUrl = file.publicUrl();
            functions.logger.info("file in ", publicUrl);
            resolve(publicUrl);
          }).catch(reject);
        }).catch(reject);
  });
};

