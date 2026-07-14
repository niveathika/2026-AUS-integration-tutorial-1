import ballerina/http;
import ballerina/log;
import ballerina/uuid;
import ballerinax/googleapis.gmail;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /pizza on httpDefaultListener {
    resource function post orders(@http:Payload OrderRequest payload) returns PizzaResponse|error {
        do {
            log:printInfo("Order request recieved");
            string orderId = uuid:createType1AsString();
            KitchenRequest kitchenRequest = transform(orderId, payload);
            KitchenResponse kitchenResponse = check kitchenClient->post("/orders", kitchenRequest);
            if kitchenResponse.status == "ACCEPTED" {
                DelivaryResponse delivaryResponse = check delivaryClient->/quotes.get(orderId = orderId, address = payload.address);
                PizzaResponse orderResponse = {
                    orderId: orderId,
                    status: kitchenResponse.status,
                    estimatedReadyTime: kitchenResponse.etaMinutes,
                    deliveryPartner: delivaryResponse.deliveryPartner,
                    deliveryEtaMinutes: delivaryResponse.etaMinutes
                };
                Invoice invoice = toInvoice(orderId, payload);
                gmail:Message _ = check gmailClient->/users/[string `wso2integrationdemos@gmail.com`]/messages/send.post({
                    to: [payload.email],
                    subject: string `Order ${orderId} - ${kitchenResponse.status}`,
                    bodyInHtml: renderInvoice(invoice)
                });
                return orderResponse;
            } else {
                return error("Kitchen requested the order");
            }
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

}
