class CategoriesRepresenter
  attr_reader :categories

  def initialize(categories)
    @categories = categories
  end

  def as_json
    categories.map { |category| { id: category.id, name: category.name } }
  end
end
