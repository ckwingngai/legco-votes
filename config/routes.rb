Rails.application.routes.draw do
  root 'votes#list'
  get 'import' => 'votes#import'
  get 'api_get_item/:id' => 'votes#api_get_item'
end
