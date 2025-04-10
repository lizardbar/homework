class Expense < ApplicationRecord
  validates :description, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true

  scope :by_month, ->(date) { where(date: date.beginning_of_month..date.end_of_month) }
  
  def self.total_amount
    sum(:amount)
  end
  
  def self.average_daily_expense(date)
    monthly_expenses = by_month(date)
    total = monthly_expenses.sum(:amount)
    days_in_month = Time.days_in_month(date.month, date.year)
    total / days_in_month
  end
  
  def self.top_expenses(limit = 3)
    order(amount: :desc).limit(limit)
  end
end
