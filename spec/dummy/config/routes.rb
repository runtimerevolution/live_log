Rails.application.routes.draw do
  mount LiveLog::Engine => "/live_log"
end
