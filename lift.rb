class Floor
  @@queues = [
    [3, 4, 5],
    [1, 2],
    [7, 8]
  ]
  @@floors = []

  def initialize(floor_num)
    @people = @@queues[floor_num]
    @floor_num = floor_num
    @@floors << self
  end



  attr_reader :people, :floor_num, :floors
end

class Lift
  def initialize(capacity)
    @capacity = capacity
    @current_floor = 0
    @direction = "up"
    @people = []
    @stop = []
  end

  def stop(floor)
    @current_floor = floor
    collect
    eject
    @stop_log << floor # .floor_num, maybe?
  end

  def get_direction(person_num)
    person_num > @current_floor.floor_num ? "up" : "down"
  end

  def collect
    @current_floor.people.each do |person|
      if @people.length < @capacity && get_direction(person) == @direction
        @people << person
        @current_floor.people.delete_at(@current_floor.people.index(person))
      end
    end
  end

  def eject
    @people.delete(@current_floor.floor_num)
  end

  def stop_logic
    while true
      
    end
  end

end
