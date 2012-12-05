require_relative 'complete_graph'
#this is an attempt to solve the travelling salesman problem using an adapted version of the reinforcement learning algorithm

class Rl
  def initialize(iterations = 10)
    @grid = CompleteGraph.new :csv_path => 'example.csv'
    @iterations = iterations
  end

  def grid
    @grid
  end

  def solve_once
    possible_nodes = (1..@grid.no_of_nodes-1).to_a
    history = []
    last_node = 0
    @grid.no_of_nodes.times do |i|
      node = possible_nodes.sample ? possible_nodes.sample : 0
      history << [last_node,node]
      possible_nodes.delete(node)
      last_node = node
    end
    return {:result => history.inspect, :score => calculate_score(history)}
  end

  def calculate_score(array)
    array_of_scores = array.collect! { |coord| @grid[coord]}
    return array_of_scores.inject(:+)
  end

  def aggregate_solve
    history = []
    @iterations.times do |i|
      history << solve_once
    end
    return history
  end
end

rl = Rl.new(8000)
# puts rl.grid
history = rl.aggregate_solve
# puts history
# puts "+++"
best = 1000000000
index = 0
history.each_with_index do |val,i| 
  if val[:score] < best
    best = val[:score]
    index = i
  end
end
puts history[index]

