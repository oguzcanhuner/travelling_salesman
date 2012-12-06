require_relative 'complete_graph'
#this is an attempt to solve the travelling salesman problem using an adapted version of the reinforcement learning algorithm

class AggregateSolve
  def initialize(iterations = 10)
    @grid = CompleteGraph.new :csv_path => 'example.csv'
    @iterations = iterations
  end

  def grid
    @grid
  end

  def run
    history = []
    @iterations.times do |i|
      history << solve_once
    end

    return find_optimal_solution(history)
  end

  def solve_once
    #since all nodes are connected, possible_nodes is initialised with all node indexes
    possible_nodes = (1..@grid.no_of_nodes-1).to_a

    edges = []
    last_node = 0

    # create an array of connected edges in the following format:
    # [[1,2],[2,4],[4,8]]
    @grid.no_of_nodes.times do |i|
      node = possible_nodes.sample ? possible_nodes.sample : 0
      edges << [last_node,node]
      possible_nodes.delete(node)
      last_node = node
    end

    #
    return {:result => edges, :score => calculate_score(edges)}
  end

  #given an array of edges, calculate the score of a single route
  def calculate_score(edges)
    scores = edges.collect! { |edge| @grid[edge]}
    return scores.inject(:+)
  end

  #given a set of iterations, return the most optimal (least cost) iteration
  def find_optimal_solution(edges)
    index = 0
    # start with the maximum score possible
    best = @grid.no_of_nodes * 100

    #iterate through the history of routes and find the best score
    edges.each_with_index do |val,i| 
      if val[:score] < best
        best = val[:score]
        index = i
      end
    end
    return edges[index]
  end
end

solver1 = AggregateSolve.new(8000)
# puts rl.grid
puts solver1.run

