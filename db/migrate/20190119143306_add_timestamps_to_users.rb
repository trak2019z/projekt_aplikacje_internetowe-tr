class AddTimestampsToUsers < ActiveRecord::Migration
  def change
    add_timestamps :services_visits
  end
end
