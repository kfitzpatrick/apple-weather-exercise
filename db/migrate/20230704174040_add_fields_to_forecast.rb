class AddFieldsToForecast < ActiveRecord::Migration[7.0]
  def change
    add_column :forecasts, :name, :string
    add_column :forecasts, :is_day_time, :boolean
    add_column :forecasts, :start_time, :datetime
    add_column :forecasts, :end_time, :datetime
  end
end
