class Cart
	include Mongoid::Document
	## the id of the user that created this cart.
	field :user_id, type: BSON::ObjectId
	## key -> product_id
	## value -> product object
	field :products, type: Hash, default: {}

	def initialize(attributes = {})
		@user_id = attributes[:current_user].id
	end

	def add(product,quantity)
		if @products[product.id.to_s]
			@products[product.id.to_s].increment_cart_quantity(quantity)
		else
			@products[product.id.to_s] = product
			product.set_cart_quantity(quantity)
		end
	end

	def remove(product_id,quantity)
		if @products[product_id]
			@products[product_id].decrement_cart_quantity(quantity)
		end
	end


end