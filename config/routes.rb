Rails.application.routes.draw do
  root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/solution_one", to: "solution_one#solution_one_csv"
  get "/solution_two", to: "solution_two#solution_two_csv"
  get "/welcome/csv_download_success", to: "welcome#csv_download_success"
  
end
