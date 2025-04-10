class ExpensesController < ApplicationController
  def index
    @current_date = params[:date] ? Date.parse(params[:date]) : Date.current
    @expenses = Expense.by_month(@current_date)
    @total_amount = @expenses.total_amount
    @average_daily = @expenses.average_daily_expense(@current_date)
    @top_expenses = @expenses.top_expenses
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    
    if @expense.save
      redirect_to expenses_path, notice: 'Expense was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:description, :amount, :date)
  end
end
