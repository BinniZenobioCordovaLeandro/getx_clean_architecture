import * as functions from "firebase-functions";
import axios, {RawAxiosRequestHeaders, AxiosHeaders} from "axios";
import * as FormData from "form-data";

const post = (path: string, data: FormData, headers?: RawAxiosRequestHeaders | AxiosHeaders) => {
  return new Promise((resolve, reject) => {
    const config = {
      method: "post",
      url: path,
      headers: {
        ...headers,
        ...data.getHeaders(),
      },
      data: data,
    };
    axios(config).then((response) => {
      functions.logger.info("http.post response status", response.status);
      resolve(response.data);
    })
        .catch((error) => {
          functions.logger.error("http.post error", error);
          console.log(error);
          reject(error);
        });
  });
};

export const http = {
  post: post,
  FormData: FormData,
};

