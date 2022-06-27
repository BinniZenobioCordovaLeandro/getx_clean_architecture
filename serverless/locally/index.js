const express = require('express');
var bodyParser = require('body-parser')

const app = express();

const order = require('../createOrderFunction/index.js');

var jsonParser = bodyParser.json()

app.get('/', (req, res) => {
    res.send('hello world');
});

app.put('/createOrder', jsonParser, (req, res) => {
    console.log('/createOrder_req: ', req.body);
    order.handler(req.body, res).then(result => {
        res.status(200).send(result);
    }).catch(err => {
        res.status(500).send(err);
    });
});

app.listen(3000);