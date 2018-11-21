require 'byebug'

module Menu

  def menu
    "Please choose from the following options:
    1) Add
    2) Show
    3) Delete
    4) Update
    5) Write to a File
    6) Read from a File
    7) Toggle Status
    Q) Quit "
  end

  def show
    puts self.menu
  end

end


module Promptable

  def prompt(message='What would you like to do?', symbol=':> ')
    print message + ' ' + symbol
    gets.chomp
  end

end


class List

  attr_reader :all_tasks

  def initialize
    @all_tasks = []
  end

  def add(task)
    @all_tasks << task
  end

  def show
    @all_tasks.map.with_index do |task_object, i|
      stat = task_object.completed? ? '[X]' : '[ ]'
      "#{i.next}) #{task_object.description} #{stat}"
    end
  end

  def read_from_file(filename)
    IO.readlines(filename).each do |line|
      line_split = line.split(':').map(&:strip)
      description = line_split[1]
      status = line_split[0].include?('X')
      task = Task.new(description, status)
      self.add(task)
    end
  end

  def write_to_file(filename)
    task_list = @all_tasks.map(&:to_machine).join("\n")
    IO.write(filename, task_list)
  end

  def delete(task_number)
    deleted_task = @all_tasks.delete_at(task_number - 1)
    puts "'#{deleted_task.description}' task deleted!"
  end

  def update(task_number, task)
    @all_tasks[task_number - 1] = task
    puts "Task ##{task_number} is now '#{@all_tasks[task_number - 1].description}'"
  end

  def toggle(task_number)
    @all_tasks[task_number - 1].toggle_status
    stat = @all_tasks[task_number - 1].completed? ? 'completed' : 'active'
    puts "Task #{task_number} now #{stat}"
  end

end


class Task

  attr_reader :description
  attr_accessor :status

  def initialize(description, status=false)
    @description = description
    @status = status
  end

  def completed?
    status
  end

  def to_machine
    represent_status + " : " + @description
  end

  def toggle_status
    @status = !self.completed?
  end

  private

  def represent_status
    self.completed? ? '[X]' : '[ ]'
  end

end



if $PROGRAM_NAME == __FILE__
  include Menu
  include Promptable
  my_list = List.new
  puts 'Welcome!'
  while true
    show
    user_input = prompt.downcase
    case user_input
      when '1'
        my_list.add(Task.new(prompt('What is the task you would like to accomplish?')))
        puts 'You have added a task to the Todo List'
      when '2'
        puts
        puts
        puts my_list.show
        puts
        puts
      when '3'
        puts
        puts
        puts my_list.show
        puts
        puts
        my_list.delete(prompt("Which task to delete?").to_i)
      when '4'
        puts
        puts
        puts my_list.show
        puts
        puts
        task_number = prompt('Which task to update?').to_i
        task = Task.new(prompt('What is the new task?'))
        my_list.update(task_number, task)
      when '5'
        my_list.write_to_file(prompt('Name of file to write to?'))
      when '6'
        my_list.read_from_file(prompt("Name of file to read from?"))
      when '7'
        puts
        puts
        puts my_list.show
        puts
        puts
        my_list.toggle(prompt('Which task to toggle?').to_i)
      when 'q'
        break
      else
        puts 'Sorry, I did not understand'
      end
  end
  puts 'Outro - Thanks for using the menu system!'
end
