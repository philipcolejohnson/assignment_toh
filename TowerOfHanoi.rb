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
    puts "Current Board:"
    puts "#{@disks}"
  end

  #get input from the user and check for validity
  def input_move
    try_again=true

    while (try_again)
      try_again=false

      print "From which pedestal would you like to move (or press 'q' to quit)? : "
      user_input = gets.chomp
      if invalid?(user_input)
        try_again = true 
        puts "Invalid. Please try again."
      end
    end

    user_input
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
    puts "Welcome to the Tower of Hanoi!"
    

    keep_playing = true
    #loop until user quits with a "q"
    while (keep_playing) do
      #render the current board
      self.render
      
      #ask for input and check to make sure it is valid
      try_again=true

      while (try_again)
        try_again=false

        print "From which pedestal (1-3) would you like to move (or press 'q' to quit)? : "
        from = gets.chomp

        case from.downcase
        when 'q'
          puts "You made #{@moves} moves. Bye!"
          exit
        when /[1-3]/
          puts "Okay."
        else
          puts "Sorry. That's not a valid choice. Please try again."
          try_again=true
        end

        from = from.to_i

        if @disks[from-1].size == 0
          try_again=true
          puts "Sorry, that pedestal is empty. Try another."
        end
      end

      

      #ask for input and check to make sure it is valid
      try_again=true

      while (try_again)
        try_again=false

        print "And to which pedestal (1-3) do you want to move it (or press 'q' to quit)? : "
        to = gets.chomp

        case to.downcase
        when 'q'
          exit
          puts "You made #{@moves} moves. Bye!"
        when /[1-3]/
          puts "Nice."
        else
          puts "Sorry. That's not a valid choice. Please try again."
          try_again=true
        end

        # binding.pry
        to = to.to_i

        if (@disks[to-1][0]!=nil) && (@disks[from-1].last > @disks[to-1].last)
          puts "Sorry, Dave. I'm afraid you can't do that." 
          puts "You can only move smaller rings onto larger ones."
          try_again=true
        end
      end

      #move a disk if possible, otherwise ask for new input
      @disks[to-1] << @disks[from-1].pop
      @moves += 1

      #check for win
      if @disks[2].size == @size
        puts "You win! It took you #{@moves} moves."
        exit
      end
    end

    
  end
end

t = TowerOfHanoi.new(3)
t.play