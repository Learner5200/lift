class Floor
  @floors = [] # class object instance variable to hold the different floors
  class << self
    attr_accessor :floors
  end

  def initialize(floor_num, queues)
    Floor.floors << self # adds new floor to floors list
    @people_waiting = queues[floor_num] # gets the people waiting at that floor from the queues list provided
    @floor_num = floor_num # number of the floor, as an integer
    @directions = @people_waiting.map{ |person| get_direction(person)}.uniq # list of which directions people on the floor want to go to (which 'buttons' have been pushed) # NEED TO BE ABLE TO ALTER DIRECTIONS!!!!!
  end

  def get_direction(person_num)
    person_num > @floor_num ? "up" : "down"
  end
  attr_accessor :people_waiting, :floor_num, :directions
end

class Lift
  def initialize(capacity)
    @capacity = capacity
    @current_floor = Floor.floors[0] # starts the lift on the ground floor
    @direction = "up" # starts the lift going up
    @people = [] # will hold a list of the people in the lift, named according to their destination floor number
    @stop_log = [0] # will hold a list of all the stops made, starting with the ground floor
  end

# creates/updates a list of the next floors to stop on, in order
  def update_stops

    @stop_list = @people.dup # add any floor that someone in the lift has requested
    Floor.floors.each do |floor|
      floor.directions = floor.people_waiting.map{ |person| floor.get_direction(person)}.uniq # must update directions to prevent stopping on irrelevant floors
      @stop_list << floor.floor_num if floor.directions.include?(@direction)
    end # add any floor with people who are travelling in the right direction
    @stop_list = @stop_list.select{ |floor| @direction == "up" ? floor > @current_floor.floor_num : floor < @current_floor.floor_num } # filter out floors that aren't on the current path
    @stop_list = @stop_list.uniq.sort_by { |floor| (floor - @current_floor.floor_num).abs} # remove duplicates and sort by  distance from the lift
  end

  def reverse
    @direction = (@direction == "up") ? "down" : "up"
    puts "Reversing direction! Now going #{@direction}"
    collect # important to do this after reversing, as the conditions for collecting those on the current floor may now be met
  end

  def stop(floor)
    puts "Stopping at floor #{floor}"
    @current_floor = Floor.floors[floor]
    eject
    collect
    @stop_log << floor
  end

  def collect
    # adds people to list if there's space and they're going in the right direction
    puts "people waiting: #{@current_floor.people_waiting}"
    people_added = []
    @current_floor.people_waiting.each do |person|
      if (@people.length < @capacity) && (@current_floor.get_direction(person) == @direction)
        people_added << person
        @people << person
      end
    end
    # Need to delete the people we've added to the lift from people_waiting, independently of the iteration above.
    people_added.each do |person|
      @current_floor.people_waiting.delete_at(@current_floor.people_waiting.index(person))
    end
    puts "Collected #{people_added.length} passenger(s). The passengers now in the lift are heading to these floors: #{@people}.\n\n"
  end

  def eject
    number_ejected = @people.count(@current_floor.floor_num)
    @people.delete(@current_floor.floor_num)
    print "Dropped off #{number_ejected} passenger(s). "
  end

  def operate
    puts "Here we go!\n\n"
    collect # lift needs to collect people at the beginning, as the current floor is not on the stop list

    # We loop until there is nobody left in the lift or waiting on a floor
    until Floor.floors.all?{ |floor| floor.people_waiting.empty?} and @people.empty?
      update_stops
      puts "STOP LIST: #{@stop_list}"
      if @stop_list.empty?
        # if there's no floor left in the current direction that anyone on the lift wants to go to, we stop at the furthest floor in the current direction with anyone waiting on it, and reverse to sweep from the other direction.
        non_empty = Floor.floors.reject { |floor| floor.people_waiting.empty?}.map { |floor| floor.floor_num}
        puts "non-empty: #{non_empty}"
        valid_non_empty = non_empty.select{ |floor| @direction == "up" ? floor > @current_floor.floor_num : floor < @current_floor.floor_num }
        puts "valid non: #{valid_non_empty}"
        sorted_non_empty = valid_non_empty.sort_by { |floor| (floor - @current_floor.floor_num).abs }
        puts "sorted non-empty: #{sorted_non_empty}"
        last_stop = sorted_non_empty.last
        puts "last stop = #{last_stop}"
        stop(last_stop) unless last_stop == nil
        reverse
      else
        stop(@stop_list.shift) # stops at first floor on list, and removes it from the list
      end
    end
    puts "\n\nAll done! Returning to the ground floor."
    @stop_log << 0 unless @current_floor.floor_num == 0 # ends at the ground floor.
    @stop_log
  end
end

def the_lift(queues, capacity)
  Floor.floors = []
  (0...queues.length).each { |num| Floor.new(num, queues) }
  lift = Lift.new(capacity)
  lift.operate
end

puts the_lift([[], [0, 0, 0, 6], [], [], [], [6, 6, 0, 0, 0, 6], []], 5)
