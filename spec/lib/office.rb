class Office
  attr_accessor :name, :employees, :address

  def initialize(data)
    @name = data[:name]
    @employees = 10
    @address = data[:address]
  end
  
  def get_location
    @address
  end
end
