# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
Product.delete_all

Product.create(:title => 'Test Product 2.0'
  :description =>
    %{<p>
        This test product is the testiest ever!
      </p>},
  :image_url => 'images/test.jpg',
  :price => 12.50)
  