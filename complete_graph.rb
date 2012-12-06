require "csv"
# This class is responsible for creating a complete graph in the form of a hash which holds distances between nodes.
# A complete graph is a set of nodes where each node is connected to another.

# USAGE: CompleteGraph.new :csv_path => path, :size => int
# You can supply either a csv file or a static number of nodes
class CompleteGraph < Hash

  def initialize(options = {})
    coords = []
    @size = options[:size] ? options[:size] : 0
    if options[:csv_path]
      #todo: add some error handling here
      coords = CSV.read(options[:csv_path])
      @size = coords.size
      coords.collect!{|coord| [coord[0].to_i,coord[1].to_i] }
    else
      coords = create_random_coordinates(options[:size])
    end
    generate_graph(coords)
    # Don't allow the hash to be changed after creation
    self.freeze
  end

  #todo: this shouldn't be a method
  def no_of_nodes
    @size
  end

  private

  # Calculate the euclidean distance between two coordinates
  def euc_2d(c1, c2)
    Math.sqrt((c1[0] - c2[0])**2.0 + (c1[1] - c2[1])**2.0).round
  end

  # Create a 'size' number of coordinates in the form of an array of arrays.
  # e.g. [[12,34],[1,32],[2,13]]
  # These can be used to plot the coordinates on to a 2d plane in the future.
  def create_random_coordinates(size)
    coords = []
    size.times do
      x = rand(99) + 1
      y = rand(99) + 1
      
      coords << [x,y]
    end
    return coords
  end

  # Given a set of 2d coordinates, generate all distances between nodes.
  def generate_graph(coords)
    coords.each_with_index do |coord1, i|
      coords.each_with_index do |coord2, j|
        if i == j
          self[[i,j]] = '-'
        else
          self[[i,j]] = euc_2d(coord1, coord2)
        end
      end
    end
  end
  
end