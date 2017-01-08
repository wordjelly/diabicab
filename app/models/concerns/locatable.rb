module Locatable
	extend ActiveSupport::Concern
	included do
    	include Mongoid::Document
    	include MongoidVersionedAtomic::VAtomic
    	include Elasticsearch::Model
  		include Elasticsearch::Model::Callbacks
  		include Elasticsearch::Model::Indexing
    	field :lat , type: Float
    	field :lon , type: Float
    	field :time, type: Integer
    	field :parent_id, type: String

    	mapping do
		   indexes :location, type: 'geo_point'
		   indexes :time, type: 'date'
		   indexes :parent_id, type: 'string'
		end

		DEFAULT_DISTANCE = 1000

		def as_indexed_json(_options = {})
		    as_json(only: %w(time parent_id)).merge(
		      location: {
		        lat: lat.to_f, lon: lon.to_f
		      }
			)
		end

	end

	module ClassMethods

		## adds a post-filter to the query, to show only those docs which are within the range defined for the range filter.
		## @params[Hash] request_body :  the entire search request body.
		## @params[Hash] options : must contain a :lat entry, and a :lon entry, both of which should be floats.
		## @returns[Hash]: nil if the options hash doesn't contain lats or longs.
		## otherwise returns the updated request body.
		def build_search(request_body = nil,options = {})
			request_body ||= {
				query: {
					match_all: {

					}
				}
			}

			return nil if (options[:lat].nil? || options[:lon].nil?)
			options[:distance] ||= DEFAULT_DISTANCE

	    	##check if post filter already exists
	    	##if it has either "and" or "bool"
	    	##if it has "and", then add the current definition
	    	if request_body[:post_filter].nil?
	    		request_body[:post_filter] = {
	    			bool: {
	    				must: [
	    					distance_filter(options)
	    				]
	    			}
	    		}
	    	else
	    		if request_body[:post_filter][:and]
	    			request_body[:post_filter][:and][:filters] << distance_filter(options)
	    		elsif request_body[:post_filter][:bool]
	    			if request_body[:post_filter][:bool][:must]
	    				##if its an array then 
	    				if request_body[:post_filter][:bool][:must].is_a? Array
	    					request_body[:post_filter][:bool][:must] << distance_filter(options)
	    				else
	    					ar = [request_body[:post_filter][:bool][:must],distance_filter(options)]
	    					request_body[:post_filter][:bool][:must] = ar
	    				end
	    			else
	    				request_body[:post_filter][:bool][:must] = [distance_filter(options)]
	    			end
	    		else
	    			##otherwise take whatever is there in the post filter and convert it to a bool must clauses multiple filter.
	    			request_body[:post_filter] = {
	    				bool: {
	    					must: [
	    						request_body[:post_filter], distance_filter(options)
	    					]
	    				}
	    			}
	    		end
	    	end
	    	request_body
		end

		##@params[Hash] options : the options passed into the build_search method
		##@returns[Hash] geo_distance query.
		def distance_filter(options) 
			{
				geo_distance: {
	              distance: "#{options[:distance]}km",
	              location: {
	                lat: options[:lat].to_f,
	                lon: options[:lon].to_f
	              }
	            }
	    	}		
		end

	end

end