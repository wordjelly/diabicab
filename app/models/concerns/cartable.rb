module Cartable
	extend ActiveSupport::Concern
	included do
    	include Mongoid::Document
    	include MongoidVersionedAtomic::VAtomic
    	include Elasticsearch::Model
  		include Elasticsearch::Model::Callbacks
  		include Elasticsearch::Model::Indexing
    	
    	## @used_in : cartable.rb
    	## @return[Cart] : a cart object from the session, creating one if it does not already exist.
    	def set_cart
    		if session[:cart].nil?
    			session[:cart] = Cart.new({:current_user => current_user})
    		end
    		session[:cart]
    	end

    	## @used_in : cartable.rb
    	## @return[Cart] : a cart instance or nil if none exists in the session.
    	def get_cart
    		session[:cart]
    	end

    	## @used_in : controllers/models
    	## @param[Product] product : a product instance.
    	## @param[Integer] quantity : the quantity of this product to add, defaults to one
    	## @return[Cart] cart : returns the cart
  		def add_to_cart(product,quantity=1)
  			cart = set_cart
  			cart.add(product,quantity)
  			cart
  		end

  		## @used_in : controllers/models
  		## @param[Product] product : a product instance
  		## @param[Integer] quantity : the quantity of this product to remove, defaults to one
  		## @return[Cart] cart : returns the cart 
  		def remove_from_cart(product_id,quantity=1)
  			if cart = get_cart
  				cart.remove(product_id,quantity)
  			end
  			cart
  		end

    end

end