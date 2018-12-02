const functions = require('firebase-functions');
const api = require('./get_prices.js');

exports.getPrice = functions.https.onCall((data, ctx) => {
   let item = data.item;
   let company = data.company;

   if (item) item = JSON.parse(item);

   if (!api.valid_companies.includes(company)) {
      throw new functions.https.HttpsError("invalid-company", "Data requested must be from UPS, USPS, or FedEx.");
   }

   return api.getPrice(company, item).then((price) => {
      console.log(price);
      return price;
   })
   .catch((error) => {
     throw new functions.https.HttpsError("getPrice-error", error);
   })
});
   
