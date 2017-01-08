module Locationize
	extend ActiveSupport::Concern
	included do
    	include Mongoid::Document
    	after_save do |document|
    		l = Location.new
    	end
    end
end