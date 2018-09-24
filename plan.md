# PLAN

## LIFT BEHAVIOUR
- Go up to the first floor that has anybody on, and stop there (even if full)
pick up as many people as can fit in the lift capacity
- continue on same direction to next floor that (a) has people wanting to get on who pressed the relevant direction button or (b) is a destination of somebody in the lift
  - Let off anybody that wanted to get off there
  - pick up as many people who fit that are going in the same direction
- continue doing this until there are no destinations or customers further in that direction (i.e. empty and no customers further in that direction)
- change direction and move down, doing the same thing
- if ever empty and nobody queueing anywhere, go to ground floor

- input queues = list of lists
- create lift object
  - Instance variables:
    - capacity (can't be higher than max)
    - current floor
    - direction?
  - Methods:
    - Go up/down (maybe just 'move')
    stop at floor(?)
      - add floor to log of stops
    - collect person
    - remove person
    - check direction (of person)?
      - take their current and desired floor, and use that to find out if they're going up/down.

- create floor objects
  - Instance variables:
    - People = queue of people on floor
  - Methods
    - Call lift-->tells lift to come to floor
      - separate into up/down buttons?
