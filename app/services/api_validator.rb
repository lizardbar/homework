class ApiValidator
  API_URL = 'https://fakestoreapi.com/products'

  def self.validate_products
    response = HTTParty.get(API_URL)
    
    return { error: "API request failed with status: #{response.code}" } unless response.success?

    products = JSON.parse(response.body)
    defects = []

    products.each do |product|
      defects << validate_product(product)
    end

    {
      status: response.code,
      total_products: products.size,
      defects: defects.compact,
      last_checked: Time.current
    }
  end

  private

  def self.validate_product(product)
    defects = []
    
    # Check title
    defects << "Product ID #{product['id']}: Empty title" if product['title'].to_s.strip.empty?
    
    # Check price
    defects << "Product ID #{product['id']}: Negative price" if product['price'].to_f < 0
    
    # Check rating
    if product['rating'] && product['rating']['rate']
      defects << "Product ID #{product['id']}: Rating exceeds 5" if product['rating']['rate'].to_f > 5
    end

    defects.join(', ') unless defects.empty?
  end
end 