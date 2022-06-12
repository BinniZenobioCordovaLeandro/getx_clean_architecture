const express = require('express');
const app = express();

const order = require('../createOrderFunction/index.js');

const successResponse = (message) => {
    return {
        code: 200,
        data: message,
    }
};

app.get('/', (req, res) => {
    res.send('hello world');
});

app.put('/createOrder', (req, res) => {
    order.handler(req.body, res).then(result => {
        res.status(200).send(successResponse(result));
    }).catch(err => {
        res.status(500).send(err);
    });
});

app.listen(3000);