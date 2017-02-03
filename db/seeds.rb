# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

=begin
## full tutorial is at:
## http://ericlondon.com/2015/06/25/rails-4-elasticsearch-geospatial-searching-and-model-integration.html

## =>  First make sure you recreate the index, so that all mappings are properly defined
Location.__elasticsearch__.create_index! force: true

## =>  now populate the database by doing this 
bundle exec rake db:seed  

## => now you can search for a location as follows, by running in rails console.
Location.__elasticsearch__.search(Location.build_search(nil,{:lat => 78.2, :lon => 81.2})).results.map &:_source

## => explanation:
the search body is built by calling Location.build_search(request_body, options)
since we pass in nil for request body, the build_search method adds a match_all query as the default query, and then builds the post_filter based on the options hash.
after that we call results.map &:_source, this basically maps each result to just give its source.

=end

100.times do |n|
	r = Rider.new
	r.save!
	l = Location.new({
	  lat: rand(-90.0..90.0),  
      lon: rand(-180.0..180.0),
      time: Time.now.to_i,
      parent_id: r.id.to_s
	})
    l.save!
    l1 = Location.new({
	  lat: rand(-90.0..90.0),  
      lon: rand(-180.0..180.0),
      time: Time.now.to_i,
      parent_id: r.id.to_s
	})
    l1.save!
end