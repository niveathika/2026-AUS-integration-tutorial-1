
public type PizzaItem record {|
    string pizza;
    string size;
    int quantity;
|};

public type OrderRequest record {|
    string customerId;
    string customerName;
    string phone;
    string address;
    string email;
    PizzaItem[] items;
|};

public type PizzaResponse record {|
    string orderId;
    string status;
    int estimatedReadyTime;
    string deliveryPartner;
    int deliveryEtaMinutes;
|};

public type KitchenRequest record {|
    PizzaItem[] items;
    string orderId;
|};

public type KitchenResponse record {|
    string orderId;
    string status;
    int etaMinutes;
|};

public type DelivaryResponse record {|
    string deliveryPartner;
    int etaMinutes;
    string orderId;
|};

public type InvoiceLineItem record {|
    string description;
    int quantity;
    decimal unitPrice;
    decimal lineTotal;
|};

public type Invoice record {|
    string invoiceId;
    string customerName;
    string billingAddress;
    string contactEmail;
    InvoiceLineItem[] lineItems;
    decimal subTotal;
    decimal deliveryFee;
    decimal tax;
    decimal total;
|};
