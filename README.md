# Checkout Promotions

## The exercise

Our client is an online marketplace, here is a sample of some of the 
products available on our site:

```
Product code  | Name                   | Price
----------------------------------------------------------
001           | Lavender heart         | £9.25
002           | Personalised cufflinks | £45.00
003           | Kids T-shirt           | £19.95
```


Our marketing team want to offer promotions as an incentive for our customers to purchase these items.

If you spend over £60, then you get 10% off of your purchase. If you buy 2 or more lavender hearts then the price drops to £8.50.
Our check-out can scan items in any order, and because our promotions will change, it needs to be flexible regarding our promotional rules.

The interface to our checkout looks like this (shown in Ruby):

```
co = Checkout.new(promotional_rules)
co.scan(item)
co.scan(item)
price = co.total
```


Implement a checkout system that fulfills these requirements. Do this outside of any frameworks demonstrating your TDD approach.

```
Test data
---------
Basket: 001,002,003
Total price expected: £66.78

Basket: 001,003,001
Total price expected: £36.95

Basket: 001,002,001,003
Total price expected: £73.76
```

## My approach

### Test planning

Using Google's Attributes-Components-Capabilities model (https://code.google.com/archive/p/test-analytics/wikis/AccExplained.wiki)
as a reference, I came up with the following:

#### Attributes

* stable
* flexible

#### Components

* promotional_rule
* item
* basket

#### Capabilities

* promotional_rule is stable:
    * "It is possible to obtain the required promotional_rule"

* promotional_rule is flexible:
    * "Different promotions can be applied"
    * "Can be applied to the total price"
    * "Can be applied to different items based on their quantity"
    * "Can be a fixed value or a percentage"
    
* basket is stable: 
    * "Items must exist"
    * "Items can be added in any order"
    
    
### Implementation

I'm assuming the promotional_rules to come from an external source / API.
The client will require the promotion that's currently active
(either from server side in case of a web app or from within the app itself
in case of a mobile app).