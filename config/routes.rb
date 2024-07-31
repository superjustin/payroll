Rails.application.routes.draw do
  resources :organizations do
    resources :payroll_periods do
      collection do
        post :generate_payroll_periods
        post :generate_custom_payroll_periods
        delete :clear_future_payroll_periods
      end
      member do
        delete :destroy
      end      
    end    
    resources :invoices, only: [:index]
  end

  resources :employees do
    resources :sessions, only: [:create, :update, :destroy]
  end

  root "organizations#index"
end
