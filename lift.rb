Queues = [
  [3, 2, 1],
  [3, 2],
  [],
  [1, 1]
]

class Floor

  @floors = []

  class << self
    attr_accessor :floors
  end

  def initialize(floor_num, queues)
    Floor.floors << self
    @people_waiting = queues[floor_num]
    @floor_num = floor_num
    @directions = @people_waiting.map { |person| get_direction(person) }.uniq


  end

  def get_direction(person_num)
    person_num > @floor_num ? "up" : "down"
  end


  attr_accessor :people_waiting, :floor_num, :directions
end

class Lift
  def initialize(capacity)
    @capacity = capacity
    @current_floor = Floor.floors[0]
    @direction = "up"
    @people = []
    @stop_log = []
    @stop_list = []
    update_stops
  end

  def reverse
    @direction = (@direction == "up") ? "down" : "up"
    puts "Reversing direction! Now going #{@direction}"
    collect
  end


  def stop(floor)
    puts "Stopping at floor #{floor}"
    @current_floor = Floor.floors[floor]
    eject
    collect
    @stop_log << floor # .floor_num, maybe?
  end



  def collect
    people_added = []
    @current_floor.people_waiting.each do |person|
      if (@people.length < @capacity) && (@current_floor.get_direction(person) == @direction)
        people_added << person
      end
    end
    people_added.each do |person|
      @current_floor.people_waiting.delete_at(@current_floor.people_waiting.index(person))
    end
    @people += people_added
    puts "Collected #{people_added.length} people. The following people are now in the lift: #{@people}."
  end

  def eject
    number_ejected = @people.count(@current_floor.floor_num)
    @people.delete(@current_floor.floor_num)
    puts "#{number_ejected} people got off."
  end

  def update_stops
    @stop_list = @people.dup # add any floor that someone has requested
    Floor.floors.each { |floor| @stop_list << floor.floor_num unless floor.people_waiting.empty? } # add any floor with people who need to go somewhere (we won't let them on unless they're going the right way!)
    @stop_list = @stop_list.select{ |floor| @direction == "up" ? floor > @current_floor.floor_num : floor < @current_floor.floor_num }.uniq.sort_by { |floor| (floor - @current_floor.floor_num).abs} # filter out floors that aren't on the current path
  end

  def operate
    puts "Here we go!\n\n"
    stop(0)
    while true
      if @stop_list.empty?
        reverse
        update_stops
        break if @stop_list.empty?
      end
      stop(@stop_list.shift)
      update_stops
      puts "Setting off again! Here's our stop list: #{@stop_list}\n\n"
    end
    puts "\n\nAll done! Returning to the ground floor."
    stop(Floor.floors[0].floor_num)
    @stop_log
  end

end

def lift(queues, capacity)
  (0...queues.length).each { |num| Floor.new(num, queues) }
  lift = Lift.new(capacity)
  lift.operate
end


puts lift(Queues, 4)
