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
                    "RequestOption": "Rate",
                },
                "Shipment": {
                    "ShipFrom": {
                        "Address": {
                            "PostalCode": 78705,
                        }
                    },
                    "ShipTo": {
                        "Address": {
                            "PostalCode": 10003
                        }
                    }
                },
                "Package": {
                    "PackagingType": {
                        "Code": "02",
                        "Description": "Rate"
                    },
                    "Dimensions": {
                        "UnitOfMeasurement": {
                            "Code": "IN",
                            "Description": "inches"
                        },
                        "Length": 5,
                        "Width": 4,
                        "Height": 10
                    },
                    "PackageWeight": {
                        "UnitOfMeasurement": {
                            "Code": "LBS",
                            "Description": "pounds"
                        },
                        "Weight": 2
                    }
                }
            },

        }
    }

    hasError(body) {
        return body["Error"] || body["Fault"];
    }

    handleError(body) {
        if (!body) return null;
        console.log(body);
        try {
            console.log(JSON.stringify(body.Fault.detail.Errors))
        } catch(err) {
            console.error(err)
        }
        return body;

    }

    handleResponse(body) {
        console.log(JSON.stringify(body))
        return body;
    }
}

exports.UPS = UPS;