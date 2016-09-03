Rails.application.routes.draw do
  root 'votes#list'
  # get 'import/:year' => 'votes#import'
  # get 'import_item/:year/:date/(:pos)' => 'votes#import_item'
  get 'api_get_item/:id' => 'votes#api_get_item'
  # get 'destroy/:id' => 'votes#destroy'
  # get 'destroy_all' => 'votes#destroy_all'
end
