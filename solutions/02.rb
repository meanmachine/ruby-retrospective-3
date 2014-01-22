class Criteria

  attr_reader :block

  def initialize(block)
    @block = block
  end

  def Criteria.status(status)
    Criteria.new(->(task) { task.status == status })
  end

  def Criteria.priority(priority)
    Criteria.new(->(task) { task.priority == priority })
  end

  def Criteria.tags(tags)
    Criteria.new(->(task) { task.has_all_tags? tags })
  end

  def &(criteria)
    Criteria.new(->(task) { criteria.block.call(task) and @block.call(task) })
  end

  def |(criteria)
    Criteria.new(->(task) { criteria.block.call(task) or @block.call(task) })
  end

  def !()
    Criteria.new(->(task) { not @block.call(task) })
  end
end

class Task

  attr_reader :status
  attr_reader :description
  attr_reader :priority
  attr_reader :tags

  def initialize(status, description, priority, tags = [])
    @status      = status.strip.downcase.to_sym
    @description = description.strip
    @priority    = priority.strip.downcase.to_sym
    @tags        = tags.split(",").map(&:strip)
  end

  def has_all_tags?(tags)
    tags.all? { |tag| self.tags.include? tag }
  end

  def <=>(task)
    task_as_list = [task.status, task.description, task.priority, task.tags]
    [@status, @description, @priority, @tags] <=> task_as_list
  end
end

class TodoList

  include Enumerable

  attr_reader :todo_list

  def initialize(todo_list)
    @todo_list = todo_list
  end

  def TodoList.parse(raw_todo_list)
    todo_list = raw_todo_list.lines.map do |task|
      Task.new *task.split('|')
    end
    TodoList.new(todo_list)
  end

  def filter(criterias)
    TodoList.new(@todo_list.select { |task| criterias.block.call task })
  end

  def adjoin(todo_list_object)
    TodoList.new(@todo_list + todo_list_object.todo_list)
  end

  def each
    @todo_list.each do |task|
      yield task
    end
  end

  def tasks_todo
    filter(Criteria.status(:todo)).todo_list.length
  end

  def tasks_in_progress
    filter(Criteria.status(:current)).todo_list.length
  end

  def tasks_completed
    filter(Criteria.status(:done)).todo_list.length
  end

  def completed?
    @todo_list.all? { |task| task.status == :done }
  end
end

# Examples--------------------------------------------------------------

text = "TODO    | Eat spaghetti.               | High   | food, happiness
TODO    | Get 8 hours of sleep.        | Low    | health
CURRENT | Party animal.                | Normal | socialization
CURRENT | Grok Ruby.                   | High   | development, ruby
DONE    | Have some tea.               | Normal |
TODO    | Destroy Facebook and Google. | High   | save humanity, conspiracy
TODO    | Hunt saber-toothed cats.     | Low    | wtf
DONE    | Do the 5th Ruby challenge.   | High   | ruby course, FMI, development, ruby
TODO    | Find missing socks.          | Low    |
CURRENT | Grow epic mustache.          | High   | sex appeal"

s = TodoList.parse(text)

s.each { |x| puts "#{x.status}, #{x.description}, #{x.priority}, #{x.tags}" }

puts "5555555555555555555555555555555555555555555555555555555555555555555555"

s.sort.each { |x| puts "#{x.status}, #{x.description}, #{x.priority}, #{x.tags}" }
puts "5555555555555555555555555555555555555555555555555555555555555555555555"

s.filter(Criteria.status(:todo) | Criteria.priority(:high)).each { |x| puts "#{x.status}, #{x.description}, #{x.priority}, #{x.tags}" }
puts "=---------------------------------------------------------------"
s.filter(Criteria.tags(%w[development FMI])).each { |x| puts "#{x.status}, #{x.description}, #{x.priority}, #{x.tags}" }
puts "======================================="
p s.tasks_todo
p s.tasks_in_progress
p s.tasks_completed
p s.completed?