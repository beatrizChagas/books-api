class CategoryRepresenter
  attr_reader :category

  def initialize(category)
    @category = category
  end

  def as_json
    { id: category.id, name: category.name }
  end
end
