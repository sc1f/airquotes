const functions = require('firebase-functions');
const api = require('./get_prices.js');

exports.getPrice = functions.https.onRequest((request, response) => {
    let price = api.getPrice("UPS", {});
    console.log(price);
    if (!price) {
        response.status(404).send()
     } else {
        response.send(price)
     }
});
   
