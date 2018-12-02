const functions = require("firebase-functions");
const r = require("request");
const { UPS } = require("./companies/UPS.js");

const endpoints = {
    usps: "https://secure.shippingapis.com/ShippingAPI.dll?API=RateV4&XML",
    fedex: "",
    ups: "https://onlinetools.ups.com/rest/Rate"
}

exports.valid_companies = ["USPS", "FedEx", "UPS"];

function getJSONResponse(options) {
    return new Promise((resolve, reject) => {
        r.post(options, (err, _, body) => {
            if (err) {
                reject(err);
            }
            resolve(body);
        });
    });
}

exports.getPrice = function(company, item) {
    if (!exports.valid_companies.includes(company)) {
        return null;
    }

    let shipping_company,
        credentials,
        request_options;

    switch (company) {
        case "UPS": {
            const ups_env = functions.config()["ups"];
            credentials = {
                access_key: ups_env.access_key,
                username: ups_env.username,
                password: ups_env.password
            }
            shipping_company = new UPS(credentials, "JSON", endpoints.ups);
            request = shipping_company.composeRequest(item);
            request_options = {
                url: shipping_company.endpoint,
                method: "POST",
                headers: {
                    "Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept",
                    "Access-Control-Allow-Origin": "*",
                },
                json: true,
                body: request
            }
            break;
        }
        default: {
            return null 
        }
        
    }
    if (shipping_company.format === "JSON") {
        return new Promise((resolve, reject) => {
            getJSONResponse(request_options).then((body) => {
                if (shipping_company.hasError(body)) {
                    return reject(shipping_company.handlers.error(body));
                } else {
                    return resolve(shipping_company.handlers.response(body));
                }
            })
            .catch((err) => console.error(err));    
        });
        
    } else {
        return null;
    }

    
}
