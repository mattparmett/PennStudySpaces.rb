# Ruby gem to interface with v1 of the pennstudyspaces api
require 'json'
require 'open-uri'

class PennStudySpaces
  def initialize(api_root = "http://pennstudyspaces.com/api?")
    @api_root = api_root
  end
  
  def query(args)
    # Return array of buildings
    if args.is_a? Hash
      api_url = "#{@api_root}capacity=#{args['capacity']}&shr=#{args['shr']}&smin=#{args['smin']}&ehr=#{args['ehr']}&emin=#{args['emin']}&date=#{args['date']}&format=json"
    elsif args.is_a? String
      api_url = @api_root + args
    end
    
    response = JSON.parse(open(api_url).read)
    buildings = []
    response['buildings'].each do |building_json|
      buildings << Building.new(building_json)
    end
    buildings
  end
  
  def json(args)
    if args.is_a? Hash
      api_url = "#{@api_root}capacity=#{args['capacity']}&shr=#{args['shr']}&smin=#{args['smin']}&ehr=#{args['ehr']}&emin=#{args['emin']}&date=#{args['date']}&format=json"
    elsif args.is_a? String
      api_url = @api_root + args
    end
    
    JSON.pretty_generate(JSON.parse(open(api_url).read))
  end
end

class Building
  attr_accessor :latitude, :longitude, :name, :roomkinds
  
  def initialize(building_json)
    @latitude = building_json['latitude']
    @longitude = building_json['longitude']
    @name = building_json['name']
    @roomkinds = []
    building_json['roomkinds'].each do |roomkind_json|
      @roomkinds << RoomKind.new(roomkind_json)
    end
  end
  
  def rooms()
    rooms = []
    @roomkinds.each do |rk|
      rk.rooms.each do |r|
        rooms << r
      end
    end
    rooms
  end
end

class RoomKind
  attr_accessor :has_big_screen, :reserve_type, :has_computer, :name, :privacy, :has_whiteboard, :max_occupancy, :comments, :rooms
  
  def initialize(roomkind_json)
    attrs = %w(has_big_screen reserve_type has_computer name privacy has_whiteboard max_occupancy comments)
    attrs.each do |attr|
      self.instance_variable_set("@#{attr}", roomkind_json[attr])
    end
    
    @rooms = []
    roomkind_json['rooms'].each do |room_json|
      @rooms << Room.new(room_json)
    end
end
end

class Room
  attr_accessor :availabilities, :name, :id
  
  def initialize(room_json)
    @name = room_json['name']
    @id = room_json['id']
    @availabilities = []
    room_json['availabilities'].each do |date, avail_array|
      @availabilities << Availability.new(date, avail_array)
    end
  end
end

class Availability
  attr_accessor :date, :hours, :free_times
  
  def initialize(date, avail_array)
    # avail_array = [hours, [availabilities]]
    @date = Date.parse(date)
    @hours = avail_array[0]
    @free_times = avail_array[1]
  end
end