# Order

For all exchange orders, it must have a %Order{} saved in db

Sometimes an %Order{} does not have a %Purchase{} because a purchase order has been make outside of pex. In this case, you have to insert a purchase and edit all the %Order{}
