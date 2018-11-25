const r = require("request");
const UPS = require("./companies/UPS.js");

const endpoints = {
    usps: "https://secure.shippingapis.com/ShippingAPI.dll?API=RateV4&XML",
    fedex: "",
    ups: "https://onlinetools.ups.com/rest/Rate"
}

const valid_companies = ["USPS", "FedEx", "UPS"];

function getJSONResponse(options) {
    let result = {};

    r.post(options, (err, res, body) => {
        if (err) {
            console.error("Request error:", err);
            result = null;
            return;
        }
        
        result = JSON.parse(body);
    });

    console.log(result);
    return result;
}

exports.getPrice = function (company, item) {
    if (!valid_companies.includes(company)) {
        return null;
    }

    let shipping_company,
        credentials,
        request_options;

    switch (company) {
        case "ups": {
            const ups_env = functions.config().ups;
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
                    "Access-Control-Allow-Methods:": "POST",
                    "Access-Control-Allow-Origin": "*",
                },
                json: true,
                body: request
            }
            break;
        }
        default: {
            return null;
        }
        
    }

    console.log(shipping_company);

    let response_body;

    if (shipping_company.format === "JSON") {
        response_body = getJSONResponse(request_options);
    } else {
        return null;
    }

    const has_error = shipping_company.hasError(response_body);
    if (response_body === null || has_error) {
        return null;
    }

    return shipping_company.handlers.response(response_body);
}
