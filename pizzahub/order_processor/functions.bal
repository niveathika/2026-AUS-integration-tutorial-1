// Base menu prices keyed by pizza name (in the smallest size).
final readonly & map<decimal> menuPrices = {
    margherita: 1200.0,
    pepperoni: 1500.0,
    veggie: 1300.0,
    hawaiian: 1450.0
};

// Returns the unit price of an item, applying a size multiplier.
function priceOf(PizzaItem item) returns decimal {
    decimal base = menuPrices[item.pizza.toLowerAscii()] ?: 1000.0;
    decimal sizeFactor = item.size == "large" ? 1.5 : item.size == "medium" ? 1.2 : 1.0;
    return base * sizeFactor;
}

// Formats a monetary value with exactly two decimal places.
function money(decimal d) returns string {
    string s = d.round(2).toString();
    int? dot = s.indexOf(".");
    if dot is () {
        return s + ".00";
    }
    int decimals = s.length() - dot - 1;
    return decimals == 1 ? s + "0" : s;
}

// Renders an invoice as an HTML document for the email body.
function renderInvoice(Invoice invoice) returns string {
    string rows = "";
    foreach InvoiceLineItem item in invoice.lineItems {
        rows += string `<tr><td>${item.description}</td><td align="center">${item.quantity}</td><td align="right">${money(item.unitPrice)}</td><td align="right">${money(item.lineTotal)}</td></tr>`;
    }
    return string `<div style="font-family:Arial,sans-serif;max-width:520px">
<h2>Pizza Hub &ndash; Invoice</h2>
<p><b>Invoice:</b> ${invoice.invoiceId}<br>
<b>Bill to:</b> ${invoice.customerName}<br>
<b>Address:</b> ${invoice.billingAddress}<br>
<b>Email:</b> ${invoice.contactEmail}</p>
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%">
<tr><th align="left">Item</th><th>Qty</th><th align="right">Unit</th><th align="right">Total</th></tr>
${rows}
</table>
<p style="text-align:right">Subtotal: ${money(invoice.subTotal)}<br>
Delivery fee: ${money(invoice.deliveryFee)}<br>
Tax: ${money(invoice.tax)}<br>
<b>Total: ${money(invoice.total)}</b></p>
</div>`;
}
