class Rider
	include Mongoid::Document
end

##the order can be tied into the user.
##the user can later on add or remove more tests.
##so it can be like 
##product 
##cart
##products should be addable(to the product database)
##there can be a dropdown which lists the tests(products.)
##we can then choose either one or more than one.
##what if we want to order for many people.
##so we should have "add a test for my friends/relatives."
##before the test 
##so we can give something Cart Concern.
##then it can be added to a cart
##it can be removed from a cart
##and a cart object will exist in the session and carry all this information
##cart an accept a user_id to connect the orders with the user.
