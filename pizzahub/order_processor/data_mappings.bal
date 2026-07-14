
function transform(string orderId, OrderRequest payload) returns KitchenRequest => {
    orderId: orderId + payload.customerId,
    items: payload.items
};

function toInvoice(string orderId, OrderRequest payload) returns Invoice => let
    InvoiceLineItem[] lineItems = from PizzaItem item in payload.items
        select {
            description: string `${item.pizza} (${item.size})`,
            quantity: item.quantity,
            unitPrice: priceOf(item),
            lineTotal: <decimal>item.quantity * priceOf(item)
        },
    decimal subTotal = decimal:sum(0.0, ...from InvoiceLineItem line in lineItems
        select line.lineTotal)
    in {
        invoiceId: "INV-" + orderId,
        customerName: payload.customerName,
        billingAddress: payload.address,
        contactEmail: payload.email,
        lineItems: lineItems,
        subTotal: subTotal,
        deliveryFee: deliveryFee,
        tax: subTotal * taxRate,
        total: subTotal + deliveryFee + (subTotal * taxRate)
    };
