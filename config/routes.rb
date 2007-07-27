ActionController::Routing::Routes.draw do |map|

  map.connect '', :controller => 'login', :action => 'login'

  map.home '/forums/index', :controller => 'forums', :action => 'index'

#  map.resources :users, :member => { :admin => :post } do |user|
#    user.resources :moderators
#  end

  map.resources :forums do |forum|
    forum.resources :topics, :name_prefix => nil do |topic|
      topic.resources :posts, :name_prefix => nil
      topic.resource :monitorship, :controller => :monitorships, :name_prefix => nil
    end
  end

  map.resources :posts, :name_prefix => 'all_', :collection => { :search => :get }

  %w(user forum).each do |attr|
    map.resources :posts, :name_prefix => "#{attr}_", :path_prefix => "/#{attr.pluralize}/:#{attr}_id"
  end

  map.with_options :controller => 'posts', :action => 'monitored' do |map|
    map.formatted_monitored_posts 'users/:user_id/monitored.:format'
    map.monitored_posts           'users/:user_id/monitored'
  end

  map.exceptions 'logged_exceptions/:action/:id', :controller => 'logged_exceptions', :action => 'index', :id => nil

  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'


end
