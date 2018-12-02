const { Company } = require("./Company.js");

class UPS extends Company {
    constructor(credentials, format, endpoint) {
        super(credentials, format, endpoint);

        this.handlers = {
            error: this.handleError,
            response: this.handleResponse
        }
    }

    composeRequest(item) {
        let from_postcode,
            to_postcode;

        item.from_postcode ? from_postcode = item.from : from_postcode = "77089"
        item.to_postcode ? to_postcode = item.destination : to_postcode = "10003";

        return {
            "UPSSecurity": {
                "UsernameToken": {
                    "Username": this.credentials.username,
                    "Password": this.credentials.password
                },
                "ServiceAccessToken": {
                    "AccessLicenseNumber": this.credentials.access_key
                }
            },
            "RateRequest": {
                "Request": {
                    "RequestOption": "Shoptimeintransit",
                },
                "Shipment": {
                    "Shipper": {
                        "Address": {
                            "PostalCode": from_postcode,
                            "CountryCode": "US"
                        }
                    },
                    "ShipFrom": {
                        "Address": {
                            "PostalCode": from_postcode,
                            "CountryCode": "US"
                        }
                    },
                    "ShipTo": {
                        "Address": {
                            "PostalCode": to_postcode,
                            "CountryCode": "US"
                        }
                    }, 
                    "Package": {
                        "PackagingType": {
                            "Code": "02",
                            "Description": "Package"
                        },
                        "Dimensions": {
                            "UnitOfMeasurement": {
                                "Code": "IN",
                                "Description": "inches"
                            },
                            "Length": item["dimensions"]["length"].toFixed(2),
                            "Width": item["dimensions"]["width"].toFixed(2),
                            "Height": item["dimensions"]["height"].toFixed(2)
                        },
                        "PackageWeight": {
                            "UnitOfMeasurement": {
                                "Code": "LBS",
                                "Description": "pounds"
                            },
                            "Weight": item["weight"].replace(" lb", "")
                        }
                    },
                    "DeliveryTimeInformation": {
                        "PackageBillType": "03"
                    }
                },
            },

        }
    }

    hasError(body) {
        return body["Error"] || body["Fault"];
    }

    handleError(body) {
        if (!body) return null;
        console.error("error:", body);

        let errors = body.Fault.detail.Errors;
        if (errors) {
            errors = JSON.stringify(errors);
        } else {
            errors = JSON.stringify(body);
        }

        return errors;

    }

    handleResponse(body) {

        let services = [];

        function parseDate(date, day_of_week) {
            const days = {
                "MON": "Monday",
                "TUE": "Tuesday",
                "WED": "Wednesday", 
                "THU": "Thursday",
                "FRI": "Friday",
                "SAT": "Saturday"
            };

            let d = date.split("")
            let year = d.slice(0,4).join("");
            let month = d.slice(4,6).join("");
            let day = d.slice(6,8).join("");

            let dow = days[day_of_week];
    
            return `${dow}, ${month}/${day}/${year}`;
        }
        
        for (let s of body["RateResponse"]["RatedShipment"]) {
            let service = {};
            
            service.name = s["TimeInTransit"]["ServiceSummary"]["Service"]["Description"]
            service.charge = `${s["TotalCharges"]["MonetaryValue"]}`;
            let arrival = s["TimeInTransit"]["ServiceSummary"]["EstimatedArrival"]["Arrival"];

            service.due = {
                date: parseDate(arrival["Date"], s["TimeInTransit"]["ServiceSummary"]["EstimatedArrival"]["DayOfWeek"]), 
            }

            service.due.time = "End of day";

            if (s["GuaranteedDelivery"]) {
                service.due.time = s["GuaranteedDelivery"]["DeliveryByTime"] || "End of day";
            }

            service.transit_time = s["TimeInTransit"]["ServiceSummary"]["EstimatedArrival"]["BusinessDaysInTransit"];
            services.push(service)
        }
        return services;
    }
    
}

exports.UPS = UPS;