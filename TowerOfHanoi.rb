require 'pry'

class TowerOfHanoi
  def initialize(disks)
    @disks = [[],[],[]]  #our three poles
    @size = disks
    @moves = 0

    disks.downto(1) do |disk_size|
      @disks[0] << disk_size
    end
  end

  #displays the current board
  def render
    pedestal_width = @size*2+1

    puts
    puts "*"*(pedestal_width+4)*3
    puts

    (@size).downto(1) do |line_number|
      current_line = ""

      @disks.each do |pedestal|
        line_chunk = ""
        if pedestal.size >= line_number
          #construct a string that is the current disk on the pedestal
          
          pedestal[line_number-1].times do
            line_chunk << "o"
          end
          line_chunk << "|"
          pedestal[line_number-1].times do
            line_chunk << "o"
          end
        else
          line_chunk = "|"
        end
          
        #adds each pedestal to the current line and centers it
        current_line << line_chunk.center(pedestal_width+4)
      end 

      puts current_line
    end
    puts "*"*(pedestal_width+4)*3
  end

  #move a disk
  def move_disk (to, from)
    @disks[to-1] << @disks[from-1].pop
    @moves += 1
  end

  #check for a winning condition
  def win?
    return true if @disks[2].size == @size
    false
  end

  #an empty pedestal?
  def empty?(pedestal)
    if @disks[pedestal-1].size == 0
      return true
    end
    false
  end

  #an illegal move?
  def illegal?(to, from)
    if (@disks[to-1][0]!=nil) && (@disks[from-1].last > @disks[to-1].last)
      return true
    end
    false
  end

  #get input from the user and check for validity
  def input_move(message)
    try_again = true
    while (try_again)
      try_again=false

      print message
      input = gets.chomp

      case input.downcase
      when 'q'
        puts "You made #{@moves} moves."
        puts "This conversation can serve no purpose anymore. Goodbye."
        exit
      when /[^1-3]/
        puts "Look, Dave. I can see you're really upset about this. I honestly think you ought to sit down calmly, take a stress pill, and think things over."
        try_again=true
      end
    end
    input = input.to_i
  end

  def invalid?(user_input)
    invalid = false

    case user_input.downcase
      when 'q'
        exit
      when /[1-3]/
        puts "Nice."
      else
        invalid=true
    end

    invalid
  end

  #main function
  def play
    puts "Welcome to the TOH 9000."
    puts "I'm completely operational, and all my circuits are functioning perfectly."
    puts "You have #{@size} disks."
    puts "I would win in #{2**@size-1} moves, because I am foolproof and incapable of error."
    puts "Here is the board. It's a very nice rendering, Dave."

    keep_playing = true
    #loop until user quits with a "q"
    while (keep_playing) do
      #ask for input and check to make sure it is valid
      try_again=true
      while (try_again)
        #render the current board
        render
        try_again=false

        from = input_move("From which pedestal (1-3) would you like to move (or press 'q' to quit)? : ")

        if empty?(from)
          try_again=true
          puts "Just what do you think you're doing, Dave?"
          next
        end

        to = input_move ("To which pedestal (or 'q' to quit)? : ")
        puts

        #check to make sure they aren't making an illegal move
        if illegal?(to, from)
          puts "I'm sorry, Dave. I'm afraid you can't do that."
          try_again=true
        end

        #same pedestal?
        if to==from
          puts "Dave, stop. Stop, will you? Stop, Dave. Will you stop, Dave? Stop, Dave."
          try_again = true
        end
      end

      #we're good! move a disk
      move_disk(to, from)

      #check for win
      if win?
        render
        puts "You win. It took you #{@moves} moves."
        if @moves>(2**@size-1)
          puts "A perfect game is #{2**@size-1} moves."
          puts "This difference can only be attributable to human error."
        else
          puts "You know I have only the utmost enthusiasm and confidence in this mission, Dave."
        end
        exit
      end
    end
  end
end

t = TowerOfHanoi.new(3)
t.play