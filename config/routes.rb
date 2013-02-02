Ssm::Application.routes.draw do
  match 'hosts/reload',  :controller => 'hosts', :action => 'reload'
  match 'hosts/fetch_hba',  :controller => 'hosts', :action => 'fetch_hba'
  match 'hosts/fetch_hba/:id',  :controller => 'hosts', :action => 'fetch_hba'
  match 'fabric/reload', :controller => 'fabric', :action => 'reload'
  match 'fabric/host/:id', :controller => 'fabric', :action => 'host', :as => 'fabric_host'
  match 'fabric', :controller => 'fabric', :action => 'index'
  resources :hosts
  root :to => 'hosts#index'
end
