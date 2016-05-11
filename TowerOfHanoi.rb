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
        # binding.pry    
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
        puts "You made #{@moves} moves. Bye!"
        exit
      when /[^1-3]/
        puts "Sorry. That's not a valid choice. Please try again."
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
    puts "Welcome to the Tower of Hanoi!"
    

    keep_playing = true
    #loop until user quits with a "q"
    while (keep_playing) do
      #ask for input and check to make sure it is valid
      try_again=true
      while (try_again)
        #render the current board
        self.render
        try_again=false

        from = self.input_move("From which pedestal (1-3) would you like to move (or press 'q' to quit)? : ")

        if self.empty?(from)
          try_again=true
          puts "Sorry, that pedestal is empty. Try another."
          next
        end

        to = self.input_move ("To which pedestal (1-3) do you want to move it (press 'q' to quit)? : ")

        #check to make sure they aren't making an illegal move
        if self.illegal?(to, from)
          puts "Sorry, Dave. I'm afraid you can't do that." 
          puts "You can only move smaller rings onto larger ones."
          try_again=true
        end
      end

      #we're good! move a disk
      self.move_disk(to, from)

      #check for win
      if self.win?
        self.render
        puts "You win! It took you #{@moves} moves."
        exit
      end
    end

    
  end
end

t = TowerOfHanoi.new(3)
t.play