class EmployeesController < ApplicationController
  def index
    @Employee = Employee.all
    render 'employees/index', :layout => "application"
  end
end
