require 'rubygems'    
require 'active_record'    

RUN_DIR=Dir.pwd

ActiveRecord::Base.logger = Logger.new("#{RUN_DIR}/log/debug.log")
ActiveRecord::Base.configurations = YAML::load(IO.read("#{RUN_DIR}/conf/database.yml"))
ActiveRecord::Base.establish_connection(:mysql)

##  Example for the relationshiop:
##     There are 4 different geo location which are Region, Province, city and barangay.
##     All those are belongs to GeoType entity and have their own heraichy as below:
##         Region -> Provinces -> Cities -> barangays -> PoIs -> Stores
##

class GeoType < ActiveRecord::Base
    self.table_name = "operation.geo_type"

    has_many :barangays,     foreign_key: "type_id"
    has_many :citys,         foreign_key: "type_id"
    has_many :provinces,     foreign_key: "type_id"
    has_many :regions,       foreign_key: "type_id"
end

class Region < ActiveRecord::Base
    self.table_name = "operation.region"

    has_many :barangays,     foreign_key: "region_id"
    has_many :citys,         foreign_key: "region_id"
    has_many :provinces,     foreign_key: "region_id"
end

class Province < ActiveRecord::Base
    self.table_name = "operation.province"
    
    has_many :barangays,     foreign_key: "province_id"
    has_many :citys,         foreign_key: "province_id"
    
    belongs_to :region,      foreign_key: "region_id"
end

class City < ActiveRecord::Base
    self.table_name = "operation.city"
    has_many :barangays,     foreign_key: "city_id"
    has_many :pois,          foreign_key: "city_id"
    
    belongs_to :province,    foreign_key: "province_id"
    belongs_to :region,      foreign_key: "region_id"
end

class Barangay < ActiveRecord::Base
    self.table_name = "operation.barangay"
    has_many :pois,          foreign_key: "barangay_id"
    
    belongs_to :city,        foreign_key: "city_id"
    belongs_to :province,    foreign_key: "province_id"
    belongs_to :region,      foreign_key: "region_id"
end

class Poi < ActiveRecord::Base
    self.table_name = "operation.poi"
    has_many :stores,        foreign_key: "poi_id"
    
    belongs_to :city,        foreign_key: "city_id"
    belongs_to :barangay,    foreign_key: "city_id"
end

class Store < ActiveRecord::Base
    self.table_name = "operation.store"
    
    belongs_to :poi,        foreign_key: "poi_id"
    belongs_to :store_type, foreign_key: "store_type_id"
end

class StoreType < ActiveRecord::Base
    self.table_name = "operation.store_type"
    has_many :stores,   foreign_key: "store_type_id"
end
