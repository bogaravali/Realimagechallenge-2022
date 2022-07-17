class SolutionOneController < ActionController::Base

require 'csv'


def solution_one_csv

#getting all possible and impossible deliveries into csv file
    
    d_patners = get_patners
    input_file = get_deliveries
    
    output = []
    input_file.each_with_index do |delivery|
      minimum_value_cost = ["", Float::INFINITY]
      delivery_status = false
      d_patners[delivery[2]].each do |delivery_patner|
        if delivery_patner[0] < delivery[1] && delivery[1] < delivery_patner[1];
          delivery_status = true
          actual_cost = delivery[1] * delivery_patner[3]
          cost = actual_cost > delivery_patner[2] ? actual_cost : delivery_patner[2]
          minimum_value_cost = [delivery_patner.last, cost] if cost < minimum_value_cost[1]
        end
      end
      if delivery_status
        output << [delivery[0], delivery_status] + minimum_value_cost
      else
        output << [delivery[0], delivery_status, "", ""]
      end
    end
    write_output("public/output1.csv", output)
    output

    redirect_to welcome_csv_download_success_path
   # render '/csv_download_success'
    #render body: nil, status: :not_found      
end



def get_patners
    
    partners_csv = File.read('public/partners.csv')
    partners_array = CSV.parse(partners_csv, :headers => true )
    delivery_patners = {}
    partners_array.each do |array|
      size = array["Size Slab (in GB)"].strip.split('-')
      delivery_patners[array["Theatre"].strip] = [] if delivery_patners[array["Theatre"].strip].nil?
      delivery_patners[array["Theatre"].strip] << [size.first.to_i, size.last.to_i, array["Minimum cost"].to_i, array["Cost Per GB"].to_i, array["Partner ID"].strip]
    end
    delivery_patners
  end
        
  def get_deliveries
    
    deliveries_csv = File.read('public/input.csv')
    deliveries_array = CSV.parse(deliveries_csv, :headers => false )
    deliveries_array.map { |array| [array[0], array[1].to_i, array[2]] }
  end

  def write_output(name, arrays)
    output_csv = name
    CSV.open( output_csv, 'w' ) do |writer|
      arrays.each do |array|
        writer << array
      end
    end
  end





end