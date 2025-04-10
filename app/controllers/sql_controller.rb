class SqlController < ApplicationController
  def results
    sql_service = SqlService.new
    results = sql_service.run_queries
    sql_service.reset_database
    
    render json: {
      march_sales: results[:march_sales],
      top_customer: results[:top_customer],
      avg_order: results[:avg_order]
    }
  end
end 